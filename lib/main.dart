import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MathChallengeApp());
}

class MathChallengeApp extends StatelessWidget {
  const MathChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Challenge Arena',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const HomeScreen(),
    );
  }
}