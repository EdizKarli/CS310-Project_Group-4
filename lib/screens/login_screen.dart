import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../widgets/auth_components.dart';
import 'reviews_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onSignUpTap,
    this.onForgotPasswordTap,
    this.onLoginSuccess,
  });

  final VoidCallback? onSignUpTap;
  final VoidCallback? onForgotPasswordTap;
  final VoidCallback? onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _handleSignUpTap() {
    if (widget.onSignUpTap != null) {
      widget.onSignUpTap!();
      return;
    }
    Navigator.of(context).pushReplacement(authFadeRoute(const SignUpScreen()));
  }

  void _handleForgotPasswordTap() {
    if (widget.onForgotPasswordTap != null) {
      widget.onForgotPasswordTap!();
      return;
    }
    // TODO: navigate to ForgotPasswordScreen once created.
    _showMessage('Forgot Password screen will open here');
  }

  void _openAvailableHome() {
    // TODO: navigate to Home/Discover screen once it is built.
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ReviewsScreen(movieTitle: 'Inception'),
      ),
    );
  }

  void _submitLogin() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
      return;
    }
    _openAvailableHome();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenShell(
      formKey: _formKey,
      title: 'Login to CineDeb',
      subtitle: 'Structured cinema criticism & verified film chambers',
      children: <Widget>[
        AuthModeSwitch(
          selectedMode: AuthMode.login,
          onModeSelected: (AuthMode mode) {
            if (mode == AuthMode.signUp) {
              _handleSignUpTap();
            }
          },
        ),
        const SizedBox(height: AppSpacing.l),

        // Email or User Handle field
        const AuthFieldHeader(label: 'Email or User Handle*'),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: _identifierController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          style: AppText.body,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.alternate_email),
            hintText: 'Enter email or @handle',
          ),
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email or @handle';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.m),

        // Password field + Forgot Password link
        AuthFieldHeader(
          label: 'Password*',
          trailing: TextButton(
            onPressed: _handleForgotPasswordTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot Password?',
              style: AppText.caption.copyWith(
                color: AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submitLogin(),
          style: AppText.body,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            hintText: 'Enter your password',
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
              return 'Please enter your password';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.l),

        // Primary Login CTA
        ElevatedButton(
          onPressed: _submitLogin,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Login'),
              SizedBox(width: AppSpacing.s),
              Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.l),

        // Create an account prompt
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xs,
          children: <Widget>[
            const Text(
              'New to CineDeb?',
              style: AppText.bodySecondary,
            ),
            TextButton(
              onPressed: _handleSignUpTap,
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
                  Text('Create an account'),
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
