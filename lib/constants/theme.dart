import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Colors.black;
  static const Color secondaryColor = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color cardBackgroundColor = Color(0xFFF5F5F5);
  
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  
  static TextStyle get titleStyle => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static TextStyle get subtitleStyle => GoogleFonts.poppins(
    fontSize: 16,
    color: primaryColor.withOpacity(0.7),
  );
  
  static TextStyle get buttonTextStyle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: secondaryColor,
  );
  
  static TextStyle get linkTextStyle => GoogleFonts.poppins(
    fontSize: 14,
    color: primaryColor,
    decoration: TextDecoration.underline,
  );

  static TextStyle get cardTitleStyle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  static TextStyle get cardSubtitleStyle => GoogleFonts.poppins(
    fontSize: 14,
    color: primaryColor.withOpacity(0.7),
  );

  static TextStyle get cardExpiryStyle => GoogleFonts.poppins(
    fontSize: 12,
    color: primaryColor.withOpacity(0.5),
  );
  
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      borderSide: const BorderSide(color: primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      borderSide: const BorderSide(color: errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      borderSide: const BorderSide(color: errorColor),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppTheme.defaultPadding,
      vertical: AppTheme.defaultPadding,
    ),
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackgroundColor,
    borderRadius: BorderRadius.circular(cardBorderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
} 