import 'package:flutter/material.dart';

import '../utils/app_styles.dart';
import '../widgets/auth_components.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    this.onBackToLoginTap,
    this.onResetRequested,
  });

  final VoidCallback? onBackToLoginTap;
  final VoidCallback? onResetRequested;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleBackToLogin() {
    if (widget.onBackToLoginTap != null) {
      widget.onBackToLoginTap!();
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacement(authFadeRoute(const LoginScreen()));
    }
  }

  void _submitReset() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (widget.onResetRequested != null) {
      widget.onResetRequested!();
      return;
    }

    final String email = _emailController.text.trim();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'If $email is registered, a reset link has been sent.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenShell(
      formKey: _formKey,
      title: 'Reset Your Password',
      subtitle: "We'll email you a link to reset your password",
      children: <Widget>[
        // Email Address field
        const AuthFieldHeader(label: 'Email Address*'),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          onFieldSubmitted: (_) => _submitReset(),
          style: AppText.body,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'Enter your email',
          ),
          validator: (String? value) {
            final String trimmed = value?.trim() ?? '';
            if (trimmed.isEmpty) {
              return 'Please enter your email address';
            }
            if (!trimmed.contains('@') || !trimmed.contains('.')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.s),
        const Text(
          "We'll send a link if the email is registered.",
          style: AppText.caption,
        ),
        const SizedBox(height: AppSpacing.l),

        // Primary Send Reset Link CTA
        ElevatedButton(
          onPressed: _submitReset,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Send Reset Link'),
              SizedBox(width: AppSpacing.s),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Back to Log In prompt
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xs,
          children: <Widget>[
            const Text(
              'Remembered your password?',
              style: AppText.bodySecondary,
            ),
            TextButton(
              onPressed: _handleBackToLogin,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Back to Log In'),
                  SizedBox(width: AppSpacing.xs),
                  Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
