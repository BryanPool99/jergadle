import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';
import 'package:jergadle/providers/game_provider.dart';
import 'package:jergadle/ui/screens/game_screen.dart';

/// Prueba de flujo completo sobre la UI real: escribir con el teclado
/// virtual, enviar, ver los colores y abrir el modal final.
void main() {
  /// Escribe una palabra pulsando las teclas del teclado virtual.
  Future<void> typeWord(WidgetTester tester, String word) async {
    for (final letter in word.split('')) {
      await tester.tap(find.byKey(ValueKey<String>('key-$letter')));
      await tester.pump();
    }
  }

  Future<void> pressEnter(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey<String>('key-ENTER')));
    await tester.pumpAndSettle();
  }

  testWidgets('flujo completo: escribir, enviar y ver el modal final',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const JergadleApp());
    await tester.pumpAndSettle();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );
    final secret = game.secretWord;
    expect(secret.length, 5);

    await typeWord(tester, secret);
    await pressEnter(tester);

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
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const JergadleApp());
    await tester.pumpAndSettle();

    final game = Provider.of<GameProvider>(
      tester.element(find.byType(GameScreen)),
      listen: false,
    );

    // Pierde la partida a propósito con 6 intentos inválidos.
    for (var i = 0; i < GameProvider.maxAttempts; i++) {
      await typeWord(tester, 'XXXXX');
      await pressEnter(tester);
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
