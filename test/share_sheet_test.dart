import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';
import 'package:jergadle/providers/game_provider.dart';
import 'package:jergadle/ui/screens/game_screen.dart';
import 'package:jergadle/ui/widgets/stats_dialog.dart';

import 'helpers/test_helpers.dart';

/// Comprueba que la hoja de compartir no desborda, incluso en pantallas
/// pequeñas y con los 6 intentos usados.
void main() {
  /// Pulsa "Compartir" en el modal de estadísticas que ya está abierto.
  Future<void> openShareSheet(WidgetTester tester) async {
    expect(find.byType(StatsDialog), findsOneWidget);

    final shareButton = find.text('Compartir');
    await tester.ensureVisible(shareButton);
    await tester.pumpAndSettle();
    await tester.tap(shareButton);
    await tester.pumpAndSettle();
  }

  testWidgets('la hoja de compartir no desborda en pantalla pequeña',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    // Pantalla muy baja: es donde la hoja se desbordaba.
    tester.setScreenSize(const Size(360, 640));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );

    // 6 intentos: el caso máximo de filas de emojis.
    for (var i = 0; i < GameProvider.maxAttempts; i++) {
      await tester.typeWord('XXXXX');
      await tester.pressEnter();
    }
    expect(game.isLost, isTrue);

    await openShareSheet(tester);

    // La hoja está abierta y no hubo ningún error de layout.
    expect(find.text('Copiar resultado'), findsOneWidget);
    expect(find.text('TU RESULTADO'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la hoja de compartir no desborda con una partida ganada',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(360, 640));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );

    await tester.typeWord(game.secretWord);
    await tester.pressEnter();
    expect(game.isWin, isTrue);

    await openShareSheet(tester);

    expect(find.text('Copiar resultado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el modal final muestra el cuadro de emojis',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(420, 900));
    tester.enableReducedMotion();

    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );

    await tester.typeWord(game.secretWord);
    await tester.pressEnter();

    // El modal de estadísticas ya muestra el cuadro de emojis.
    expect(find.text('TU RESULTADO'), findsOneWidget);
    expect(find.textContaining('🟩'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

