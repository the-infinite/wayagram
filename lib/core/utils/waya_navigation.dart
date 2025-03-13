import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WayaNav<T> {
  static String get currentRoute => Get.currentRoute;
  static VoidCallback? onChange;

  WayaNav._();

  static Future<T> to<T>(Widget page, {Function(T)? onResult, bool preventDuplicates = true}) {
    final completer = Completer<T>();
    try {
      onChange?.call();
      onChange = null;
    } catch (_) {}
    Get.to(
      () => page,
      transition: Transition.cupertino,
      preventDuplicates: preventDuplicates,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
      completer.complete(result);
    });
    return completer.future;
  }

  // This remove all screens on the stack leaving just one screen
  static Future<T?>? removeUntil<T>(Widget page) {
    return Get.offAll(
      () => page,
      transition: Transition.cupertino,
    );
  }

  // Remove all screens on the stack until the target route
  static Future<T?>? removeAllUntil<T extends Widget>(Widget newScreen, String targetRoute) {
    return Get.offUntil(
      GetPageRoute(page: () => newScreen),
      ModalRoute.withName(targetRoute),
    );
  }

  // This remove all screens on the stack leaving just one screen
  static Future<T> removeUntilNamed<T>(String route,
      {dynamic arguments, Function(dynamic)? onResult, RoutePredicate? predicate}) {
    final completer = Completer<T>();
    Get.offAllNamed(
      route,
      arguments: arguments,
      predicate: predicate,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
      completer.complete(result);
    });
    return completer.future;
  }

  //
  static void goBack<T>({T? result}) {
    Get.back(
      result: result,
    );
  }

  static Future<T> toNamed<T>(String route,
      {dynamic arguments, Function(dynamic)? onResult, bool preventDuplicates = true}) {
    final completer = Completer<T>();
    try {
      onChange?.call();
      onChange = null;
    } catch (_) {}
    Get.toNamed(
      route,
      arguments: arguments,
      preventDuplicates: preventDuplicates,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
      completer.complete(result);
    });
    return completer.future;
  }
  

  static Future<T?> replaceNamed<T>(String route, {dynamic arguments, Function(dynamic)? onResult}) {
    final completer = Completer<T>();
    Get.offNamed(
      route,
      arguments: arguments,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
      completer.complete(result);
    });
    return completer.future;
  }

  static Future<T?>? off<T>(Widget page) {
    return Get.off(
      () => page,
      transition: Transition.cupertino,
    );
  }

  static Future<T?>? offNamed<T>(String route, {dynamic arguments}) {
    return Get.offNamed(
      route,
      arguments: arguments,
    );
  }

  static bool canPop() => Navigator.canPop(Get.context!);

  static Map<String, String?> get search => Get.parameters;
}
