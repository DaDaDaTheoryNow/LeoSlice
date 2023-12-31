import 'package:flutter/material.dart';
import 'package:leo_slice/common/theme/app_colors.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.blue,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.blue,
      foregroundColor: Colors.white,
    )),
    textTheme: const TextTheme(
        labelLarge: TextStyle(
      color: Colors.white,
    )),
  );
}
