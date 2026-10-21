import 'dart:convert';

import '../utils/day_key.dart';

/// Estadísticas acumuladas del jugador.
///
/// Es un objeto **inmutable**: cada operación devuelve una nueva instancia,
/// lo que facilita el guardado en `SharedPreferences` y las pruebas unitarias.
class GameStats {
  const GameStats({
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.guessDistribution = const <int>[0, 0, 0, 0, 0, 0],
    this.lastPlayedDate,
  });

  /// Racha actual de victorias consecutivas (días seguidos ganando).
  final int currentStreak;

  /// Mejor racha alcanzada históricamente.
  final int maxStreak;

  /// Total de partidas jugadas (ganadas + perdidas).
  final int gamesPlayed;

  /// Total de partidas ganadas.
  final int gamesWon;

  /// Distribución de aciertos: índice 0 = 1 intento, ... índice 5 = 6 intentos.
  final List<int> guessDistribution;

  /// Clave `yyyy-MM-dd` del último día en el que se jugó una partida.
  final String? lastPlayedDate;

  /// Porcentaje de partidas ganadas (0-100).
  double get winRate =>
      gamesPlayed == 0 ? 0 : (gamesWon / gamesPlayed) * 100;

  /// Estadísticas vacías (primer arranque).
  static const GameStats empty = GameStats();

  /// Registra el resultado de una partida finalizada en [date].
  ///
  /// - Si [won] es `true` la racha aumenta (o se reinicia en 1 si el usuario
  ///   saltó días).
  /// - Si [won] es `false` la racha vuelve a 0.
  /// - Registrar dos veces el mismo día no altera la racha: solo cuenta la
  ///   primera partida de cada día para la secuencia, pero sí acumula en los
  ///   contadores globales.
  GameStats recordResult({required bool won, required DateTime date}) {
    final today = DayKey.of(date);
    final isNewDay = lastPlayedDate != today;

    int newStreak = currentStreak;
    if (isNewDay) {
      final continued = lastPlayedDate != null &&
          DayKey.isConsecutive(lastPlayedDate!, today);
      newStreak = won ? (continued ? currentStreak + 1 : 1) : 0;
    }

    final newMax = newStreak > maxStreak ? newStreak : maxStreak;

    return GameStats(
      currentStreak: newStreak,
      maxStreak: newMax,
      gamesPlayed: gamesPlayed + 1,
      gamesWon: gamesWon + (won ? 1 : 0),
      guessDistribution: List<int>.from(guessDistribution),
      lastPlayedDate: today,
    );
  }

  /// Registra una victoria concretando en cuántos intentos se resolvió.
  GameStats recordWin({required int attempts, required DateTime date}) {
    final base = recordResult(won: true, date: date);
    final distribution = List<int>.from(base.guessDistribution);
    final idx = (attempts - 1).clamp(0, distribution.length - 1);
    distribution[idx] += 1;
    return GameStats(
      currentStreak: base.currentStreak,
      maxStreak: base.maxStreak,
      gamesPlayed: base.gamesPlayed,
      gamesWon: base.gamesWon,
      guessDistribution: distribution,
      lastPlayedDate: base.lastPlayedDate,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'currentStreak': currentStreak,
        'maxStreak': maxStreak,
        'gamesPlayed': gamesPlayed,
        'gamesWon': gamesWon,
        'guessDistribution': guessDistribution,
        'lastPlayedDate': lastPlayedDate,
      };

  String encode() => jsonEncode(toJson());

  factory GameStats.fromJson(Map<String, dynamic> json) {
    final rawDist = json['guessDistribution'];
    final dist = <int>[0, 0, 0, 0, 0, 0];
    if (rawDist is List) {
      for (var i = 0; i < dist.length && i < rawDist.length; i++) {
        dist[i] = (rawDist[i] as num?)?.toInt() ?? 0;
      }
    }
    return GameStats(
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      maxStreak: (json['maxStreak'] as num?)?.toInt() ?? 0,
      gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
      gamesWon: (json['gamesWon'] as num?)?.toInt() ?? 0,
      guessDistribution: dist,
      lastPlayedDate: json['lastPlayedDate'] as String?,
    );
  }

  factory GameStats.decode(String? raw) {
    if (raw == null || raw.isEmpty) return GameStats.empty;
    try {
      return GameStats.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return GameStats.empty;
    }
  }

  @override
  String toString() =>
      'GameStats(streak: $currentStreak/$maxStreak, played: $gamesPlayed, '
      'won: $gamesWon)';
}
