import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

enum AuthMode { login, signUp }

/// Smooth fade transition when switching between auth screens.
Route<void> authFadeRoute(Widget page) {
  return PageRouteBuilder<void>(
    pageBuilder: (_, _, _) => page,
    transitionDuration: const Duration(milliseconds: 150),
    reverseTransitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (_, Animation<double> animation, _, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

/// Shared layout shell for authentication screens (Login, Sign Up, Forgot Password).
class AuthScreenShell extends StatelessWidget {
  const AuthScreenShell({
    super.key,
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double minHeight = (constraints.maxHeight - AppSpacing.m * 2)
                .clamp(0.0, double.infinity);
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.m,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 440,
                    minHeight: minHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: _BrandBadge(),
                          ),
                          const SizedBox(height: AppSpacing.m),
                          const _AuthHeroBanner(),
                          const SizedBox(height: AppSpacing.l),
                          Text(
                            title,
                            style: AppText.h1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            style: AppText.bodySecondary,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.l),
                          ...children,
                          const Spacer(),
                          const SizedBox(height: AppSpacing.l),
                          const Divider(),
                          const SizedBox(height: AppSpacing.s),
                          const Text(
                            '© CINEDEB 2026',
                            style: AppText.caption,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Mode toggle between Log In and Sign Up screens.
class AuthModeSwitch extends StatelessWidget {
  const AuthModeSwitch({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  final AuthMode selectedMode;
  final ValueChanged<AuthMode> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AuthMode>(
      showSelectedIcon: false,
      segments: const <ButtonSegment<AuthMode>>[
        ButtonSegment<AuthMode>(
          value: AuthMode.login,
          icon: Icon(Icons.login_rounded, size: 18),
          label: Text('Log In'),
        ),
        ButtonSegment<AuthMode>(
          value: AuthMode.signUp,
          icon: Icon(Icons.person_add_alt_1_outlined, size: 18),
          label: Text('Sign Up'),
        ),
      ],
      selected: <AuthMode>{selectedMode},
      onSelectionChanged: (Set<AuthMode> selection) {
        final AuthMode chosen = selection.first;
        if (chosen != selectedMode) {
          onModeSelected(chosen);
        }
      },
    );
  }
}

/// Label row displayed above form fields.
class AuthFieldHeader extends StatelessWidget {
  const AuthFieldHeader({
    super.key,
    required this.label,
    this.trailing,
  });

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: AppText.label),
        ?trailing,
      ],
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.s),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.movie_creation_outlined,
            size: 16,
            color: AppColors.red,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'CINEDEB',
            style: AppText.label.copyWith(letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}

class _AuthHeroBanner extends StatelessWidget {
  const _AuthHeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: const BoxDecoration(
            color: AppColors.redSoft,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'LOGO HERE',
          ),
        ),
      ),
    );
  }
}
