import 'package:flutter/material.dart';
import 'package:six_cash/theme/custom_theme_colors.dart';


const Color _primaryColor = Color(0xFF1E4D45);
const Color _secondaryColor = Color(0xFFE0EC53);


ThemeData light = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Rubik',
  primaryColor: _primaryColor,
  secondaryHeaderColor: _secondaryColor,
  cardColor: const Color(0xFFFAFAFA),
  shadowColor: Colors.grey[300],
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.white.withValues(alpha: 0.98),
  ),
  dividerColor: const Color(0x1A9E9E9E),
  extensions: <ThemeExtension<CustomThemeColors>>[
    CustomThemeColors.light(),
  ],
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: _primaryColor,
    onPrimary: _primaryColor,
    secondary: _secondaryColor,
    onSecondary: _secondaryColor,
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    onSecondaryContainer: const Color(0xFFff8672),
    shadow: Colors.grey[300],
  ),

);