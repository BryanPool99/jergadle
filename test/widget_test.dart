// Smoke test: la app arranca y muestra el tablero.
// `flutter test`
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jergadle/app.dart';

void main() {
  testWidgets('Jergadle app renders the game board', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(const JergadleApp());
    await tester.pumpAndSettle();

    expect(find.text('JERGADLE'), findsOneWidget);
    expect(find.text('ENTER'), findsOneWidget);
  });
}
