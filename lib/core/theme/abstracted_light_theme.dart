import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

final abstractedLightTheme = ThemeData(
  primaryColor: WayaColors.primary,
  textTheme: TextTheme(
    labelSmall: WayaTextStyles.labelSmall,
    labelMedium: WayaTextStyles.labelMedium,
    titleLarge: WayaTextStyles.titleLarge,
    titleMedium: WayaTextStyles.titleMedium,
    headlineLarge: WayaTextStyles.headlineLarge,
    headlineMedium: WayaTextStyles.headlineMedium,
    bodyMedium: WayaTextStyles.bodyMedium,
    
  ),
  scaffoldBackgroundColor: WayaColors.scaffoldColor2,
    appBarTheme: _appBarThemeData(),
    switchTheme: _switchThemeData(),
    chipTheme: _chipThemeData(),
    elevatedButtonTheme: _elevatedButtonThemeData(),
    checkboxTheme: _checkBoxThemeData());

AppBarTheme _appBarThemeData() {
  return const AppBarTheme(
      titleTextStyle: WayaTextStyles.titleLarge, elevation: 0, centerTitle: true, backgroundColor: WayaColors.white);
}

CheckboxThemeData _checkBoxThemeData() {
  return CheckboxThemeData(
      side: const BorderSide(color: WayaColors.primary, width: 2.2),
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return WayaColors.primary;
        }
        return WayaColors.white;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      checkColor: const WidgetStatePropertyAll(WayaColors.onPrimary));
}

ElevatedButtonThemeData _elevatedButtonThemeData() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: WayaColors.secondaryColor,
      disabledForegroundColor: WayaColors.onPrimary,
      minimumSize: const Size(double.infinity, 55.0),
      backgroundColor: WayaColors.customPrimary, // Button color
      foregroundColor: Colors.white, // Text color
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5), // Padding for height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
    ),
  );
}

ChipThemeData _chipThemeData() {
  return ChipThemeData(
    backgroundColor: WayaColors.primar50,
    labelStyle: const TextStyle(
      color: WayaColors.primary,
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: const BorderSide(color: WayaColors.transparent, width: 1.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0), // Spacing inside the chip
  );
}

SwitchThemeData _switchThemeData() {
  return SwitchThemeData(
    thumbIcon: WidgetStateProperty.resolveWith<Icon>(
      (Set<WidgetState> states) {
        if (states.containsAll([WidgetState.disabled, WidgetState.selected])) {
          return const Icon(Icons.circle, color: WayaColors.primary);
        }

        if (states.contains(WidgetState.disabled)) {
          return const Icon(Icons.circle, color: WayaColors.secondaryColor);
        }

        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.circle, color: WayaColors.white);
        } else {
          return const Icon(Icons.circle, color: WayaColors.white);
        }
      },
    ),
    trackOutlineColor: const WidgetStatePropertyAll(WayaColors.transparent),
    thumbColor: const WidgetStatePropertyAll(WayaColors.white),
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return WayaColors.primary;
      }
      return WayaColors.greyColor200;
    }),
    overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return WayaColors.primary;
      }
      return WayaColors.transparent;
    }),
  );
}
