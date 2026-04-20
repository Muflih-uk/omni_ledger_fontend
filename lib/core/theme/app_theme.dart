import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    primaryColor: AppConstants.primaryColor,

    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.light(
      primary: AppConstants.primaryColor,
      secondary: AppConstants.secondaryColor,
      tertiary: AppConstants.tertiaryColor,
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontWeight: FontWeight.w600,
        color: AppConstants.primaryColor,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      bodyLarge: GoogleFonts.inter(
        color: AppConstants.tertiaryColor,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.inter(color: Colors.white),
      bodySmall: GoogleFonts.inter(color: AppConstants.secondaryColor),

      labelLarge: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        color: AppConstants.secondaryColor,
      ),
      labelMedium: GoogleFonts.inter(
        color: AppConstants.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.inter(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppConstants.primaryColor,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
