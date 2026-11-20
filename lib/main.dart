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
      // Starts on the Login screen.
      // Type anything in the username and password fields to get to the Home screen.
      home: const LoginScreen(),
    );
  }
}
