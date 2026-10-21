import 'package:flutter_test/flutter_test.dart';
import 'package:jergadle/models/game_stats.dart';

void main() {
  group('GameStats', () {
    final day1 = DateTime(2026, 3, 15);
    final day2 = DateTime(2026, 3, 16);
    final day3 = DateTime(2026, 3, 17);
    final day10 = DateTime(2026, 3, 24);

    test('valores iniciales', () {
      const stats = GameStats.empty;
      expect(stats.currentStreak, 0);
      expect(stats.maxStreak, 0);
      expect(stats.gamesPlayed, 0);
      expect(stats.gamesWon, 0);
      expect(stats.winRate, 0);
    });

    test('la racha aumenta al ganar días consecutivos', () {
      var stats = GameStats.empty.recordWin(attempts: 3, date: day1);
      expect(stats.currentStreak, 1);
      expect(stats.maxStreak, 1);

      stats = stats.recordWin(attempts: 4, date: day2);
      expect(stats.currentStreak, 2);
      expect(stats.maxStreak, 2);

      stats = stats.recordWin(attempts: 2, date: day3);
      expect(stats.currentStreak, 3);
      expect(stats.maxStreak, 3);
      expect(stats.gamesWon, 3);
      expect(stats.gamesPlayed, 3);
    });

    test('la racha se reinicia si se pierde', () {
      var stats = GameStats.empty
          .recordWin(attempts: 3, date: day1)
          .recordWin(attempts: 3, date: day2)
          .recordResult(won: false, date: day3);
      expect(stats.currentStreak, 0);
      expect(stats.maxStreak, 2, reason: 'La mejor racha debe conservarse');
    });

    test('la racha se reinicia a 1 si se salta un día', () {
      final stats = GameStats.empty
          .recordWin(attempts: 3, date: day1)
          .recordWin(attempts: 3, date: day10);
      expect(stats.currentStreak, 1);
      expect(stats.maxStreak, 1);
    });

    test('jugar dos veces el mismo día no altera la racha', () {
      var stats = GameStats.empty.recordWin(attempts: 3, date: day1);
      stats = stats.recordWin(attempts: 3, date: day1);
      expect(stats.currentStreak, 1);
      expect(stats.gamesPlayed, 2);
    });

    test('el porcentaje de aciertos se calcula correctamente', () {
      final stats = GameStats.empty
          .recordWin(attempts: 3, date: day1)
          .recordResult(won: false, date: day2)
          .recordWin(attempts: 5, date: day3);
      expect(stats.gamesPlayed, 3);
      expect(stats.gamesWon, 2);
      expect(stats.winRate, closeTo(66.66, 0.1));
    });

    test('la distribución de intentos cuenta las victorias', () {
      final stats = GameStats.empty
          .recordWin(attempts: 1, date: day1)
          .recordWin(attempts: 1, date: day2)
          .recordWin(attempts: 6, date: day3);
      expect(stats.guessDistribution[0], 2);
      expect(stats.guessDistribution[5], 1);
    });

    test('serializa y deserializa sin perder datos', () {
      final stats = GameStats.empty
          .recordWin(attempts: 3, date: day1)
          .recordResult(won: false, date: day2);
      final decoded = GameStats.decode(stats.encode());
      expect(decoded.currentStreak, stats.currentStreak);
      expect(decoded.maxStreak, stats.maxStreak);
      expect(decoded.gamesPlayed, stats.gamesPlayed);
      expect(decoded.gamesWon, stats.gamesWon);
      expect(decoded.guessDistribution, stats.guessDistribution);
      expect(decoded.lastPlayedDate, stats.lastPlayedDate);
    });

    test('un payload corrupto devuelve estadísticas vacías', () {
      expect(GameStats.decode('no-json').gamesPlayed, 0);
      expect(GameStats.decode(null).gamesPlayed, 0);
    });
  });
}
