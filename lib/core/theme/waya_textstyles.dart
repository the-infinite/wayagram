import 'package:flutter/material.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

import 'waya_colors.dart';

class WayaTextStyles {
  //! This class is not instantiatable.
  WayaTextStyles._();

  //
  static const labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
    //overflow: TextOverflow.ellipsis,
  );
  static const labelMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
    // overflow: TextOverflow.ellipsis,
  );
  //
  static const titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
//
  static const headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
    //overflow: TextOverflow.ellipsis,
  );
  //
  static const bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const bodySemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const bodyBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const bodyExtraMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  //
  static const hintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: WayaColors.greyColor400,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const errorhintStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: WayaColors.error,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static const hintStyleSemiBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: WayaColors.greyColor400,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );

  static const hintStyleBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: WayaColors.greyColor400,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );

  // description
  static const descriptionStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: WayaColors.greyColor500,
    fontFamily: WayaConstants.fontFamily,
  //  overflow: TextOverflow.ellipsis,
  );
  static const mediumDescriptionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: WayaColors.greyColor500,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  //
  static const smallActiveLinkStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: WayaColors.customPrimary,
    fontFamily: WayaConstants.fontFamily,
  );
}
