import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static get lightTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF993f62),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF993f62),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static get darkTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF993f62),
        ),
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          accentColor: const Color(0xFF993f62),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}
