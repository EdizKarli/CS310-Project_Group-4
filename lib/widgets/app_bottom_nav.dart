import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

/// Home / Profile bottom navigation bar shared by the main screens.
///
/// "Home" goes back to the Home screen, which is the first route after
/// logging in. "Profile" opens the Profile screen.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, this.selectedIndex = homeIndex});

  static const int homeIndex = 0;
  static const int profileIndex = 1;

  final int selectedIndex;

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == homeIndex) {
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
    } else if (selectedIndex != profileIndex) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) =>
          _onDestinationSelected(context, index),
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
