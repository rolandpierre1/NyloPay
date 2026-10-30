import 'package:flutter/material.dart';
import 'package:six_cash/theme/custom_theme_colors.dart';

const Color _primaryColor = Color(0xFF1E4D45);
const Color _secondaryColor = Color(0xFFaaa818);

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: _primaryColor,
  secondaryHeaderColor: _secondaryColor,
  brightness: Brightness.dark,
  shadowColor: Colors.black.withValues(alpha:0.4),
  cardColor: const Color(0xFF29292D),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.black),
  dividerColor: Color(0x2A9E9E9E),
  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.dark(),
  ],
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF689da7),
    onPrimary: const Color(0xFF689da7),
    secondary: _secondaryColor,
    onSecondary: _secondaryColor,
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: const Color(0xFF212121),
    onSurface:  Colors.white70,
    onSecondaryContainer: const Color(0xFFff8672),
    shadow: Colors.black.withValues(alpha:0.4),
  ),
);
