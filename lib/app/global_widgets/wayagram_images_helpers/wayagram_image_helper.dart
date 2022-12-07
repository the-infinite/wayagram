
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/providers/my_pref.dart';

class ImageHelper {
  static Widget svgImage(String path, {double? width, double? height, Color? color,BoxFit? fit}) {
    var anotherApp = MyPref.anotherApp.val;
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      color: color,
      package: anotherApp ? 'wayagram' : null,
      fit: fit ?? BoxFit.contain,
    );
  }

  static Widget normalImage(String path, {double? width, double? height, Color? color,BoxFit? fit}) {
    var anotherApp = MyPref.anotherApp.val;
    return Image.asset(
      path,
      width: width,
      height: height,
      color: color,
      package: anotherApp ? 'wayagram' : null,
      fit: fit,
    );
  }
}