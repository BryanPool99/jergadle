import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';
import 'package:jergadle/core/theme/app_theme.dart';
import 'package:jergadle/models/game_guess.dart';
import 'package:jergadle/models/game_stats.dart';
import 'package:jergadle/ui/widgets/stats_dialog.dart';

import 'helpers/test_helpers.dart';

void main() {
  testWidgets('el tema claro se aplica cuando está guardado en preferencias',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      // Ajustes con el tema claro ya guardado (formato de AppSettings.encode).
      'jergadle.settings':
          '{"themeMode":"light","soundEnabled":false,'
              '"hapticsEnabled":false,"showKeyboardHints":true}',
    });
    tester.setScreenSize(const Size(420, 900));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.light);

    // El fondo del scaffold debe ser el claro, no el oscuro.
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, isNull);
    final context = tester.element(find.byType(Scaffold).first);
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      AppTheme.lightBackground,
    );
  });

  testWidgets('el texto principal es legible sobre fondo claro',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'jergadle.settings':
          '{"themeMode":"light","soundEnabled":false,'
              '"hapticsEnabled":false,"showKeyboardHints":true}',
    });
    tester.setScreenSize(const Size(420, 900));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    final theme = Theme.of(context);
    // El color de texto no puede ser igual al fondo.
    expect(theme.onBackground, isNot(theme.scaffoldBackgroundColor));
    expect(theme.onBackground, AppTheme.lightOnBackground);
  });

  group('Compartir con emojis', () {
    test('el cuadro de emojis refleja cada estado de letra', () {
      const guesses = <GameGuess>[
        GameGuess(
          word: 'TAPAS',
          results: <LetterResult>[
            LetterResult.absent,
            LetterResult.correct,
            LetterResult.absent,
            LetterResult.absent,
            LetterResult.present,
          ],
        ),
      ];

      final dialog = StatsDialog(
        stats: const GameStatsFixture().stats,
        wordEntry: null,
        won: false,
        attempts: 1,
        guesses: guesses,
      );

      expect(dialog.emojiGrid, '⬜🟩⬜⬜🟨');
      expect(dialog.shareText, contains('⬜🟩⬜⬜🟨'));
      // Al perder se muestra una X en lugar del número de intentos.
      expect(dialog.shareText, contains('Jergadle X/5'));
    });

    test('al ganar el encabezado lleva el número de intentos', () {
      final dialog = StatsDialog(
        stats: const GameStatsFixture().stats,
        wordEntry: null,
        won: true,
        attempts: 3,
        guesses: const <GameGuess>[
          GameGuess(
            word: 'PLATA',
            results: <LetterResult>[
              LetterResult.correct,
              LetterResult.correct,
              LetterResult.correct,
              LetterResult.correct,
              LetterResult.correct,
            ],
          ),
        ],
      );
      expect(dialog.shareText, contains('Jergadle 3/5'));
      expect(dialog.shareText, contains('🟩🟩🟩🟩🟩'));
    });

    test('el emoji de cada estado es el esperado', () {
      expect(StatsDialog.emojiFor(LetterResult.correct), '🟩');
      expect(StatsDialog.emojiFor(LetterResult.present), '🟨');
      expect(StatsDialog.emojiFor(LetterResult.absent), '⬜');
      expect(StatsDialog.emojiFor(LetterResult.none), '⬛');
    });

    test('sin intentos no hay cuadro de emojis', () {
      final dialog = StatsDialog(
        stats: const GameStatsFixture().stats,
        wordEntry: null,
        won: false,
        attempts: 0,
      );
      expect(dialog.emojiGrid, isEmpty);
    });
  });
}

/// Datos de prueba para el diálogo de estadísticas.
class GameStatsFixture {
  const GameStatsFixture();

  GameStats get stats => const GameStats(
        currentStreak: 3,
        maxStreak: 7,
        gamesPlayed: 10,
        gamesWon: 6,
      );
}
