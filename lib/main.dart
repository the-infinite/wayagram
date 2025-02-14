import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/theme/vm/theme_vm.dart';
import 'package:wayagram/core/theme/waya_theme.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:wayagram/core/utils/waya_routes.dart';

void main() async {
  //? First, initialize everything that should be initialized.
  await GetStorage.init();
  Firebase.initializeApp();
  await PushNotifications.init();
  WayaSnackBar.setUpSnackBarUI();

  //? Second, remove the native splash screen at this point in time.
  // TODO: Switch to native splash screens when possible.

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
    /*return DevicePreview(
        enabled: true,
        builder: (BuildContext context) {
          ScreenUtilInit(
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
        });*/
  }
}
