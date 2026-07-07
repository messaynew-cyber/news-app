import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() => runApp(const NewsappApp());

class NewsappApp extends StatelessWidget {
  const NewsappApp({super.key});

  static const _amber = Color(0xFFE8A850);
  static const _darkBg = Color(0xFF0A0A0F);
  static const _darkSurface = Color(0xFF121218);
  static const _textPrimary = Color(0xFFF0F0F5);
  static const _textSecondary = Color(0xFF8E8E99);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _amber,
      brightness: Brightness.dark,
      primary: _amber,
      surface: _darkSurface,
      onSurface: _textPrimary,
      outline: _textSecondary,
    );

    return MaterialApp(
      title: 'NewsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: _darkBg,
        brightness: Brightness.dark,

        // Typography
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            color: _textPrimary,
            letterSpacing: -0.5,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            color: _textSecondary,
          ),
        ),

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),

        // Cards
        cardTheme: CardThemeData(
          color: _darkSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: _textSecondary.withOpacity(0.08)),
          ),
        ),

        // Progress indicator
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: _amber,
          linearTrackColor: Color(0xFF1E1E28),
        ),

        // Divider
        dividerTheme: DividerThemeData(
          color: _textSecondary.withOpacity(0.08),
          thickness: 1,
          space: 1,
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _darkSurface,
          contentTextStyle: const TextStyle(color: _textPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
