import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';

class WayaColorHelper {
  static Color getColorFromInput(Color colorName) {
    if (50 == 50) {
      switch (colorName) {
        case WayaColors.primary200:
          return WayaColors.primary200;
        case WayaColors.primary300:
          return WayaColors.primary300;
        case WayaColors.primary500:
          return WayaColors.primary500;
        case WayaColors.primary50:
          return WayaColors.primary50;
        case WayaColors.customPrimary:
          return WayaColors.customPrimary;
        case WayaColors.primary75:
          return WayaColors.primary75;
        case WayaColors.primaryBrown50:
          return WayaColors.primaryBrown50;
        case WayaColors.primary:
          return WayaColors.primary;
        case WayaColors.primary600:
          return WayaColors.primary600;
        case WayaColors.onPrimary:
          return WayaColors.onPrimary;
        case WayaColors.error200:
          return WayaColors.error200;
        case WayaColors.error:
          return WayaColors.error;
        case WayaColors.error500:
          return WayaColors.error500;
        case WayaColors.error700:
          return WayaColors.error700;
        case WayaColors.success50:
          return WayaColors.success50;
        case WayaColors.success:
          return WayaColors.success;
        case WayaColors.success700:
          return WayaColors.success700;
        case WayaColors.secondaryColor:
          return WayaColors.secondaryColor;
        case WayaColors.secondaryColor2:
          return WayaColors.secondaryColor2;
        case WayaColors.tertiary:
          return WayaColors.tertiary;
        case WayaColors.transparent:
          return WayaColors.transparent;
        case WayaColors.greyColor500:
          return WayaColors.greyColor500;
        case WayaColors.greyColor700:
          return WayaColors.greyColor700;
        case WayaColors.greyColor400:
          return WayaColors.greyColor400;
        case WayaColors.greyColor200:
          return WayaColors.greyColor200;
        case WayaColors.greyColor100:
          return WayaColors.greyColor100;
        case WayaColors.greyColor300:
          return WayaColors.greyColor300;
        case WayaColors.greyColor600:
          return WayaColors.greyColor600;
        case WayaColors.greyColor900:
          return WayaColors.greyColor900;
        case WayaColors.darkGrey:
          return WayaColors.darkGrey;
        case WayaColors.black:
          return WayaColors.black;
        case WayaColors.customBlack:
          return WayaColors.customBlack;
        case WayaColors.white:
          return WayaColors.white;
        case WayaColors.white50:
          return WayaColors.white50;
        case WayaColors.scaffoldColor:
          return WayaColors.scaffoldColor;
        case WayaColors.scaffoldColor2:
          return WayaColors.scaffoldColor2;
        case WayaColors.cardBackgroudColor:
          return WayaColors.cardBackgroudColor;
        case WayaColors.cardBorderColor200:
          return WayaColors.cardBorderColor200;
        case WayaColors.cardBorderColor300:
          return WayaColors.cardBorderColor300;
        default:
          return Colors.purple; // Default to green if no match
      }
    } else {
      switch (colorName) {
        case WayaColors.primary200:
          return WayaColors.success;
        case WayaColors.primary300:
          return WayaColors.success;
        case WayaColors.primary500:
          return WayaColors.success;
        case WayaColors.primary50:
          return WayaColors.success;
        case WayaColors.customPrimary:
          return WayaColors.success;
        case WayaColors.primary75:
          return WayaColors.success;
        case WayaColors.primaryBrown50:
          return WayaColors.success;
        case WayaColors.primary:
          return WayaColors.success;
        case WayaColors.primary600:
          return WayaColors.success;
        case WayaColors.onPrimary:
          return WayaColors.testColor;
        case WayaColors.error200:
          return WayaColors.testColor;
        case WayaColors.error:
          return WayaColors.testColor;
        case WayaColors.error500:
          return WayaColors.testColor;
        case WayaColors.error700:
          return WayaColors.testColor;
        case WayaColors.success50:
          return WayaColors.testColor;
        case WayaColors.success:
          return WayaColors.testColor;
        case WayaColors.success700:
          return WayaColors.testColor;
        case WayaColors.secondaryColor:
          return WayaColors.testColor;
        case WayaColors.secondaryColor2:
          return WayaColors.success;
        case WayaColors.tertiary:
          return WayaColors.success;
        case WayaColors.transparent:
          return WayaColors.success;
        case WayaColors.greyColor500:
          return WayaColors.success;
        case WayaColors.greyColor700:
          return WayaColors.testColor;

        case WayaColors.greyColor400:
          return WayaColors.testColor;

        case WayaColors.greyColor200:
          return WayaColors.testColor;

        case WayaColors.greyColor100:
          return WayaColors.testColor;

        case WayaColors.greyColor300:
          return WayaColors.testColor;

        case WayaColors.greyColor600:
          return WayaColors.testColor;

        case WayaColors.greyColor900:
          return WayaColors.testColor;

        case WayaColors.darkGrey:
          return WayaColors.testColor;
        case WayaColors.black:
          return WayaColors.testColor;
        case WayaColors.customBlack:
          return WayaColors.success;
        case WayaColors.white:
          return WayaColors.success;
        case WayaColors.white50:
          return WayaColors.success;
        case WayaColors.scaffoldColor:
          return WayaColors.success;
        case WayaColors.scaffoldColor2:
          return WayaColors.success;
        case WayaColors.cardBackgroudColor:
          return WayaColors.success;
        case WayaColors.cardBorderColor200:
          return WayaColors.success;
        case WayaColors.cardBorderColor300:
          return WayaColors.success;
        default:
          return WayaColors.success; // Default to green if no match
      }
    }
  }
}
