import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_bottom_sheet_content.dart';
import 'package:wayagram/core/data/model.dart';

class WayaHelpers {
  static Future<void> showNotice(
      {required BuildContext context,
      required String title,
      required String message,
      required VoidCallback onPress,
      required Widget icon,
      String? buttonText,
      String? secondButtonText,
      Widget? buttonCenterWidget,
      Widget? secondButtonCenterWidget,
      VoidCallback? onCancel
      }) {
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
          secondButtonCenterWidget: secondButtonCenterWidget,
          buttonCenterWidget: buttonCenterWidget,
          secondButtonText: secondButtonText,
          onCancel: onCancel,
        );
      },
    );
  }

  static Future<Select> showSelectModal({
    required BuildContext context,
    required String title,
    required List<Select> items,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WayaBottomSheetContent(
          title: title,
          items: items,
        );
      },
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: Navigator.of(context),
      ),
    );
    return result;
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

  static String formatPrice(int price) {
    String formattedCurrency =
        NumberFormat.currency(locale: 'en_US', symbol: '₦').format(price);

    return formattedCurrency;
  }
}
