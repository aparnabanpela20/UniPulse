import 'package:flutter_riverpod/flutter_riverpod.dart';

import './providers/complaint_provider.dart';
import './screens/selection_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar & navigation buttons are visible
  // but NOT included in app layout
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyAppWithProviders()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIPULSE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        // Enhanced gradient-friendly color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 30, 124, 232),

          primary: const Color.fromARGB(
            255,
            108,
            72,
            255,
          ), // Violet (ACCENT only)
          secondary: const Color.fromARGB(255, 136, 245, 126), // Mint
          tertiary: const Color(0xFF9A8CFF), // Soft lavender

          background: const Color(0xFFF9FAFF), // Cleaner bg
          surface: Colors.white,
          surfaceVariant: const Color(0xFFF3F4FA),

          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF1E293B),
        ),

        // Global background with subtle gradient feel
        scaffoldBackgroundColor: const Color(0xFFF9FAFF),

        // Enhanced AppBar with gradient support
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color.fromARGB(255, 190, 60, 255),
          elevation: 0.5,
          centerTitle: true,
        ),

        // Card styling (soft, modern)
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        // Button styling (consistent everywhere)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C73E6),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const SelectionScreen(),
    );
  }
}

class MyAppWithProviders extends StatelessWidget {
  const MyAppWithProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ComplaintProvider())],
      child: const MyApp(),
    );
  }
}
