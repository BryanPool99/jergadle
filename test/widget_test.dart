// Smoke test: la app arranca y muestra el título.
// `flutter test`
import 'package:flutter_test/flutter_test.dart';

import 'package:jergadle/app.dart';

void main() {
  testWidgets('Jergadle app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const JergadleApp());
    expect(find.text('Jergadle'), findsOneWidget);
  });
}
