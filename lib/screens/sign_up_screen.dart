import 'package:flutter/material.dart';

import '../utils/app_styles.dart';
import '../widgets/auth_components.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    this.onLoginTap,
    this.onSignUpSuccess,
  });

  final VoidCallback? onLoginTap;
  final VoidCallback? onSignUpSuccess;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _handleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _handleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLoginTap() {
    if (widget.onLoginTap != null) {
      widget.onLoginTap!();
      return;
    }
    Navigator.of(context).pushReplacement(authFadeRoute(const LoginScreen()));
  }

  void _openHome() {
    // Home becomes the first route, so Back does not return to Sign Up.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _submitSignUp() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (widget.onSignUpSuccess != null) {
      widget.onSignUpSuccess!();
      return;
    }
    _openHome();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenShell(
      formKey: _formKey,
      title: 'Create a CineDeb Account',
      subtitle: 'Join the best film debate community',
      children: <Widget>[
        AuthModeSwitch(
          selectedMode: AuthMode.signUp,
          onModeSelected: (AuthMode mode) {
            if (mode == AuthMode.login) {
              _handleLoginTap();
            }
          },
        ),
        const SizedBox(height: AppSpacing.l),

        // User Handle field
        const AuthFieldHeader(label: 'User Handle*'),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: _handleController,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          style: AppText.body,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.alternate_email),
            hintText: 'Enter @handle',
          ),
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a user handle';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.m),

        // Email Address field
        const AuthFieldHeader(label: 'Email Address*'),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          style: AppText.body,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'Enter email',
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
        const SizedBox(height: AppSpacing.m),

        // Password field
        const AuthFieldHeader(label: 'Password*'),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submitSignUp(),
          style: AppText.body,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Create a password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              tooltip: _obscurePassword ? 'Show password' : 'Hide password',
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.l),

        // Primary Sign Up CTA
        ElevatedButton(
          onPressed: _submitSignUp,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Create Account'),
              SizedBox(width: AppSpacing.s),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Already have an account prompt
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xs,
          children: <Widget>[
            const Text(
              'Already have an account?',
              style: AppText.bodySecondary,
            ),
            TextButton(
              onPressed: _handleLoginTap,
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
                  Text('Log In'),
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
