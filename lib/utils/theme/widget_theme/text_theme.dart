import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme ligthTextTheme = TextTheme(
    headlineSmall: GoogleFonts.montserrat(color: Colors.grey[600]),
    titleSmall: GoogleFonts.montserrat(color: Colors.grey[600]),
    headlineLarge: GoogleFonts.montserrat(color: Colors.grey[600]),
  );
  static TextTheme darkTextTheme = TextTheme(headlineSmall: GoogleFonts.montserrat(color: Colors.white70), titleSmall: GoogleFonts.montserrat(color: Colors.white70));
}
