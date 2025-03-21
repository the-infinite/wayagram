import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/helpers/deep_linking_listener.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/theme/vm/theme_vm.dart';
import 'package:wayagram/core/utils/task.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'firebase_options.dart';

void main() async {
  //? First, set up all Firebase services so we can report all crashes to firebase,
  //? have analytics, crashlytics, and push notifications set up.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //? Second, setup the error handlers for synchronous errors here and asynchronous
  //? errors here.
  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      //? If this is production.
      if (WayaConstants.isProduction) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      }

      //? Since it is not.
      else {
        WayaDebugConsoleController.instance.addDebugEvent(
          WayaDebugEvent(
            type: WayaDebugEventType.flutter,
            module: WayaDebugEventModule.unknown,
            message: errorDetails.summary.toDescription(),
            raw: errorDetails,
            stackTrace: errorDetails.stack,
            timestamp: DateTime.now(),
          ),
        );
      }
    };

    //* For async errors.
    PlatformDispatcher.instance.onError = (error, stack) {
      //? If this is production.
      if (WayaConstants.isProduction) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }

      //? Since it is not.
      else {
        WayaDebugConsoleController.instance.addDebugEvent(
          WayaDebugEvent(
            type: WayaDebugEventType.runtime,
            module: WayaDebugEventModule.unknown,
            message: error.toString().split("\n").first.trim(),
            raw: error,
            stackTrace: stack,
            timestamp: DateTime.now(),
          ),
        );
      }
      return true;
    };

    //* For errors outside of flutter...
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;

      //? If this is production.
      if (WayaConstants.isProduction) {
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: true,
        );
      }

      //? Since it is not.
      else {
        WayaDebugConsoleController.instance.addDebugEvent(
          WayaDebugEvent(
            type: WayaDebugEventType.runtime,
            module: WayaDebugEventModule.unknown,
            message: errorAndStacktrace.first.toString().split("\n").first.trim(),
            raw: errorAndStacktrace.first,
            stackTrace: StackTrace.fromString(errorAndStacktrace.last.toString()),
            timestamp: DateTime.now(),
          ),
        );
      }
    }).sendPort);
  }

  //? Third, initialize everything that should be initialized.
  await GetStorage.init();
  await PushNotifications.init();
  WayaSnackBar.setUpSnackBarUI();
  await TaskScheduler.init();

  //? Fourth, remove the native splash screen at this point in time.
  // TODO: Switch to native splash screens when possible.

  //? Fifth, configure our visibility detector.
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 50);

  //? Finally, run the app.
  //? added DeepLinkListener to listen to incoming deepLinking urls
  runApp(ProviderScope(child: const DeepLinkListener(child: Wayagram())));
}

class Wayagram extends ConsumerStatefulWidget {
  const Wayagram({super.key});

  @override
  ConsumerState<Wayagram> createState() => _WayagramState();
}

class _WayagramState extends ConsumerState<Wayagram> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    var size = MediaQuery.of(context).size;
    //? added this screenutil init here to register before getting to the theme
    //? else it will throw an error
    ScreenUtil.init(
      context,
      designSize: Size(size.width, size.height),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return GetMaterialApp(
      initialRoute: '/',
      title: WayaConstants.appName,
      theme: WayaTheme.lightTheme,
      darkTheme: WayaTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      getPages: WayaAppRoutes.getPages,
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: WayaPreloaderController.instance.notifier,
        builder: (context, showPreloader, _) => Stack(
          children: [
            //? First, the widget that is being laid out.
            child!,

            //? Second, our preloader widget.
            if (showPreloader) WayaPreloaderOverlay(),

            //? Third, the debug console.
            //if (!WayaConstants.isProduction) WayaDebugConsole(),
          ],
        ),
      ),
    );
  }
}
