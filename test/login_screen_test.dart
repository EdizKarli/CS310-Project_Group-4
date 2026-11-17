import 'package:cinedeb/screens/login_screen.dart';
import 'package:cinedeb/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestApp({
    VoidCallback? onSignUpTap,
    VoidCallback? onForgotPasswordTap,
    VoidCallback? onLoginSuccess,
  }) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: LoginScreen(
        onSignUpTap: onSignUpTap,
        onForgotPasswordTap: onForgotPasswordTap,
        onLoginSuccess: onLoginSuccess,
      ),
    );
  }

  testWidgets('LoginScreen renders key UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.text('CINEDEB'), findsOneWidget);
    expect(find.text('Login to CineDeb'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Email or User Handle*'), findsOneWidget);
    expect(find.text('Password*'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);
  });

  testWidgets('LoginScreen validates empty fields and toggles password visibility', (
    WidgetTester tester,
  ) async {
    bool loggedIn = false;
    await tester.pumpWidget(
      buildTestApp(onLoginSuccess: () => loggedIn = true),
    );

    // Submitting empty form shows validation errors.
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Please enter your email or @handle'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(loggedIn, isFalse);

    // Toggle password visibility icon.
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    // Valid input triggers onLoginSuccess.
    final Finder fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '@cinephile');
    await tester.enterText(fields.at(1), 'secretPW');
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(loggedIn, isTrue);
  });

  testWidgets('LoginScreen switches to SignUpScreen and submits to ReviewsScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    // Switch to Sign Up screen via SegmentedButton.
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('Create a CineDeb Account'), findsOneWidget);

    // Switch back to Login screen via Log In segment.
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Login to CineDeb'), findsOneWidget);

    // Valid login submission navigates to ReviewsScreen.
    final Finder fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '@cinephile');
    await tester.enterText(fields.at(1), 'secretPW');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Reviews'), findsOneWidget);
  });

  testWidgets('LoginScreen opens ForgotPasswordScreen and returns', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle();
    expect(find.text('Reset Your Password'), findsOneWidget);

    await tester.tap(find.text('Back to Log In'));
    await tester.pumpAndSettle();
    expect(find.text('Login to CineDeb'), findsOneWidget);
  });
}
