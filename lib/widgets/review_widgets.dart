import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

String formatDate(DateTime d) {
  final String day = d.day.toString().padLeft(2, '0');
  final String month = d.month.toString().padLeft(2, '0');
  return '$day/$month/${d.year}';
}

class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.redSoft,
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Text('★ $rating/10', style: AppText.label),
    );
  }
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.outlined = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    Color background = AppColors.surfaceLight;
    if (selected) background = AppColors.red;
    if (outlined) background = Colors.transparent;

    final Color foreground = outlined ? AppColors.red : AppColors.white;

    return Material(
      color: background,
      shape: StadiumBorder(
        side: outlined ? const BorderSide(color: AppColors.red) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppText.label.copyWith(color: foreground),
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

class AuthorRow extends StatelessWidget {
  const AuthorRow({
    super.key,
    required this.username,
    required this.date,
    this.trailing,
  });

  final String username;
  final DateTime date;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.surfaceLight,
          child: Text(username[0].toUpperCase(), style: AppText.label),
        ),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username, style: AppText.label),
              Text(formatDate(date), style: AppText.caption),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
