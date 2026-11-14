import 'package:flutter/material.dart';

import 'screens/reviews_screen.dart';
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
      // TODO: replace with the Login screen.
      // For now Reviews opens first so we can test it.
      home: const ReviewsScreen(movieTitle: 'Inception'),
    );
  }
}
