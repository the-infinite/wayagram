import 'package:get/get.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';

import '../app/bindings/wayagram_binding.dart';
import '../app/data/providers/my_pref.dart';
import '../app/modules/multiplexor/multiplexor.dart';
import '../app/modules/onboarding/onboarding.dart';
import '../app/modules/profile/confirm_pin.dart';
import '../app/modules/profile/create_pin.dart';
import '../app/modules/profile/profile.dart';
import '../app/modules/profile/update_profile.dart';
import '../app/modules/setup/interests.dart';
import '../app/modules/sign_in/sign_in.dart';
import '../app/modules/verify_otp/verify_otp.dart';

class AppPages {
  AppPages._();
  static String initial = MyPref.authToken.val.isNotEmpty ? Home.route : OnboardingPage.route;
  //static String initial =  OnboardingPage.route;

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
      binding: WayagramBinding(),
    ),
    GetPage(
      name: SignUp.route,
      page: () => const SignUp(),
      binding: WayagramBinding(),
    ),
    GetPage(
      name: VerifyOTP.route,
      page: () => const VerifyOTP(),
      binding: WayagramBinding(),
    ),
    GetPage(
        name: CreatePIN.route,
        page: () => const CreatePIN()
    ),
    GetPage(
        name: UpdateProfile.route,
        page: () => const UpdateProfile()
    ),

    GetPage(
        name: CreatePIN.route,
        page: () => const CreatePIN()
    ),
    GetPage(
        name: ConfirmPIN.route,
        page: () => const ConfirmPIN()
    ),
    GetPage(
        name: Interests.route,
        page: () => const Interests()
    ),

    GetPage(
      name: Home.route,
      page: () => const Home(),
      binding: WayagramBinding(),
    ),

    GetPage(
      name: Profile.route,
      page: () => const Profile(),
      binding: WayagramBinding(),
    ),
  ];
}
