import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GradebookApp());
}

class GradebookApp extends StatelessWidget {
  const GradebookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Gradebook',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          surfaceTintColor: Colors.white,
          elevation: 2,
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
