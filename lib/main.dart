import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/theme/vm/theme_vm.dart';
import 'package:wayagram/core/theme/waya_theme.dart';
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
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    //* For async errors.
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    //* For errors outside of flutter...
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
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
  VisibilityDetectorController.instance.notifyNow(); 

  //? Finally, run the app.
  runApp(ProviderScope(child: const Wayagram()));
}

class Wayagram extends ConsumerWidget {
  const Wayagram({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    var size = MediaQuery.of(context).size;
    return ScreenUtilInit(
      designSize: Size(size.width, size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        initialRoute: '/',
        title: WayaConstants.appName,
        theme: WayaTheme.lightTheme,
        darkTheme: WayaTheme.darkTheme,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        getPages: WayaAppRoutes.getPages,
      ),
    );
  }
}
