import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';

class WayaHelpers {
  static Future<void> showNotice(
      {required BuildContext context,
      required String title,
      required String message,
      required VoidCallback onPress,
      required Widget icon,
      required String buttonText}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WayaNoticeModal(
          title: title,
          onPress: onPress,
          message: message,
          icon: icon,
          buttonText: buttonText,
        );
      },
    );
  }

static String toOrdinal(int number) {
    if (number < 1) return number.toString();
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th'; 
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

}
