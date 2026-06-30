import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    );

    final nunitoTextTheme = GoogleFonts.nunitoSansTextTheme().copyWith(
      headlineLarge: GoogleFonts.nunitoSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        height: 1.15,
      ),
      headlineMedium: GoogleFonts.nunitoSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.text,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      textTheme: nunitoTextTheme,
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.muted,
            size: 23,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.muted,
            fontSize: 10,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
