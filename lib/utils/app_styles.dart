import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppText {
  AppText._();

  /// Custom font for the whole app, registered in pubspec.yaml.
  static const String fontFamily = 'Barlow';

  static const TextStyle h1 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.white);
  static const TextStyle h2 = TextStyle(
      fontFamily: fontFamily,
      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.white);
  static const TextStyle title = TextStyle(
      fontFamily: fontFamily,
      fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white);
  static const TextStyle body = TextStyle(
      fontFamily: fontFamily,
      fontSize: 15, height: 1.45, color: AppColors.white);
  static const TextStyle bodySecondary = TextStyle(
      fontFamily: fontFamily,
      fontSize: 14, height: 1.4, color: AppColors.textSecondary);
  static const TextStyle label = TextStyle(
      fontFamily: fontFamily,
      fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white);
  static const TextStyle caption = TextStyle(
      fontFamily: fontFamily,
      fontSize: 12, color: AppColors.textSecondary);
  static const TextStyle overline = TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: AppColors.textSecondary);
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;

  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: m);
}

class AppRadius {
  AppRadius._();

  static const double s = 8;
  static const double m = 12;
  static const double l = 20;
}
