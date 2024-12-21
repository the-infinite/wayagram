import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WayaNav<T> {
  static void to(Widget page, {Function(dynamic)? onResult}) {
    Get.to(
      () => page,
      transition: Transition.cupertino,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
    });
  }

  static void removeUntil(Widget page) {
    Get.offAll(
      () => page,
      transition: Transition.cupertino,
    );
  }

  static void off(Widget page) {
    Get.off(
      () => page,
      transition: Transition.cupertino,
    );
  }

  static void goBack<T>({T? result}) {
    Get.back(
      result: result,
    );
  }
}
