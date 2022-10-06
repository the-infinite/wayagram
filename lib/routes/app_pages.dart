import 'package:get/get.dart';

import '../app/modules/multiplexor/multiplexor.dart';
import '../app/modules/onboarding/onboarding.dart';

class AppPages {
  AppPages._();
  //static String initial = MyPref.authToken.val.isNotEmpty ? HomePage.route : OnbordingPage.route;
  static String initial =  OnboardingPage.route;

  static final routes = [
    GetPage(
      name: OnboardingPage.route,
      page: () => const OnboardingPage()
    ),
    GetPage(
        name: Multiplexor.route,
        page: () => const Multiplexor()
    ),
  ];
}
