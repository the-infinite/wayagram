import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

import 'waya_colors.dart';

class WayaTextStyles {
  //! This class is not instantiatable.
  WayaTextStyles._();

  //
  static final labelSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
    //overflow: TextOverflow.ellipsis,
  );
  static final labelMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
    // overflow: TextOverflow.ellipsis,
  );
  //
  static final titleLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static final titleMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
//
  static final headlineLarge = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static final headlineMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
    //overflow: TextOverflow.ellipsis,
  );
  //
  static final bodyMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static final bodySemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static final bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );

  static final bodyBold = TextStyle(
    fontSize: 14.sp,

    fontWeight: FontWeight.w700,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static final bodyExtraMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: WayaColors.black,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  //
  static final hintStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: WayaColors.greyColor400,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );

  static final errorhintStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: WayaColors.error,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  static final hintStyleSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: WayaColors.greyColor400,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );

  static final hintStyleBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: WayaColors.greyColor400,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );

  // description
  static final descriptionStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: WayaColors.greyColor500,
    fontFamily: WayaConstants.fontFamily,
  //  overflow: TextOverflow.ellipsis,
  );
  static final mediumDescriptionStyle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: WayaColors.greyColor500,
    fontFamily: WayaConstants.fontFamily,
   // overflow: TextOverflow.ellipsis,
  );
  //
  static final smallActiveLinkStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: WayaColors.customPrimary,
    fontFamily: WayaConstants.fontFamily,
  );
}
