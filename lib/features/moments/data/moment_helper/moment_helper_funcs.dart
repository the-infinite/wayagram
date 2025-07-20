import 'dart:convert';

import 'package:flutter/material.dart';

class MomentHelper {
  static TextStyle textStyleFromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    return TextStyle(
      fontFamily: json['fontFamily'],
      fontSize: json['fontSize'].toDouble(),
      fontWeight: _parseFontWeight(json['fontWeight']),
      color: hexToColor(json['color']),
    );
  }

  static _parseFontWeight(String fontWeight) {
    switch (fontWeight) {
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  static Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse(hexColor, radix: 16));
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  static String textStyleToJson(TextStyle textStyle) {
    return '''
    {
      "fontFamily": "${textStyle.fontFamily}",
      "fontSize": ${textStyle.fontSize},
      "fontWeight": "${textStyle.fontWeight}",
      "color": "${colorToHex(textStyle.color!)}"
    }
    ''';
  }
}
