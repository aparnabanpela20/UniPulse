import './screens/selection_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIPULSE',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2C2C2C),
          secondary: Color(0xFF9C27B0),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SelectionScreen(),
    );
  }
}
