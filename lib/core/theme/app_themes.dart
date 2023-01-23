import 'dart:io';

import 'package:flutter/material.dart';

import '../../app/global_widgets/helpers/dark_mode_helper.dart';
import 'app_colors.dart';
import 'app_styles.dart';

class AppThemes {
  AppThemes._();

  static double appPaddingVal = 16;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: getAppColor(AppColors.background),
    primaryColor: AppColors.primary,
    platform: Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: getAppColor(AppColors.background)),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.primary.withOpacity(0.5),
      trackHeight: 4.0,
      thumbColor: AppColors.primary,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
      overlayColor: AppColors.primary.withOpacity(0.2),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
      valueIndicatorColor: AppColors.primary,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: getAppColor(AppColors.background),
      foregroundColor: Colors.black,
      titleTextStyle: AppTextStyle.headline4.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.primary),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: AppTextStyle.subtitle1.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelColor: AppColors.primary,
      labelPadding: EdgeInsets.symmetric(horizontal: AppThemes.appPaddingVal),
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
    colorScheme: ColorScheme(
      primary: AppColors.primary,
      primaryVariant: AppColors.bostonUniRed,
      secondary: AppColors.bostonUniRed,
      secondaryVariant: Color(0xFFD9222A),
      surface: getAppColor(AppColors.background),
      background: getAppColor(AppColors.background),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: AppColors.bostonUniRed,
      onSurface: Colors.white,
      onBackground: AppColors.bostonUniRed,
      onError: AppColors.bostonUniRed,
      brightness: getAppBrightness(),
    ),
  );
}
