import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/app/bindings/wayagram_binding.dart';
import 'package:wayagram/routes/app_pages.dart';

import 'app/data/providers/my_pref.dart';
import 'app/modules/home/home.dart';
import 'app/modules/onboarding/onboarding.dart';
import 'core/theme/app_themes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init('MyPref');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var initial = MyPref.authToken.val.isNotEmpty ? const Home(key: Key('wayagram_home')) : const OnboardingPage(key: Key('wayagram_onboarding'));
    return GetMaterialApp(
      theme: AppThemes.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: initial,
      initialBinding: WayagramBinding(),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}