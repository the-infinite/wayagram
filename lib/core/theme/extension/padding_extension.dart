import 'package:flutter/material.dart';

//Getters for ui padding
extension WayaEdgeInsetsExtension on EdgeInsets {
  static EdgeInsets fromPercentage({
    required double lefthorizontalPercentage,
    required double righthorizontalPercentage,
    required double topverticalPercentage,
    required double bottomverticalPercentage,
    Size referenceSize = const Size(375, 812),
    required BuildContext context,
  }) {
    return EdgeInsets.only(
      left: lefthorizontalPercentage /
          referenceSize.width *
          MediaQuery.sizeOf(context).width,
      right: righthorizontalPercentage /
          referenceSize.width *
          MediaQuery.sizeOf(context).width,
      top: topverticalPercentage /
          referenceSize.height *
          MediaQuery.sizeOf(context).height,
      bottom: bottomverticalPercentage /
          referenceSize.height *
          MediaQuery.sizeOf(context).height,
    );
  }
}

extension MediaQueryShortcut on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}