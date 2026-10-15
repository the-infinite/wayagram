import 'package:flutter/material.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class WayaSnackBar {
  WayaSnackBar._();

  static void showToast(String message,
      {bool showSuccess = false, String? buttonText, VoidCallback? onPressed}) {
    final context = WayaNav.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: WayaTextStyles.bodyBold.copyWith(
              color: WayaColors.white,
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor:
              showSuccess ? WayaColors.success700 : WayaColors.primary,
          behavior: SnackBarBehavior.floating,
          action: buttonText != null
              ? SnackBarAction(
                  label: buttonText,
                  onPressed: onPressed ?? () {},
                  textColor: WayaColors.white,
                )
              : null,
        ),
      );
    }
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
        isFloating: true,
        isDismissible: true,
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
        isFloating: true,
        isDismissible: true,
      ),
    );
  }
}
