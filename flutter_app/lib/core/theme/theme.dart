import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final examKitTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    primary: const Color(0xFF2563EB),
    onPrimary: Colors.white,
    surface: Colors.white,
    error: const Color(0xFFDC2626),
  ),
  scaffoldBackgroundColor: const Color(0xFFF1F5F9),
  textTheme: GoogleFonts.interTextTheme().copyWith(
    bodyLarge: const TextStyle(fontSize: 18, color: Color(0xFF0F172A)),
    bodyMedium: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    headlineLarge: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
    displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1,
    color: Colors.white,
  ),
);
