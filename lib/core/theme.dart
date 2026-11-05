import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color canvas = Color(0xFFF7F4EF);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF232120);
  static const Color rust = Color(0xFFBC4521);
  static const Color ash = Color(0xFF8E8983);

  static const double gap6 = 6;
  static const double gap10 = 10;
  static const double gap14 = 14;
  static const double gap18 = 18;
  static const double gap22 = 22;
  static const double gap28 = 28;

  static const double rbS = 10;
  static const double rbM = 14;
  static const double rbL = 22;

  static ThemeData get base => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: const ColorScheme.light(
          primary: ink,
          secondary: rust,
          surface: paper,
          onSurface: ink,
        ),
        textTheme: GoogleFonts.manropeTextTheme().apply(
          bodyColor: ink,
          displayColor: ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: ink),
        ),
      );
}