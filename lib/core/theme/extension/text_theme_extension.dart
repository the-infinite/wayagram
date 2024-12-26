import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';

extension WayaTextThemeX on TextTheme {
  TextStyle get bodySemiBold => WayaTextStyles.bodySemiBold;
  TextStyle get hintStyle => WayaTextStyles.hintStyle;
  TextStyle get hintStyleBold => WayaTextStyles.hintStyleBold;
  TextStyle get descriptionStyle => WayaTextStyles.descriptionStyle;
  TextStyle get bodyXtraMedium => WayaTextStyles.bodyXtraMedium;
  TextStyle get titleLarge => WayaTextStyles.titleLarge;
}
