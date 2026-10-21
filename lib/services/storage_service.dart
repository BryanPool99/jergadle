import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/daily_game.dart';
import '../models/game_stats.dart';

/// Servicio de persistencia local sobre `SharedPreferences`.
///
/// No hay backend: toda la información del jugador (estadísticas, rachas y la
/// partida del día) vive en el dispositivo.
class StorageService {
  StorageService({SharedPreferences? preferences}) : _prefs = preferences;

  /// Instancia cacheada de `SharedPreferences`.
  SharedPreferences? _prefs;

  /// Claves usadas en `SharedPreferences`.
  static const String keyStats = 'jergadle.stats';
  static const String keyLastDaily = 'jergadle.daily.last';
  static const String keyHistory = 'jergadle.history';
  static const String keyDictionaryVersion = 'jergadle.dict.version';
  static const String keySettings = 'jergadle.settings';

  /// Prefijo de las claves de partida diaria.
  static const String dailyKeyPrefix = 'jergadle.daily.';

  /// Instancia cacheada de `SharedPreferences`.
  Future<SharedPreferences> get _prefsInstance async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Inicializa el servicio (precarga `SharedPreferences`).
  Future<void> init() async {
    await _prefsInstance;
  }

  // ---------------------------------------------------------------------
  // Estadísticas
  // ---------------------------------------------------------------------

  /// Lee las estadísticas guardadas (o [GameStats.empty] si no hay ninguna).
  Future<GameStats> loadStats() async {
    final prefs = await _prefsInstance;
    return GameStats.decode(prefs.getString(keyStats));
  }

  /// Guarda las estadísticas.
  Future<void> saveStats(GameStats stats) async {
    final prefs = await _prefsInstance;
    await prefs.setString(keyStats, stats.encode());
  }

  // ---------------------------------------------------------------------
  // Partida diaria
  // ---------------------------------------------------------------------

  /// Clave de almacenamiento de la partida de un día.
  static String dailyKey(String dateKey) => '$dailyKeyPrefix$dateKey';

  /// Carga la partida guardada para [dateKey] (o `null` si no existe).
  Future<DailyGame?> loadDailyGame(String dateKey) async {
    final prefs = await _prefsInstance;
    final raw = prefs.getString(dailyKey(dateKey));
    if (raw == null || raw.isEmpty) return null;
    try {
      return DailyGame.decode(raw);
    } on FormatException {
      return null;
    }
  }

  /// Guarda la partida de [dateKey].
  Future<void> saveDailyGame(DailyGame game) async {
    final prefs = await _prefsInstance;
    await prefs.setString(dailyKey(game.dateKey), game.encode());
    await prefs.setString(keyLastDaily, game.dateKey);
  }

  /// Borra la partida guardada de [dateKey].
  Future<void> clearDailyGame(String dateKey) async {
    final prefs = await _prefsInstance;
    await prefs.remove(dailyKey(dateKey));
  }

  /// Clave `yyyy-MM-dd` de la última partida guardada.
  Future<String?> lastPlayedDateKey() async {
    final prefs = await _prefsInstance;
    return prefs.getString(keyLastDaily);
  }

  // ---------------------------------------------------------------------
  // Ajustes
  // ---------------------------------------------------------------------

  /// Lee los ajustes guardados (o los valores por defecto).
  Future<AppSettings> loadSettings() async {
    final prefs = await _prefsInstance;
    return AppSettings.decode(prefs.getString(keySettings));
  }

  /// Guarda los ajustes.
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await _prefsInstance;
    await prefs.setString(keySettings, settings.encode());
  }

  // ---------------------------------------------------------------------
  // Historial
  // ---------------------------------------------------------------------

  /// Historial de partidas como JSON (lista de strings `yyyy-MM-dd:won`).
  Future<List<String>> loadHistory() async {
    final prefs = await _prefsInstance;
    return prefs.getStringList(keyHistory) ?? <String>[];
  }

  /// Guarda el historial de partidas.
  Future<void> saveHistory(List<String> history) async {
    final prefs = await _prefsInstance;
    await prefs.setStringList(keyHistory, history);
  }

  /// Registra el resultado de una partida en el historial.
  ///
  /// El historial es una lista de entradas `"yyyy-MM-dd:W"` (victoria) o
  /// `"yyyy-MM-dd:L"` (derrota). Si ya existe una entrada para ese día, se
  /// sobrescribe para no duplicar.
  Future<void> recordHistoryEntry({required String dateKey, required bool won}) async {
    final history = await loadHistory();
    final entry = '$dateKey:${won ? 'W' : 'L'}';
    final existing = history.indexWhere((e) => e.startsWith('$dateKey:'));
    if (existing >= 0) {
      history[existing] = entry;
    } else {
      history.add(entry);
    }
    await saveHistory(history);
  }

  // ---------------------------------------------------------------------
  // Utilidades
  // ---------------------------------------------------------------------

  /// Borra todos los datos de Jergadle (reinicio total).
  Future<void> clearAll() async {
    final prefs = await _prefsInstance;
    await prefs.remove(keyStats);
    await prefs.remove(keyLastDaily);
    await prefs.remove(keyHistory);
    await prefs.remove(keySettings);
    final keys = prefs.getKeys().where((k) => k.startsWith(dailyKeyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
