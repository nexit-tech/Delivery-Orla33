import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta de Cores
  static const Color background = Color(0xFF121212); 
  static const Color surface = Color(0xFF1E1E1E);    
  static const Color primary = Color(0xFFD44C2E);    
  static const Color secondary = Color(0xFFB0B0B0);  
  static const Color textWhite = Colors.white;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
      ),

      // AQUI: Montserrat em tudo
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 28, fontWeight: FontWeight.bold, color: textWhite
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 22, fontWeight: FontWeight.w600, color: textWhite
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16, color: textWhite
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 14, color: secondary
        ),
        labelLarge: GoogleFonts.montserrat( 
          fontSize: 16, fontWeight: FontWeight.bold, color: textWhite
        ),
      ),
    );
  }
}