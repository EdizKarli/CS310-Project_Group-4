import 'package:flutter_test/flutter_test.dart';

import 'package:cinedeb/main.dart';

void main() {
  testWidgets('App starts on Login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CineDebApp());
    expect(find.text('Login to CineDeb'), findsOneWidget);
  });
}
