import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF2563EB); // blue-600
  static const Color accentIndigo = Color(0xFF4F46E5); // indigo-600

  // Neutral Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);

  static ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: primaryBlue,
      primaryContainer: Color(0xFFDBEafe),
      secondary: accentIndigo,
      secondaryContainer: Color(0xFFE0E7FF),
      tertiary: Color(0xFF0F172A),
      tertiaryContainer: Color(0xFF334155),
      appBarColor: Color(0xFFE0E7FF),
      error: Color(0xFFB00020),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      inputDecoratorRadius: 12.0,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedBorderWidth: 2.0,
      cardRadius: 16.0,
      elevatedButtonRadius: 12.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: primaryBlue,
      primaryContainer: Color(0xFF1E40AF),
      secondary: accentIndigo,
      secondaryContainer: Color(0xFF3730A3),
      tertiary: Color(0xFF94A3B8),
      tertiaryContainer: Color(0xFF475569),
      appBarColor: Color(0xFF3730A3),
      error: Color(0xFFCF6679),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      inputDecoratorRadius: 12.0,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedBorderWidth: 2.0,
      cardRadius: 16.0,
      elevatedButtonRadius: 12.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  // Gradient helper for headers and buttons
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [primaryBlue, accentIndigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
