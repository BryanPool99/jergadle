// Smoke test: la app arranca y muestra la pantalla de inicio.
// `flutter test`
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';

import 'helpers/test_helpers.dart';

void main() {
  testWidgets('Jergadle app renders the home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    tester.enableReducedMotion();
    await tester.pumpWidget(const JergadleApp());
    await tester.pumpAndSettle();

    expect(find.text('JERGADLE'), findsWidgets);
    expect(find.text('JUGAR'), findsOneWidget);
  });

  testWidgets('se puede entrar al juego desde el inicio', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    tester.enableReducedMotion();
    await tester.pumpWidget(const JergadleApp());
    await tester.goToGame();

    expect(find.text('ENTER'), findsOneWidget);
    expect(find.text('JUGAR'), findsNothing);
  });
}

