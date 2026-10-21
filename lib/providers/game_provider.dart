import 'package:flutter/foundation.dart';

import '../models/daily_game.dart';
import '../models/game_guess.dart';
import '../models/game_stats.dart';
import '../models/word_entry.dart';
import '../services/letter_evaluator.dart';
import '../services/storage_service.dart';
import '../services/word_service.dart';
import '../utils/day_key.dart';

/// Lógica completa del juego de Jergadle.
///
/// Es un [ChangeNotifier]: la UI (teclado, tablero, header, diálogos) se
/// redibuja con `ListenableBuilder` / `Consumer` cada vez que cambia el
/// estado.
class GameProvider extends ChangeNotifier {
  GameProvider({
    required this.storage,
    WordService? wordService,
    DateTime Function()? clock,
  })  : _wordService = wordService ?? WordService(),
        _clock = clock ?? DateTime.now;

  /// Servicio de almacenamiento usado por el proveedor.
  final StorageService storage;

  final WordService _wordService;
  final DateTime Function() _clock;

  /// Servicio de palabras del día.
  WordService get wordService => _wordService;

  /// Número máximo de intentos por partida.
  static const int maxAttempts = 6;

  /// Longitud de la palabra secreta.
  static const int wordLength = 5;

  // ---------------------------------------------------------------------
  // Estado
  // ---------------------------------------------------------------------

  bool _isLoading = true;
  bool _isInitialized = false;
  String _currentInput = '';
  String _secretWord = '';
  WordEntry? _secretEntry;
  String _dateKey = '';
  int _secretIndex = 0;
  GameStatus _status = GameStatus.playing;
  List<GameGuess> _guesses = <GameGuess>[];
  Map<String, LetterResult> _keyboardState = <String, LetterResult>{};
  GameStats _stats = GameStats.empty;
  bool _statsRecordedForDay = false;
  bool _inPractice = false;
  int _invalidAttemptCount = 0;

  /// `true` mientras se restaura el estado desde el almacenamiento.
  bool get isLoading => _isLoading;

  /// `true` cuando la aplicación ya terminó de inicializarse.
  bool get isInitialized => _isInitialized;

  /// Letras escritas actualmente en la fila activa.
  String get currentInput => _currentInput;

  /// Palabra secreta del día.
  String get secretWord => _secretWord;

  /// Entrada completa de la palabra del día (palabra + definición).
  WordEntry? get secretEntry => _secretEntry;

  /// Definición peruana de la jerga del día.
  String get secretDefinition => _secretEntry?.definition ?? '';

  /// Clave `yyyy-MM-dd` del día en juego.
  String get dateKey => _dateKey;

  /// Intentos ya enviados.
  List<GameGuess> get guesses => List<GameGuess>.unmodifiable(_guesses);

  /// Estado de la partida actual.
  GameStatus get status => _status;

  /// `true` si la partida terminó (ganada o perdida).
  bool get isGameOver => _status != GameStatus.playing;

  /// `true` si el usuario adivinó la palabra.
  bool get isWin => _status == GameStatus.won;

  /// `true` si el usuario agotó los intentos.
  bool get isLost => _status == GameStatus.lost;

  /// Número de intentos realizados.
  int get attemptsUsed => _guesses.length;

  /// Intentos restantes.
  int get attemptsRemaining => maxAttempts - _guesses.length;

  /// Estadísticas del jugador.
  GameStats get stats => _stats;

  /// Racha actual.
  int get currentStreak => _stats.currentStreak;

  /// Mejor racha.
  int get maxStreak => _stats.maxStreak;

  /// Porcentaje de partidas ganadas.
  double get winRate => _stats.winRate;

  /// Estado de color de cada tecla del teclado.
  Map<String, LetterResult> get keyboardState =>
      Map<String, LetterResult>.unmodifiable(_keyboardState);

  /// `true` si el día actual ya tiene una partida registrada (ganada o perdida).
  bool get hasPlayedToday => _statsRecordedForDay;

  /// `true` si el usuario está jugando en modo práctica (no cuenta para las
  /// estadísticas ni sobrescribe la partida del día).
  bool get isPractice => _inPractice;

  /// Contador de intentos inválidos enviados.
  ///
  /// La UI lo escucha para disparar la animación de aviso.
  int get invalidAttemptCount => _invalidAttemptCount;

  /// `true` si la fila activa ya está completa (5 letras).
  bool get canSubmit => _currentInput.length == wordLength;

  /// `true` si aún se puede escribir.
  bool get canType => !isGameOver;

  // ---------------------------------------------------------------------
  // Inicialización
  // ---------------------------------------------------------------------

