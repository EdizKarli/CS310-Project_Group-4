import 'package:cinedeb/screens/forgot_password_screen.dart';
import 'package:cinedeb/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp({
    VoidCallback? onBackToLoginTap,
    VoidCallback? onResetRequested,
  }) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: ForgotPasswordScreen(
        onBackToLoginTap: onBackToLoginTap,
        onResetRequested: onResetRequested,
      ),
    );
  }

  testWidgets('ForgotPasswordScreen renders key UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.text('CINEDEB'), findsOneWidget);
    expect(find.text('Reset Your Password'), findsOneWidget);
    expect(find.text('Email Address*'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
    expect(find.text('Back to Log In'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen validates email and triggers reset', (
    WidgetTester tester,
  ) async {
    bool resetRequested = false;
    await tester.pumpWidget(
      buildTestApp(onResetRequested: () => resetRequested = true),
    );

    // Empty submission shows validation error.
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();
    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(resetRequested, isFalse);

    // Invalid email format shows validation error.
    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();
    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(resetRequested, isFalse);

    // Valid email triggers onResetRequested.
    await tester.enterText(find.byType(TextFormField), 'user@cinedeb.app');
    await tester.tap(find.text('Send Reset Link'));
    await tester.pump();
    expect(resetRequested, isTrue);
  });

  testWidgets('ForgotPasswordScreen Back to Log In opens LoginScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Back to Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Login to CineDeb'), findsOneWidget);
  });
}
