import 'package:cinedeb/screens/reviews_screen.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const CineDebApp());
}

class CineDebApp extends StatelessWidget {
  const CineDebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineDeb',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const ReviewsScreen(movieTitle: "Inception"),
    );
  }
}