  /// Restaura el estado persistido y prepara la partida del día.
  ///
  /// Si el almacenamiento no está disponible (modo privado, cuota llena, etc.)
  /// la partida sigue siendo jugable: simplemente no se restaura el progreso.
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final today = _clock();
    _dateKey = DayKey.of(today);
    _inPractice = false;

    try {
      await storage.init();
      _stats = await storage.loadStats();
    } catch (_) {
      _stats = GameStats.empty;
    }

    DailyGame? saved;
    try {
      saved = await storage.loadDailyGame(_dateKey);
    } catch (_) {
      saved = null;
    }

    if (saved != null) {
      _restore(saved);
      // Las estadísticas ya se contabilizaron si el último día jugado es hoy.
      _statsRecordedForDay = _stats.lastPlayedDate == _dateKey;
      // Si la partida terminó pero las estadísticas no llegaron a guardarse
      // (la app se cerró justo después del último intento), se corrige ahora.
      if (saved.isFinished && !_statsRecordedForDay) {
        await _recordStatsIfNeeded(
          won: saved.isWin,
          attempts: saved.guesses.length,
        );
      }
    } else {
      _secretIndex = _wordService.indexForDate(today);
      final entry = _wordService.entryForDate(today);
      _secretEntry = entry;
      _secretWord = entry.normalized;
      _guesses = <GameGuess>[];
      _keyboardState = <String, LetterResult>{};
      _status = GameStatus.playing;
      _currentInput = '';
      await _safeSave(
        DailyGame(
          dateKey: _dateKey,
          secretIndex: _secretIndex,
          secretWord: _secretWord,
        ),
      );
    }

