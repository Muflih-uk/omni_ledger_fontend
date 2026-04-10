import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    primaryColor: AppConstants.primaryColor,
    scaffoldBackgroundColor: Colors.white,

    colorScheme: ColorScheme.light(
      primary: AppConstants.primaryColor,
      secondary: AppConstants.secondaryColor,
      tertiary: AppConstants.tertiaryColor,
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.manrope(fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.manrope(fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.manrope(fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.manrope(fontWeight: FontWeight.w600),

      bodyLarge: GoogleFonts.inter(),
      bodyMedium: GoogleFonts.inter(),
      bodySmall: GoogleFonts.inter(),

      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.inter(),
      labelSmall: GoogleFonts.inter(),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: AppConstants.primaryColor,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      hintStyle: GoogleFonts.inter(),
      labelStyle: GoogleFonts.inter(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
