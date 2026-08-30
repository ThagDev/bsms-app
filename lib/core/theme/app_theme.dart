import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryNavy = Color(0xFF0F3057);
  static const Color primaryBlue = Color(0xFF00587A);
  static const Color accentCyan = Color(0xFF008891);
  static const Color backgroundLight = Color(0xFFF4F6F9);
  static const Color surfaceWhite = Colors.white;

  // Status Colors
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFF6B7280);
  static const Color statusUrgent = Color(0xFFEF4444);
  static const Color statusSlaWarning = Color(0xFFEA580C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryNavy,
        primary: primaryNavy,
        secondary: accentCyan,
        surface: surfaceWhite,
        background: backgroundLight,
        error: statusUrgent,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceWhite,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryNavy,
          side: const BorderSide(color: primaryNavy),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryNavy, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        prefixIconColor: primaryBlue,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: accentCyan.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryNavy);
          }
          return TextStyle(fontSize: 12, color: Colors.grey.shade600);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentCyan,
        brightness: Brightness.dark,
        primary: const Color(0xFF4DA8DA),
        secondary: accentCyan,
        surface: const Color(0xFF1E293B),
        background: const Color(0xFF0F172A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E293B),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
