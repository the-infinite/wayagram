import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/vm/theme_vm.dart';
import 'package:wayagram/core/theme/waya_theme.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:wayagram/core/utils/waya_routes.dart';

void main() async {
  await GetStorage.init();
  WayaSnackBar.setUpSnackBarUI();

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
