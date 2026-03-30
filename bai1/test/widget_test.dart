import 'package:flutter_test/flutter_test.dart';
import 'package:bai1/apps/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('MSSV: 6451071032'), findsOneWidget);
  });
}
