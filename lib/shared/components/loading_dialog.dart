import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';

class WayaLoadingDialog extends StatelessWidget {
  final String message;
  final Color spinnerColor;
  final TextStyle? textStyle;

  const WayaLoadingDialog({
    super.key,
    this.message = 'Loading...',
    this.spinnerColor = Colors.blue,
    this.textStyle,
  });

  // Static method to show the dialog
  static Future<void> show(
    BuildContext context, {
    String message = 'Loading...',
    Color spinnerColor = WayaColors.customPrimary,
    TextStyle? textStyle,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => WayaLoadingDialog(
        message: message,
        spinnerColor: spinnerColor,
        textStyle: textStyle,
      ),
    );
  }

  // Static method to hide the dialog
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Dialog(
      backgroundColor: wayaTheme.colorScheme.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: textStyle ??
                    TextStyle(
                      color: wayaTheme.colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension method for easier calling
extension LoadingDialogExtension on BuildContext {
  void showLoading({
    String message = 'Loading...',
    Color spinnerColor = WayaColors.customPrimary,
    TextStyle? textStyle,
    bool barrierDismissible = false,
  }) {
    WayaLoadingDialog.show(
      this,
      message: message,
      spinnerColor: spinnerColor,
      textStyle: textStyle,
      barrierDismissible: barrierDismissible,
    );
  }

  void hideLoading() {
    WayaLoadingDialog.hide(this);
  }
}
