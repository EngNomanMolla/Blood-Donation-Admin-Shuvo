import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xFFFDF2F4), // Ultra-soft pink
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE91E63),
        primary: const Color(0xFFE91E63),
        secondary: const Color(0xFFFF4081),
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}
