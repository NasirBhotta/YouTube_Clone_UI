// App theme configuration for YouTube clone
import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Colors
  static const Color _primaryColorLight = Colors.white;
  static const Color _primaryColorDark = Color(0xFF121212);

  static const Color _accentColor = Color(0xFFFF0000); // YouTube Red
  static const Color _accentColorDark = Color(0xFFFF0000); // Same YouTube Red

  static const Color _scaffoldBackgroundColorLight = Colors.white;
  static const Color _scaffoldBackgroundColorDark = Color(0xFF121212);

  static const Color _appBarColorLight = Colors.white;
  static const Color _appBarColorDark = Color(0xFF212121);

  static const Color _cardColorLight = Colors.white;
  static const Color _cardColorDark = Color(0xFF1E1E1E);

  static const Color _bottomNavBarColorLight = Colors.white;
  static const Color _bottomNavBarColorDark = Color(0xFF212121);

  static const Color _dividerColorLight = Color(0xFFE0E0E0);
  static const Color _dividerColorDark = Color(0xFF2D2D2D);

  static const Color _iconColorLight = Color(0xFF606060);
  static const Color _iconColorDark = Color(0xFFAAAAAA);

  static const Color _textColorLight = Color(0xFF0F0F0F);
  static const Color _textColorSecondaryLight = Color(0xFF606060);

  static const Color _textColorDark = Colors.white;
  static const Color _textColorSecondaryDark = Color(0xFFAAAAAA);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryColorLight,
    colorScheme: const ColorScheme.light(
      primary: _primaryColorLight,
      secondary: _accentColor,
      surface: _scaffoldBackgroundColorLight,
    ),
    scaffoldBackgroundColor: _scaffoldBackgroundColorLight,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: _appBarColorLight,
      foregroundColor: _textColorLight,
      iconTheme: IconThemeData(color: _iconColorLight),
      titleTextStyle: TextStyle(
        color: _textColorLight,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardTheme(
      color: _cardColorLight,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _bottomNavBarColorLight,
      selectedItemColor: _textColorLight,
      unselectedItemColor: _iconColorLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dividerColor: _dividerColorLight,
    iconTheme: const IconThemeData(color: _iconColorLight),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: _textColorLight,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: _textColorLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: _textColorLight,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: _textColorLight, fontSize: 16),
      bodyMedium: TextStyle(color: _textColorLight, fontSize: 14),
      titleMedium: TextStyle(
        color: _textColorLight,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(color: _textColorSecondaryLight, fontSize: 14),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      buttonColor: _accentColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _accentColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _dividerColorLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _accentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _dividerColorLight),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _primaryColorDark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryColorDark,
      secondary: _accentColorDark,
      surface: _scaffoldBackgroundColorDark,
    ),
    scaffoldBackgroundColor: _scaffoldBackgroundColorDark,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: _appBarColorDark,
      foregroundColor: _textColorDark,
      iconTheme: IconThemeData(color: _iconColorDark),
      titleTextStyle: TextStyle(
        color: _textColorDark,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardTheme(
      color: _cardColorDark,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _bottomNavBarColorDark,
      selectedItemColor: _textColorDark,
      unselectedItemColor: _iconColorDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dividerColor: _dividerColorDark,
    iconTheme: const IconThemeData(color: _iconColorDark),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: _textColorDark,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: _textColorDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: _textColorDark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: _textColorDark, fontSize: 16),
      bodyMedium: TextStyle(color: _textColorDark, fontSize: 14),
      titleMedium: TextStyle(
        color: _textColorDark,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(color: _textColorSecondaryDark, fontSize: 14),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      buttonColor: _accentColorDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _accentColorDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: _accentColorDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _dividerColorDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _accentColorDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _dividerColorDark),
      ),
    ),
  );
}
