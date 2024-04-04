import 'package:flutter/material.dart';
import 'package:kevin/ui/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.secondary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      titleSpacing: 20,
      elevation: 0.5,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.primary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedIconTheme: IconThemeData(
        color: AppColors.primary,
      ),
      selectedItemColor: AppColors.primary,
      showUnselectedLabels: true,
      unselectedIconTheme: IconThemeData(
        color: AppColors.secondary,
      ),
      unselectedItemColor: AppColors.secondary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.grey,
    ),
  );
}
