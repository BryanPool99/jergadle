import 'package:flutter_test/flutter_test.dart';
import 'package:jergadle/models/daily_game.dart';
import 'package:jergadle/models/game_guess.dart';
import 'package:jergadle/models/word_entry.dart';
import 'package:jergadle/providers/game_provider.dart';
import 'package:jergadle/services/storage_service.dart';
import 'package:jergadle/services/word_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late StorageService storage;
  late DateTime now;

  /// Proveedor con un diccionario de una sola palabra para poder ganar
  /// de forma determinista.
  GameProvider buildProvider({List<String> words = const <String>['PLATA']}) {
    final service = WordService(
      words: words
          .map((w) => WordEntry(word: w, definition: 'Definición de $w'))
          .toList(growable: false),
    );
    return GameProvider(
      storage: storage,
      wordService: service,
      clock: () => now,
    );
  }

  /// Escribe una palabra completa en el teclado virtual.
  void type(GameProvider game, String word) {
    for (final letter in word.split('')) {
      game.addLetter(letter);
    }
  }

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    storage = StorageService();
    now = DateTime(2026, 3, 15, 10, 30);
  });

  group('GameProvider', () {
    test('inicializa la partida del día con 5 letras', () async {
      final game = buildProvider();
      await game.init();

      expect(game.isInitialized, isTrue);
      expect(game.secretWord, 'PLATA');
      expect(game.guesses, isEmpty);
      expect(game.status, GameStatus.playing);
      expect(game.currentInput, isEmpty);
    });

    test('escribe y borra letras', () async {
      final game = buildProvider();
      await game.init();

      type(game, 'PLA');
      expect(game.currentInput, 'PLA');

      game.backspace();
      expect(game.currentInput, 'PL');

      type(game, 'AT');
      expect(game.currentInput, 'PLAT');
      expect(game.canSubmit, isFalse);

      game.addLetter('A');
      expect(game.currentInput, 'PLATA');
      expect(game.canSubmit, isTrue);
    });

    test('no permite escribir más de 5 letras', () async {
      final game = buildProvider();
      await game.init();

      type(game, 'PLATAS');
      expect(game.currentInput, 'PLATA');
    });

    test('al ganar se actualizan estado, rachas y estadísticas', () async {
      final game = buildProvider();
      await game.init();

      type(game, 'PLATA');
      final ok = await game.submitGuess();

      expect(ok, isTrue);
      expect(game.isWin, isTrue);
      expect(game.isGameOver, isTrue);
      expect(game.guesses.length, 1);
      expect(game.currentStreak, 1);
      expect(game.maxStreak, 1);
      expect(game.stats.gamesWon, 1);
      expect(game.stats.guessDistribution[0], 1);
    });

    test('al agotar intentos se pierde y la racha vuelve a 0', () async {
      final game = buildProvider();
      await game.init();

      for (var i = 0; i < GameProvider.maxAttempts; i++) {
        type(game, 'XXXXX');
        await game.submitGuess();
      }

      expect(game.isLost, isTrue);
      expect(game.currentStreak, 0);
      expect(game.stats.gamesPlayed, 1);
      expect(game.stats.gamesWon, 0);
    });

    test('el color del teclado respeta la prioridad verde > amarillo > gris',
        () async {
      final game = buildProvider();
      await game.init();

      // Secreto PLATA, intento TALPA:
      // T presente, L presente, A correcto, P presente, A correcto.
      type(game, 'TALPA');
      await game.submitGuess();

      expect(game.keyboardState['T'], LetterResult.present);
      expect(game.keyboardState['L'], LetterResult.present);
      expect(game.keyboardState['A'], LetterResult.correct);
      expect(game.keyboardState['P'], LetterResult.present);

      // Una letra verde no puede ser degradada a amarillo/gris.
      type(game, 'AAAAA');
      await game.submitGuess();
      expect(game.keyboardState['A'], LetterResult.correct);
    });

    test('el estado del día se restaura tras recargar la app', () async {
      final game = buildProvider();
      await game.init();

      type(game, 'TALPA');
      await game.submitGuess();

      // Nueva instancia = nuevo arranque de la app.
      final restored = buildProvider();
      await restored.init();

      expect(restored.guesses.length, 1);
      expect(restored.guesses.first.word, 'TALPA');
      expect(restored.keyboardState['A'], LetterResult.correct);
      expect(restored.isGameOver, isFalse);
    });

    test('la partida del día se bloquea tras ganar y no admite más intentos',
        () async {
      final game = buildProvider();
      await game.init();

      type(game, 'PLATA');
      await game.submitGuess();

      type(game, 'XXXXX');
      final ok = await game.submitGuess();
      expect(ok, isFalse);
      expect(game.guesses.length, 1);
    });

    test('el modo práctica reinicia el tablero sin tocar las estadísticas',
        () async {
      final game = buildProvider();
      await game.init();

      type(game, 'PLATA');
      await game.submitGuess();
      final streakBefore = game.currentStreak;

      await game.startPractice();

      expect(game.guesses, isEmpty);
      expect(game.isGameOver, isFalse);
      expect(game.currentStreak, streakBefore);
      expect(game.stats.gamesWon, 1);
    });

    test('las estadísticas se guardan en SharedPreferences', () async {
      final game = buildProvider();
      await game.init();
      type(game, 'PLATA');
      await game.submitGuess();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(StorageService.keyStats), isNotNull);
      expect(
        prefs.getString(StorageService.dailyKey('2026-03-15')),
        isNotNull,
      );
    });
  });
}
