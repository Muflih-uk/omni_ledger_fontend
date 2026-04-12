import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF006684);
  static const Color secondaryColor = Color(0xFF516066);
  static const Color tertiaryColor = Color(0xFF885116);
  static const Color neutralColor = Color(0xFF74777A);
  static const Color searchBarColor = Color(0xFFE0E3E5);
  static const Color hintColor = Color(0xFFC4C7C9);
  static const Color containerColor = Color(0xFFEFF1F3);

  // Route
  static const String mainPage = '/';
  static const String additemPage = '/add-item';
  static const String addBillingPage = '/add-bill';
  static const String login = '/login';

  // Gradient
  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFFE0F4FF), Colors.white],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient loginGradient = LinearGradient(
    colors: [Color(0xFFE0F4FF), Colors.white],
    begin: Alignment.topRight,
    end: Alignment.bottomCenter,
  );

  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    vertical: 3,
    horizontal: 20,
  );
}
