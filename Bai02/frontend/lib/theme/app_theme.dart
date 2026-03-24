import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1B3A57);
  static const Color secondary = Color(0xFF2B6CB0);
  static const Color accent = Color(0xFFF97316);
  static const Color backgroundTop = Color(0xFFF6F8FB);
  static const Color backgroundBottom = Color(0xFFE9EEF5);
  static const Color darkBackgroundTop = Color(0xFF0B1623);
  static const Color darkBackgroundBottom = Color(0xFF0F1F32);
  static const Color darkSurface = Color(0xFF13273D);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2B6CB0), Color(0xFF1B3A57)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight
  );

  static LinearGradient backgroundGradient(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const LinearGradient(
        colors: [darkBackgroundTop, darkBackgroundBottom],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
      );
    }
    return const LinearGradient(
      colors: [backgroundTop, backgroundBottom],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight
    );
  }

  static ThemeData lightTheme() {
    final textTheme = GoogleFonts.manropeTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: Colors.white,
        background: backgroundTop,
        brightness: Brightness.light
      ),
      textTheme: textTheme.copyWith(
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: primary
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primary
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: Colors.black54,
        suffixIconColor: Colors.black54,
        labelStyle: const TextStyle(color: Colors.black54),
        hintStyle: const TextStyle(color: Colors.black45),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E7EE))
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: secondary, width: 1.4)
        )
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primary,
        contentTextStyle: const TextStyle(color: Colors.white)
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: secondary,
        unselectedItemColor: Color(0xFF8A97A6)
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0
      )
    );
  }

  static ThemeData darkTheme() {
    final textTheme = GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: secondary,
        secondary: secondary,
        tertiary: accent,
        surface: darkSurface,
        background: darkBackgroundTop,
        brightness: Brightness.dark
      ),
      textTheme: textTheme.copyWith(
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        prefixIconColor: Colors.white60,
        suffixIconColor: Colors.white60,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1E3148))
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: secondary, width: 1.4)
        )
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: secondary,
        contentTextStyle: const TextStyle(color: Colors.white)
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0F1F32),
        selectedItemColor: Color(0xFF6FB1FF),
        unselectedItemColor: Color(0xFF7F8EA3)
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0
      )
    );
  }
}
