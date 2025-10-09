import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF211832), // dark background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF25912), // top bar
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 3,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF5C3E94),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(Color(0xFFF25912)),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),
        cardColor: const Color(0xFF412B6B),
      ),
      home: const HomeScreen(),
    );
  }
}
