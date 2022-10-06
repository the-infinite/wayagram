
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class AppTextStyle {
  AppTextStyle._();
  static const String _font = 'Montserrat';

  static  TextStyle bodyText1 = TextStyle(
    color: AppColors.platinum,
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    fontSize: 16  * Get.textScaleFactor * 0.90,
  );
  static  TextStyle bodyText2 = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontSize: 15 * Get.textScaleFactor * 0.90,
  );
  static  TextStyle subtitle2 = TextStyle(
    fontFamily: _font,
    color: AppColors.platinum,
    fontWeight: FontWeight.w500,
    fontSize: 14 * Get.textScaleFactor * 0.90,
  );
  static  TextStyle caption = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    color: AppColors.platinum,
    fontSize: 12 * Get.textScaleFactor * 0.90,
  );
  static  TextStyle subtitle1 = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.normal,
    color: AppColors.platinum,
    fontSize: 16 * Get.textScaleFactor * 0.90,
  );
  static  TextStyle headline5 = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    color: AppColors.platinum,
    fontSize: 20 * Get.textScaleFactor * 0.90,
  );
  static  TextStyle headline4 = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    color: AppColors.platinum,
    fontSize: 18 * Get.textScaleFactor * 0.90,
  );
  static  TextStyle headline6 = TextStyle(
    fontFamily: _font,
    color: AppColors.platinum,
    fontWeight: FontWeight.w600,
    fontSize: 24 * Get.textScaleFactor * 0.90,
  );
  static  TextStyle button = TextStyle(
    fontSize: 18 * Get.textScaleFactor * 0.90,
    fontWeight: FontWeight.w700,
    fontFamily: _font,
    color: AppColors.platinum,
  );
  static  TextStyle headline2 = TextStyle(
    fontSize: 34 * Get.textScaleFactor * 0.90,
    fontWeight: FontWeight.w500,
    color: AppColors.platinum,
    fontFamily: _font,
  );
}
