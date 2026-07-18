import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  // Define our core colors
  static const Color primaryColor = Color(0xFF10B981); // Emerald Green
  static const Color secondaryColor = Color(0xFF3B82F6); // Blue
  static const Color backgroundColor = Color(0xFFF9FAFB); // Off-white
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF111827); // Dark gray

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        background: backgroundColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // 1. TYPOGRAPHY: Applying Google Fonts to the entire app
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: textPrimaryColor,
        displayColor: textPrimaryColor,
      ),

      // 2. APPBAR STYLE
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimaryColor),
        titleTextStyle: GoogleFonts.outfit(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 3. INPUT FIELD STYLE
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
      ),

      // 4. BUTTON STYLE
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // 5. CARD STYLE
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade100),
        ),
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}
