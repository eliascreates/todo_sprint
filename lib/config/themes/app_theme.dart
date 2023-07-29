import 'package:flutter/material.dart';
import 'package:todo_sprint/core/constants/colors.dart';

class AppTheme {
  const AppTheme._();

  static get lightTheme => ThemeData(
        primaryColor: AppColors.lPrimaryDarkerShade,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lPrimaryColor),
        snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.lPrimaryLighterShade),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static get darkTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          color: AppColors.dPrimaryDarkerShade,
        ),
        primaryColor: AppColors.dPrimaryDarkerShade,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark, seedColor: AppColors.dPrimaryColor),
        snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.dPrimaryLighterShade),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}
