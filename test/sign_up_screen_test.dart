import 'package:cinedeb/screens/sign_up_screen.dart';
import 'package:cinedeb/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp({
    VoidCallback? onLoginTap,
    VoidCallback? onSignUpSuccess,
  }) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: SignUpScreen(
        onLoginTap: onLoginTap,
        onSignUpSuccess: onSignUpSuccess,
      ),
    );
  }

  testWidgets('SignUpScreen renders key UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.text('CINEDEB'), findsOneWidget);
    expect(find.text('Create a CineDeb Account'), findsOneWidget);
    expect(find.text('Log In'), findsNWidgets(2));
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('User Handle*'), findsOneWidget);
    expect(find.text('Email Address*'), findsOneWidget);
    expect(find.text('Password*'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('SignUpScreen validates fields and triggers onSignUpSuccess', (
    WidgetTester tester,
  ) async {
    bool signedUp = false;
    await tester.pumpWidget(
      buildTestApp(onSignUpSuccess: () => signedUp = true),
    );

    await tester.tap(find.text('Create Account'));
    await tester.pump();
    expect(find.text('Please enter a user handle'), findsOneWidget);
    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(signedUp, isFalse);

    final Finder fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '@cinephile');
    await tester.enterText(fields.at(1), 'user@cinedeb.app');
    await tester.enterText(fields.at(2), 'secretPW');
    await tester.tap(find.text('Create Account'));
    await tester.pump();
    expect(signedUp, isTrue);
  });

  testWidgets('SignUpScreen valid submission opens ReviewsScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    final Finder fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '@cinephile');
    await tester.enterText(fields.at(1), 'user@cinedeb.app');
    await tester.enterText(fields.at(2), 'secretPW');
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('Reviews'), findsOneWidget);
  });
}
