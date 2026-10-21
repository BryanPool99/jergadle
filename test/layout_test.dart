import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';
import 'package:jergadle/ui/widgets/grid_board.dart';
import 'package:jergadle/ui/widgets/virtual_keyboard.dart';

import 'helpers/test_helpers.dart';

/// Verifica que el tablero y el teclado no se desbordan en distintos anchos
/// y que mantienen el mismo ancho (alineados).
void main() {
  const sizes = <Size>[
    Size(320, 700),
    Size(390, 844),
    Size(500, 900),
    Size(768, 1024),
    Size(1280, 900),
    Size(1920, 1080),
  ];

  for (final size in sizes) {
    testWidgets('layout sin desbordamiento a ${size.width}x${size.height}',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      tester.setScreenSize(size);

      tester.enableReducedMotion();
      await tester.pumpWidget(const JergadleApp());
      await tester.goToGame();

      final board = tester.getRect(find.byType(GridBoard));
      final keyboard = tester.getRect(find.byType(VirtualKeyboard));

      expect(board.left, greaterThanOrEqualTo(0));
      expect(keyboard.left, greaterThanOrEqualTo(0));
      expect(board.right, lessThanOrEqualTo(size.width + 0.5));
      expect(keyboard.right, lessThanOrEqualTo(size.width + 0.5));

      // Tablero y teclado alineados en el mismo eje vertical.
      expect((board.center.dx - keyboard.center.dx).abs(), lessThan(1.0));
    });
  }

  testWidgets('la pantalla de inicio se ve bien en movil',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    tester.setScreenSize(const Size(320, 700));

    tester.enableReducedMotion();
      await tester.pumpWidget(const JergadleApp());
    await tester.pumpAndSettle();

    expect(find.text('JERGADLE'), findsWidgets);
    expect(find.text('JUGAR'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

