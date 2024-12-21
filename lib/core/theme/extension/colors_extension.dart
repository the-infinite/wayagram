import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';

extension WayaColorSchemeExtension on ColorScheme {
  // Primary Colors
  Color get primary200 => WayaColors.primary200;
  Color get primary300 => WayaColors.primary300;
  Color get primary500 => WayaColors.primary500;
  Color get primar50 => WayaColors.primar50;
  Color get customPrimary => WayaColors.customPrimary;
  Color get primary75 => WayaColors.primary75;
  Color get primaryBrown50 => WayaColors.primaryBrown50;
  Color get primary => WayaColors.primary;
  Color get primary600 => WayaColors.primary600;
  Color get onPrimary => WayaColors.onPrimary;

  // Error Colors
  Color get error200 => WayaColors.error200;
  Color get error => WayaColors.error;
  Color get error500 => WayaColors.error500;
  Color get error700 => WayaColors.error700;

  // Success Colors
  Color get success50 => WayaColors.success50;
  Color get success => WayaColors.success;
  Color get success700 => WayaColors.success700;

  // Secondary Colors
  Color get secondaryColor => WayaColors.secondaryColor;
  Color get secondaryColor2 => WayaColors.secondaryColor2;

  // Tertiary and Transparent
  Color get tertiary => WayaColors.tertiary;
  Color get transparent => WayaColors.transparent;

  // Grey Colors
  Color get greyColor500 => WayaColors.greyColor500;
  Color get greyColor700 => WayaColors.greyColor700;
  Color get greyColor400 => WayaColors.greyColor400;
  Color get greyColor200 => WayaColors.greyColor200;
  Color get greyColor100 => WayaColors.greyColor100;
  Color get greyColor300 => WayaColors.greyColor300;
  Color get greyColor600 => WayaColors.greyColor600;
  Color get greyColor900 => WayaColors.greyColor900;
  Color get darkGrey => WayaColors.darkGrey;

  // Black Colors
  Color get black => WayaColors.black;
  Color get customBlack => WayaColors.customBlack;

  // White Colors
  Color get white => WayaColors.white;

  // Scaffold Colors
  Color get scaffoldColor => WayaColors.scaffoldColor;
  Color get scaffoldColor2 => WayaColors.scaffoldColor2;

  // Card Background Colors
  Color get cardBackgroudColor => WayaColors.cardBackgroudColor;
  Color get cardBorderColor200 => WayaColors.cardBorderColor200;
  Color get cardBorderColor300 => WayaColors.cardBorderColor300;
}
