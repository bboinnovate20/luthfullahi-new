import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme = ThemeData(
    textTheme: TextTheme(
        titleLarge: GoogleFonts.lora(fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.lora(fontWeight: FontWeight.bold),
        titleSmall: GoogleFonts.inter(),
        bodyMedium: GoogleFonts.inter(),
        displaySmall:
            GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        displayMedium:
            GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
        displayLarge:
            GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.inter(),
        bodySmall: GoogleFonts.inter(fontSize: 14)),
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        primary: const Color(0xFFFFF500),
        onPrimary: Colors.black,
        secondary: const Color(0xFFCD3DFF),
        onSecondary: Colors.white,
        background: const Color(0xFFF9F8DF),
        tertiary: const Color(0xFFF7E3F2)));
