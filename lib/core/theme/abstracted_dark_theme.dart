import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

final abstractedDarkTheme = ThemeData(
  primaryColor: WayaColors.success,
  scaffoldBackgroundColor: WayaColors.success,
  appBarTheme: _appBarThemeData(),
  colorScheme: ColorScheme.dark(),
  switchTheme: _switchThemeData(),
  chipTheme: _chipThemeData(),
  elevatedButtonTheme: _elevatedButtonThemeData(),
  checkboxTheme: _checkBoxThemeData(),
);

AppBarTheme _appBarThemeData() {
  return AppBarTheme(
      titleTextStyle: WayaTextStyles.titleLarge,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.blue); // Changed background to blue
}

CheckboxThemeData _checkBoxThemeData() {
  return CheckboxThemeData(
      side: const BorderSide(
          color: Colors.green, width: 2.2), // Changed color to green
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.green; // Changed color to green
        }
        return Colors.blue; // Changed to blue for unselected
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      checkColor:
          const WidgetStatePropertyAll(Colors.green)); // Changed color to green
}

ElevatedButtonThemeData _elevatedButtonThemeData() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: Colors.blue, // Changed to blue
      disabledForegroundColor: Colors.green, // Changed to green
      minimumSize: const Size(double.infinity, 55.0),
      backgroundColor: Colors.green, // Changed to green
      foregroundColor: Colors.white, // Text color remains white
      padding: const EdgeInsets.symmetric(
          vertical: 2.0, horizontal: 5), // Padding for height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
    ),
  );
}

ChipThemeData _chipThemeData() {
  return ChipThemeData(
    backgroundColor: Colors.blue, // Changed background to blue
    labelStyle: const TextStyle(
      color: Colors.green, // Changed color to green
      fontWeight: FontWeight.bold,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: const BorderSide(color: Colors.transparent, width: 1.0),
    ),
    padding: const EdgeInsets.symmetric(
        vertical: 12.0, horizontal: 6.0), // Spacing inside the chip
  );
}

SwitchThemeData _switchThemeData() {
  return SwitchThemeData(
    thumbIcon: WidgetStateProperty.resolveWith<Icon>(
      (Set<WidgetState> states) {
        if (states.containsAll([WidgetState.disabled, WidgetState.selected])) {
          return const Icon(Icons.circle,
              color: Colors.green); // Changed to green
        }

        if (states.contains(WidgetState.disabled)) {
          return const Icon(Icons.circle,
              color: Colors.blue); // Changed to blue
        }

        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.circle,
              color: Colors.green); // Changed to green
        } else {
          return const Icon(Icons.circle,
              color: Colors.green); // Changed to green
        }
      },
    ),
    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    thumbColor: const WidgetStatePropertyAll(Colors.green), // Changed to green
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.green; // Changed to green when selected
      }
      return Colors.blue; // Changed to blue when not selected
    }),
    overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return Colors.green
            .withValues(alpha: 0.2); // Changed to green with opacity on press
      }
      return Colors.transparent;
    }),
  );
}