    _isLoading = false;
    _isInitialized = true;
    notifyListeners();
  }

  /// Guarda la partida sin propagar errores de almacenamiento.
  Future<void> _safeSave(DailyGame game) async {
    try {
      await storage.saveDailyGame(game);
    } catch (_) {
      // Sin persistencia la partida sigue siendo jugable en memoria.
    }
  }

  /// Restaura una partida guardada.
  void _restore(DailyGame game) {
    _secretIndex = game.secretIndex;
    _secretWord = game.secretWord;
    _secretEntry = _lookupEntry(game.secretWord, game.secretIndex);
    _guesses = List<GameGuess>.from(game.guesses);
    _status = game.status;
    _currentInput = '';
    _keyboardState = <String, LetterResult>{};
    for (final guess in _guesses) {
      _applyKeyboardState(guess);
    }
  }

  /// Busca la entrada del diccionario correspondiente a [word].
  WordEntry? _lookupEntry(String word, int index) {
    final list = _wordService.words;
    if (index >= 0 && index < list.length && list[index].normalized == word) {
      return list[index];
    }
    for (final entry in list) {
      if (entry.normalized == word) return entry;
    }
    return null;
  }

  // ---------------------------------------------------------------------
  // Interacción con el teclado
  // ---------------------------------------------------------------------

  /// Escribe la letra [letter] en la fila activa.
  void addLetter(String letter) {
    if (!canType) return;
    final clean = letter.toUpperCase();
    if (clean.length != 1) return;
    if (_currentInput.length >= wordLength) return;
    if (!'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ'.contains(clean)) return;
    _currentInput += clean;
    notifyListeners();
  }

  /// Borra la última letra escrita.
  void backspace() {
    if (!canType) return;
    if (_currentInput.isEmpty) return;
    _currentInput = _currentInput.substring(0, _currentInput.length - 1);
    notifyListeners();
  }

  /// Envía el intento actual.
  ///
  /// Devuelve `true` si el intento fue válido y se evaluó.
  Future<bool> submitGuess() async {
    if (isGameOver) return false;
    if (!canSubmit) {
      _rejectAttempt();
      return false;
    }
    if (!LetterEvaluator.isValidGuess(_currentInput)) {
      _rejectAttempt();
      return false;
    }

    final result = LetterEvaluator.evaluate(
      guess: _currentInput,
      secret: _secretWord,
    );
    final guess = GameGuess(word: result.word, results: result.results);

    _guesses = <GameGuess>[..._guesses, guess];
    _currentInput = '';
    _applyKeyboardState(guess);

    if (result.isWin) {
      _status = GameStatus.won;
    } else if (_guesses.length >= maxAttempts) {
      _status = GameStatus.lost;
    }

    notifyListeners();
    if (_inPractice) {
      // El modo práctica no altera la partida guardada del día ni las
      // estadísticas.
      return true;
    }
    await _persistGame();
    // Las estadísticas sólo cuentan cuando la partida termina (ganada o
    // perdida), no en cada intento.
    if (isGameOver) {
      await _recordStatsIfNeeded(won: result.isWin, attempts: _guesses.length);
    }
    return true;
  }

  /// Marca un intento como inválido para que la UI pueda avisar (con una
  /// animación de "sacudida" y un sonido de error).
  void _rejectAttempt() {
    _invalidAttemptCount++;
    notifyListeners();
  }

  /// Actualiza el color del teclado aplicando la prioridad
  /// verde > amarillo > gris.
  void _applyKeyboardState(GameGuess guess) {    for (var i = 0; i < guess.word.length && i < guess.results.length; i++) {
      final letter = guess.word[i];
      final result = guess.results[i];
      final current = _keyboardState[letter];
      if (current == null || result.priority > current.priority) {
        _keyboardState[letter] = result;
      }
    }
  }

  // ---------------------------------------------------------------------
  // Persistencia
  // ---------------------------------------------------------------------

  /// Guarda la partida actual en `SharedPreferences`.
  Future<void> _persistGame() async {
    await _safeSave(
      DailyGame(
        dateKey: _dateKey,
        secretIndex: _secretIndex,
        secretWord: _secretWord,
        guesses: _guesses,
        status: _status,
      ),
    );
  }

  /// Actualiza rachas y estadísticas (solo una vez por día).
  Future<void> _recordStatsIfNeeded({
    required bool won,
    required int attempts,
  }) async {
    if (_statsRecordedForDay) return;
    _statsRecordedForDay = true;

    _stats = won
        ? _stats.recordWin(attempts: attempts, date: _clock())
        : _stats.recordResult(won: false, date: _clock());

    try {
      await storage.saveStats(_stats);
      await storage.recordHistoryEntry(dateKey: _dateKey, won: won);
    } catch (_) {
      // Sin persistencia, las estadísticas sólo viven en memoria.
    }
  }

  /// Comprueba si cambió el día (la app quedó abierta a medianoche) y, si es
  /// así, prepara una partida nueva.
  Future<void> checkNewDay() async {
    final today = DayKey.of(_clock());
    if (today == _dateKey) return;
    await init();
  }

  /// Reinicia el progreso diario manteniendo las estadísticas (modo práctica).
  ///
  /// Permite seguir jugando después de perder o ganar la palabra del día; no
  /// afecta rachas ni estadísticas, pero tampoco se guarda como partida
  /// diaria.
  Future<void> startPractice() async {
    if (!isGameOver) return;
    _inPractice = true;
    _guesses = <GameGuess>[];
    _keyboardState = <String, LetterResult>{};
    _currentInput = '';
    _status = GameStatus.playing;
    notifyListeners();
  }

  /// Borra todos los datos locales (estadísticas, rachas e historial).
  Future<void> resetAll() async {
    await storage.clearAll();
    _stats = GameStats.empty;
    await init();
  }

  // ---------------------------------------------------------------------
  // Utilidades para la UI
  // ---------------------------------------------------------------------

  /// Texto de las filas del tablero (incluye la fila en curso).
  List<List<String>> get boardLetters {
    final rows = <List<String>>[];
    for (final guess in _guesses) {
      rows.add(guess.word.split(''));
    }
    if (_currentInput.isNotEmpty && !isGameOver) {
      rows.add(_currentInput.split(''));
    }
    return rows;
  }

  /// Estado de cada celda del tablero.
  ///
  /// Devuelve una matriz de 6 filas x 5 columnas donde cada celda es
  /// `[letra, estado]`. Las celdas vacías usan [LetterResult.none].
  List<List<({String letter, LetterResult result})>> get board {
    final rows = <List<({String letter, LetterResult result})>>[];
    for (final guess in _guesses) {
      rows.add(<({String letter, LetterResult result})>[
        for (var i = 0; i < guess.word.length; i++)
          (letter: guess.word[i], result: guess.results[i]),
      ]);
    }
    // Fila en curso con las letras escritas (siempre 5 celdas).
    if (!isGameOver) {
      final typed = _currentInput.split('');
      rows.add(<({String letter, LetterResult result})>[
        for (var i = 0; i < wordLength; i++)
          (
            letter: i < typed.length ? typed[i] : '',
            result: LetterResult.none,
          ),
      ]);
    }
    // Rellenar las filas restantes con celdas vacías.
    while (rows.length < maxAttempts) {
      rows.add(List<({String letter, LetterResult result})>.filled(
        wordLength,
        (letter: '', result: LetterResult.none),
      ));
    }
    return rows;
  }

  /// Resultado del intento en [rowIndex] (o `null` si la fila está vacía).
  GuessResult? resultAt(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= _guesses.length) return null;
    return _guesses[rowIndex].result;
  }
}
