import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';
import 'package:jergadle/providers/game_provider.dart';
import 'package:jergadle/ui/screens/game_screen.dart';

import 'helpers/test_helpers.dart';

/// Prueba de flujo completo sobre la UI real: escribir con el teclado
/// virtual, enviar, ver los colores y abrir el modal final.
void main() {
  testWidgets('flujo completo: escribir, enviar y ver el modal final',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(1280, 900));

    tester.enableReducedMotion();
    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );
    final secret = game.secretWord;
    expect(secret.length, 5);

    await tester.typeWord(secret);
    await tester.pressEnter();

    expect(game.isWin, isTrue);
    expect(game.currentStreak, 1);
    expect(game.stats.gamesWon, 1);

    // El modal final debe mostrarse con el significado de la jerga.
    expect(find.text('QUÉ SIGNIFICA EN EL PERÚ'), findsOneWidget);
    expect(find.text('¡Ganaste, causa!'), findsOneWidget);
  });

  testWidgets('el modal muestra las rachas y el porcentaje de aciertos',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(1280, 900));

    tester.enableReducedMotion();
    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );

    // Pierde la partida a propósito con 6 intentos inválidos.
    for (var i = 0; i < GameProvider.maxAttempts; i++) {
      await tester.typeWord('XXXXX');
      await tester.pressEnter();
    }

    expect(game.isLost, isTrue);
    expect(game.currentStreak, 0);

    expect(find.text('Racha actual'), findsOneWidget);
    expect(find.text('Mejor racha'), findsOneWidget);
    expect(find.text('% de aciertos'), findsOneWidget);
    // "0%" aparece en el modal y también en el panel lateral de la web.
    expect(find.text('0%'), findsWidgets);
  });
}

