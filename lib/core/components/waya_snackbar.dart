import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class WayaSnackBar {
  WayaSnackBar._();

  static void showToast(String message, {bool showSuccess = false, String? buttonText, VoidCallback? onPressed}) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM, // Position of the Toast
        backgroundColor: showSuccess ? WayaColors.success700 : WayaColors.primary,
        isDismissible: true, // Whether the toast can be dismissed by tapping
        mainButton: buttonText != null
            ? TextButton(
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: WayaTextStyles.bodyBold.copyWith(
                    color: WayaColors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  static void setUpSnackBarUI() {
    final service = SnackbarService();

    service.registerCustomSnackbarConfig(
      variant: SnackbarType.success,
      config: SnackbarConfig(
        backgroundColor: WayaColors.customPrimary,
        textColor: WayaColors.white,
        borderRadius: 1.0,
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.only(bottom: 0, right: 0, left: 0),
        barBlur: 0.6,
        messageColor: WayaColors.white,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
      ),
    );

    service.registerCustomSnackbarConfig(
      variant: SnackbarType.failure,
      config: SnackbarConfig(
        backgroundColor: WayaColors.error,
        textColor: WayaColors.white,
        borderRadius: 1.0,
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.only(bottom: 0, right: 0, left: 0),
        barBlur: 0.6,
        messageColor: WayaColors.white,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
      ),
    );
  }
}
