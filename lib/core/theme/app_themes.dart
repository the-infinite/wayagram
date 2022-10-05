import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppThemes {
  AppThemes._();

  static const double appPaddingVal = 16;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: AppColors.bostonUniRed,
    platform: TargetPlatform.iOS,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      titleTextStyle: AppTextStyle.headline4.copyWith(
        fontWeight: FontWeight.w500,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.bostonUniRed),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: AppTextStyle.subtitle1.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelColor: AppColors.bostonUniRed,
      labelPadding:
          const EdgeInsets.symmetric(horizontal: AppThemes.appPaddingVal),
      unselectedLabelColor: AppColors.onyx,
      unselectedLabelStyle: AppTextStyle.subtitle1.copyWith(
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: TextTheme(
      bodyText1: AppTextStyle.bodyText1,
      bodyText2: AppTextStyle.bodyText2,
      subtitle2: AppTextStyle.subtitle2,
      caption: AppTextStyle.caption,
      subtitle1: AppTextStyle.subtitle1,
      headline5: AppTextStyle.headline5,
      headline6: AppTextStyle.headline6,
      button: AppTextStyle.button,
      headline4: AppTextStyle.headline4,
    ),
    colorScheme: const ColorScheme(
      primary: AppColors.bostonUniRed,
      primaryVariant: AppColors.bostonUniRed,
      secondary: AppColors.bostonUniRed,
      secondaryVariant: Color(0xFFD9222A),
      surface: Color(0xFFC4C4C4),
      background: Color(0xFFE3E5E5),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: AppColors.bostonUniRed,
      onSurface: Colors.black,
      onBackground: AppColors.bostonUniRed,
      onError: AppColors.bostonUniRed,
      brightness: Brightness.light,
    ),
  );
}
