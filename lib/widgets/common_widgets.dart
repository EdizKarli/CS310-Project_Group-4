import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

/// Upper-case section title with an optional action on the right,
/// e.g. "TRENDING NOW ........ See all →".
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: AppText.label.copyWith(letterSpacing: 1.2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ?action,
      ],
    );
  }
}

/// Text button with a trailing arrow, used for "See all" links.
class SeeAllButton extends StatelessWidget {
  const SeeAllButton({super.key, required this.onPressed, this.label = 'See all'});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.arrow_forward_rounded, size: 16),
        ],
      ),
    );
  }
}

/// Tappable shortcut tile with an icon and a label (Home quick access grid).
class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.m),
    );

    return Material(
      color: AppColors.surface,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m - AppSpacing.xs,
            vertical: AppSpacing.m - 2,
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 20, color: AppColors.red),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  label,
                  style: AppText.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip with a dropdown arrow that opens a picker, e.g. "Year: Any ⌄".
/// Highlighted in red while [active] (a filter other than "Any" is set).
class FilterDropdownChip extends StatelessWidget {
  const FilterDropdownChip({
    super.key,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: active,
      onSelected: (_) => onTap(),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet that lets the user pick one option from a list.
/// Returns the picked option, or null if the sheet was dismissed.
Future<T?> showSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T selected,
  required String Function(T option) labelOf,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppColors.surface,
    builder: (BuildContext sheetContext) {
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Text(title, style: AppText.title),
            ),
            for (final T option in options)
              ListTile(
                title: Text(labelOf(option), style: AppText.body),
                trailing: option == selected
                    ? const Icon(Icons.check, color: AppColors.red)
                    : null,
                onTap: () => Navigator.pop(sheetContext, option),
              ),
          ],
        ),
      );
    },
  );
}
