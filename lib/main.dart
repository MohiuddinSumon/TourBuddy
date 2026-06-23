import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const TourBuddyApp());
}

class TourBuddyApp extends StatelessWidget {
  const TourBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
      ),
      home: const HomeScreen(),
    );
  }
}
