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
      // Let it be the login screen. 
      // Just type anything in the username and password to get to the reviews screen.
      home: const LoginScreen(),
    );
  }
}
