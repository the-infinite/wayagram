import 'package:flutter/material.dart';
import 'package:wayagram/app/data/providers/my_pref.dart';

Color getAppColor(Color color){
  var darkMode = MyPref.darkMode.val;
  if(darkMode){
    return invert(color);
  }
  return color;
}

Color invert(Color color) {
  final r = 255 - color.red;
  final g = 255 - color.green;
  final b = 255 - color.blue;

  return Color.fromARGB((color.opacity * 255).round(), r, g, b);
}