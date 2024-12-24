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
}
