import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
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
  await GetStorage.init('MyPref');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Freshchat.init("360f8adf-353c-4639-97c5-e07409a4312b", "22786a6e-2a51-4246-8b8d-cf218789930c","msdk.freshchat.com");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var initial = OnboardingPage(key: Key('wayagram_onboarding'));
    var initial = MyPref.authToken.val.isNotEmpty ? const Home(key: Key('wayagram_home')) : const OnboardingPage(key: Key('wayagram_onboarding'));
    MyPref.currentApp.val = 'wayagram';
    return AppBuilder(builder: (context) {
      return GetMaterialApp(
        key: UniqueKey(),
        theme: AppThemes.lightTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: initial,
        initialBinding: WayagramBinding(),
      );
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}

class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;

  const AppBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  AppBuilderState createState() => AppBuilderState();

  static AppBuilderState? of(BuildContext context) {
    return context.findRootAncestorStateOfType<AppBuilderState>();
  }
}

class AppBuilderState extends State<AppBuilder> {

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}