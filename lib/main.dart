import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/routes/app_pages.dart';

import 'app/data/providers/my_pref.dart';
import 'app/modules/home/home.dart';
import 'app/modules/onboarding/onboarding.dart';
import 'core/theme/app_themes.dart';

Future<void> main() async {
  await GetStorage.init('MyPref');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var token = MyPref.authToken.val;
    print(token);
    return GetMaterialApp(
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}