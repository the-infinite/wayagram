import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WayaNav<T> {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static VoidCallback? onChange;
  
  static NavigatorState get _navigator => navigatorKey.currentState!;
  static BuildContext get context => navigatorKey.currentContext!;
  static String get currentRoute => ModalRoute.of(context)?.settings.name ?? '/';
  static bool get isDialogOpen => ModalRoute.of(context)?.isCurrent != true;

  WayaNav._();

  static Future<T?> to<T>(
    Widget page, {
    Function(T?)? onResult,
    bool preventDuplicates = false,
    Duration duration = const Duration(milliseconds: 500),
    WayaTransition transition = WayaTransition.rightToLeft,
  }) {
    try {
      onChange?.call();
      onChange = null;
    } catch (_) {}
    
    return _navigator.push<T>(
      WayaPageRoute<T>(
        page: page,
        transition: transition,
        duration: duration,
      ),
    ).then((result) {
      if (onResult != null) {
        onResult(result);
      }
      return result;
    });
  }

  // This remove all screens on the stack leaving just one screen
  static Future<T?>? removeUntil<T>(
    Widget page, [
    Duration duration = const Duration(milliseconds: 500),
  ]) {
    return _navigator.pushAndRemoveUntil<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
      (route) => false, // Remove all previous routes
    );
  }

  // Remove all screens on the stack until the target route
  static Future<T?>? removeAllUntil<T extends Widget>(
      Widget newScreen, String targetRoute) {
    return _navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(builder: (context) => newScreen),
      ModalRoute.withName(targetRoute),
    );
  }

  // This remove all screens on the stack leaving just one screen
  static Future<T?> removeUntilNamed<T>(String route,
      {dynamic arguments,
      Function(dynamic)? onResult,
      RoutePredicate? predicate}) {
    return _navigator.pushNamedAndRemoveUntil<T>(
      route,
      predicate ?? (route) => false,
      arguments: arguments,
    ).then((result) {
      if (onResult != null) {
        onResult(result);
      }
      return result;
    });
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
  /// WayaNav.popUntil((route) => route.settings.name == 'home');
  /// ```
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    return _navigator.popUntil(predicate);
  }

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
    if (closeOverlays) {
      // Close any open dialogs or modals first
      while (_navigator.canPop() && ModalRoute.of(context)?.isCurrent != true) {
        _navigator.pop();
      }
    }
    if (_navigator.canPop()) {
      _navigator.pop<T>(result);
    }
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
  static Future<T?> toNamed<T>(String route,
      {dynamic arguments,
      Function(dynamic)? onResult,
      bool preventDuplicates = true}) {
    try {
      onChange?.call();
      onChange = null;
    } catch (_) {}
    
    return _navigator.pushNamed<T>(
      route,
      arguments: arguments,
    ).then((result) {
      if (onResult != null) {
        onResult(result);
      }
      return result;
    });
  }

  static Future<T?> replaceNamed<T>(String route,
      {dynamic arguments, Function(dynamic)? onResult}) {
    return _navigator.pushReplacementNamed<T, void>(
      route,
      arguments: arguments,
    ).then((result) {
      if (onResult != null) {
        onResult(result);
      }
      return result;
    });
  }

  static Future<T?>? off<T>(Widget page) {
    return _navigator.pushReplacement<T, void>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    );
  }

  static Future<T?>? offNamed<T>(String route, {dynamic arguments}) {
    return _navigator.pushReplacementNamed<T, void>(
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
    // Remove the specified number of screens from the stack
    int removed = 0;
    _navigator.popUntil((route) {
      removed++;
      return removed >= removeCount;
    });

    // Navigate to the specified route
    return _navigator.pushReplacementNamed<T, void>(
      route,
      arguments: arguments,
    ).then((result) {
      if (onResult != null) {
        onResult(result);
      }
      return result;
    });
  }

  // Close the whole app
  // Use case: when the app is opened with link
  static void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  static bool canPop() => _navigator.canPop();

  // Get route parameters (arguments)
  static Map<String, dynamic> get parameters {
    final route = ModalRoute.of(context);
    if (route?.settings.arguments is Map<String, dynamic>) {
      return route!.settings.arguments as Map<String, dynamic>;
    }
    return {};
  }

  // Legacy alias for parameters
  static Map<String, dynamic> get search => parameters;
}

// Custom route transition types (replacing GetX Transition enum)
enum WayaTransition {
  fade,
  fadeIn,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  rightToLeftWithFade,
  leftToRightWithFade,
  zoom,
  topLevel,
  noTransition,
  cupertino,
  cupertinoDialog,
  size,
  circularReveal,
  native,
}

// Helper class for creating custom page routes with transitions
class WayaPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final WayaTransition transition;
  final Duration duration;

  WayaPageRoute({
    required this.page,
    this.transition = WayaTransition.rightToLeft,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(transition, animation, child);
          },
        );

  static Widget _buildTransition(
    WayaTransition transition,
    Animation<double> animation,
    Widget child,
  ) {
    switch (transition) {
      case WayaTransition.fade:
        return FadeTransition(opacity: animation, child: child);
      
      case WayaTransition.fadeIn:
        return FadeTransition(
          opacity: animation.drive(
            Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeIn)),
          ),
          child: child,
        );
      
      case WayaTransition.rightToLeft:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      
      case WayaTransition.leftToRight:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      
      case WayaTransition.upToDown:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      
      case WayaTransition.downToUp:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      
      case WayaTransition.rightToLeftWithFade:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      
      case WayaTransition.leftToRightWithFade:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      
      case WayaTransition.zoom:
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutQuart)),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      
      case WayaTransition.topLevel:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: child,
        );
      
      case WayaTransition.noTransition:
        return child;
      
      case WayaTransition.cupertino:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.linearToEaseOut)),
          ),
          child: child,
        );
      
      case WayaTransition.cupertinoDialog:
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 1.3, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: FadeTransition(
            opacity: animation.drive(
              Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeOut)),
            ),
            child: child,
          ),
        );
      
      case WayaTransition.size:
        return SizeTransition(sizeFactor: animation, child: child);
      
      case WayaTransition.circularReveal:
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.fastOutSlowIn)),
          ),
          child: FadeTransition(
            opacity: animation.drive(
              Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: child,
          ),
        );
      
      case WayaTransition.native:
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.fastOutSlowIn)),
          ),
          child: child,
        );
    }
  }
}