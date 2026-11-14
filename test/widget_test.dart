import 'package:flutter_test/flutter_test.dart';

import 'package:cinedeb/main.dart';

void main() {
  testWidgets('App starts',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CineDebApp());
    expect(find.text('Reviews'), findsOneWidget);
  });
}
