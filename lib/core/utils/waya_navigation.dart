import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

class WayaNav<T> {
  static String get currentRoute => Get.currentRoute;
  static VoidCallback? onChange;
  static BuildContext get context => Get.context!;
  static bool get isDialogOpen =>
      (Get.isBottomSheetOpen ?? false) || (Get.isDialogOpen ?? false);

  WayaNav._();

  static Future<T> to<T>(
    Widget page, {
    Function(T)? onResult,
    bool preventDuplicates = false,
    Transition transition = Transition.cupertino,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    final completer = Completer<T>();
    try {
      onChange?.call();
      onChange = null;
    } catch (_) {}
    Get.to(
      () => page,
      transition: transition,
      preventDuplicates: preventDuplicates,
      duration: duration,
    )?.then((result) {
      if (onResult != null) {
        onResult(result);
      }
      completer.complete(result);
    });
    return completer.future;
  }

  // This remove all screens on the stack leaving just one screen
  static Future<T?>? removeUntil<T>(
    Widget page, [
    Duration duration = const Duration(milliseconds: 500),
    Transition transition = Transition.cupertino,
  ]) {
    return Get.offAll(
      () => page,
      transition: transition,
      duration: duration,
    );
  }

  // Remove all screens on the stack until the target route
  static Future<T?>? removeAllUntil<T extends Widget>(
      Widget newScreen, String targetRoute) {
    return Get.offUntil(
      GetPageRoute(page: () => newScreen),
      ModalRoute.withName(targetRoute),
    );
  }

  // This remove all screens on the stack leaving just one screen
  static Future<T> removeUntilNamed<T>(String route,
      {dynamic arguments,
      Function(dynamic)? onResult,
      RoutePredicate? predicate}) {
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

  /// Closes routes in the navigation stack until a route matches the given [predicate].
  ///
  /// The [predicate] is a function that takes a [Route] and returns a boolean.
  /// Routes will be popped from the stack until a route is found where [predicate]
  /// returns true.
  ///
  /// Example:
  /// ```dart
  /// // Close until we find a route named 'home'
  /// WayaNav.closeUntil((route) => route.settings.name == 'home');
  /// ```
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    return Get.until(predicate);
  }

  //
  /// Navigates back in the application's navigation stack.
  ///
  /// This method removes the current route from the navigation stack and returns
  /// to the previous screen.
  ///
  /// Parameters:
  /// - [result]: Optional data to pass back to the previous screen.
  /// - [closeOverlays]: Whether to close any open overlays (like modals or
  ///   popups) when navigating back. Defaults to false.
  ///
  /// Example:
  /// ```dart
  /// WayaNav.goBack(); // Simple navigation back
  /// WayaNav.goBack(result: someData); // Navigate back with data
  /// WayaNav.goBack(closeOverlays: true); // Navigate back and close overlays
  /// ```
  static void goBack<T>({T? result, bool closeOverlays = false}) {
    return Get.back(
      result: result,
      closeOverlays: closeOverlays,
    );
  }

  /// Navigates to a named route asynchronously.
  ///
  /// Returns a Future that completes with a result of type [T] when the route is popped.
  /// The [route] parameter specifies the name of the route to navigate to.
  ///
  /// Example:
  /// ```dart
  /// WayaNav.toNamed('/home');
  /// ```
  static Future<T> toNamed<T>(String route,
      {dynamic arguments,
      Function(dynamic)? onResult,
      bool preventDuplicates = true}) {
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

  static Future<T?> replaceNamed<T>(String route,
      {dynamic arguments, Function(dynamic)? onResult}) {
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

  static Future<T?>? off<T>(
    Widget page, {
    Transition transition = Transition.cupertino,
  }) {
    return Get.off(
      () => page,
      transition: transition,
    );
  }

  static Future<T?>? offNamed<T>(String route, {dynamic arguments}) {
    return Get.offNamed(
      route,
      arguments: arguments,
    );
  }

  static Future<T?> replaceWithNamedAndRemoveScreens<T>(
    String route, {
    int removeCount = 1,
    dynamic arguments,
    Function(dynamic)? onResult,
  }) {
    final completer = Completer<T>();

    //> Remove the specified number of screens from the stack
    int removed = 0;
    Get.until((route) {
      removed++;
      return removed > removeCount;
    });

    //> Navigate to the specified route
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

  //close the whole app
  // use case, when the app is opened with link
  static void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  static bool canPop() => Navigator.canPop(context);

  static Map<String, String?> get search => Get.parameters;
}
