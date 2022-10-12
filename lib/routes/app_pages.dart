import 'package:get/get.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';

import '../app/bindings/auth_binding.dart';
import '../app/modules/multiplexor/multiplexor.dart';
import '../app/modules/onboarding/onboarding.dart';
import '../app/modules/sign_in/sign_in.dart';

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
    GetPage(
      name: SignIn.route,
      page: () => const SignIn(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: SignUp.route,
      page: () => const SignUp(),
      binding: AuthBinding(),
    ),
  ];
}
