import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';

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
      VoidCallback? onCancel}) {
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
    String formattedCurrency = NumberFormat.currency(locale: 'en_US', symbol: '₦').format(price);

    return formattedCurrency;
  }

  static void countFormCharacters(TextEditingController contoller, int length) {
    if (contoller.text.length >= length) {
      contoller.text = contoller.text.substring(0, length);

      contoller.selection = TextSelection.fromPosition(
        TextPosition(offset: contoller.text.length),
      );
    }
  }

  static String formatDateString(String isoDateString) {
    // Parse the ISO 8601 date string into a DateTime object
    DateTime date = DateTime.parse(isoDateString);

    // Define the desired format using DateFormat
    DateFormat dateFormat = DateFormat('MMMM dd, yyyy'); // "August 10, 2020"

    // Format the DateTime object into the desired string
    return dateFormat.format(date);
  }

  static String formatDateMonthYear(String isoDate) {
    // Parse the ISO 8601 string into a DateTime object
    DateTime dateTime = DateTime.parse(isoDate);

    // Format the DateTime object to the desired string format (e.g., "December 2021")
    return DateFormat('MMMM yyyy').format(dateTime);
  }
}
