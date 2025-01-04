import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../components/components.dart';

class WayaUtils {
  static copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    WayaSnackBar.showToast('Copied');
  }

  static showModalSheet(BuildContext context, {required Widget child}) {
    return showModalBottomSheet(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
        builder: (context) => child);
  }
}
