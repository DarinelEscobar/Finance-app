import 'package:flutter/material.dart';

class FinanceColors {
  const FinanceColors._();

  static const background = Color(0xFFF7F9FB);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1A146B);
  static const secondary = Color(0xFF006C4A);
  static const income = Color(0xFF059669);
  static const expense = Color(0xFFDC2626);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const text = Color(0xFF191C1E);
}

ThemeData buildFinanceTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: FinanceColors.primary,
    primary: FinanceColors.primary,
    secondary: FinanceColors.secondary,
    surface: FinanceColors.surface,
    error: FinanceColors.expense,
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: FinanceColors.background,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: FinanceColors.text,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: FinanceColors.primary, width: 2),
      ),
    ),
  );
}
