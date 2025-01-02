import 'package:get/get.dart';
import 'package:wayagram/core/theme/waya_colors.dart';

class WayaSnackbar {
  static void showSnackbar() {
    Get.snackbar(
      'Snackbar Title',
      'This is a Snackbar message.',
      snackPosition: SnackPosition.BOTTOM, // Position of the Snackbar
      backgroundColor: WayaColors.primary, // Background color
      colorText: WayaColors.onPrimary, // Text color
      duration: Duration(seconds: 3), // Duration for how long the Snackbar is visible
    );
  }

  static void showToast(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM, // Position of the Toast
        backgroundColor: WayaColors.primary,
        isDismissible: true, // Whether the toast can be dismissed by tapping
      ),
    );
  }
}
