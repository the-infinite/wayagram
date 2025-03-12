import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WayaNav<T> {
  static String get currentRoute => Get.currentRoute;

  WayaNav._();

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

//this remove all screens on the stack leaving just one screen
  static void removeUntil(Widget page) {
    Get.offAll(
      () => page,
      transition: Transition.cupertino,
    );
  }

  //remove all screens on the stack until the target route
  static void removeAllUntil<T extends Widget>(Widget newScreen, String targetRoute) {
    Get.offUntil(
      GetPageRoute(page: () => newScreen),
      ModalRoute.withName(targetRoute),
    );
  }

//this remove all screens on the stack leaving just one screen
  static void removeUntilNamed(String route,
      {dynamic arguments, Function(dynamic)? onResult, RoutePredicate? predicate}) {
    Get.offAllNamed(
      route,
      arguments: arguments,
      predicate: predicate,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
    });
  }

  static void goBack<T>({T? result}) {
    Get.back(
      result: result,
    );
  }

  static void toNamed(String route, {dynamic arguments, Function(dynamic)? onResult}) {
    Get.toNamed(
      route,
      arguments: arguments,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
    });
  }

  static void replaceNamed(String route, {dynamic arguments, Function(dynamic)? onResult}) {
    Get.offNamed(
      route,
      arguments: arguments,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
    });
  }

  static void off(Widget page) {
    Get.off(
      () => page,
      transition: Transition.cupertino,
    );
  }

  static void offNamed(String route, {dynamic arguments}) {
    Get.offNamed(
      route,
      arguments: arguments,
    );
  }

  static Map<String, String?> get search => Get.parameters;
}
