import 'package:get/get.dart';
import 'package:wayagram/app/modules/groups_and_pages/groups_and_pages.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/app/modules/sign_up/sign_up.dart';

import '../app/bindings/wayagram_binding.dart';
import '../app/data/providers/my_pref.dart';
import '../app/modules/contacts/contact.dart';
import '../app/modules/multiplexor/multiplexor.dart';
import '../app/modules/onboarding/onboarding.dart';
import '../app/modules/profile/confirm_pin.dart';
import '../app/modules/profile/create_pin.dart';
import '../app/modules/profile/other_profile.dart';
import '../app/modules/profile/post_profile.dart';
import '../app/modules/profile/profile.dart';
import '../app/modules/profile/update_profile.dart';
import '../app/modules/search/search.dart';
import '../app/modules/settings/settings.dart';
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
      page: () => OnboardingPage()
    ),
    GetPage(
        name: Multiplexor.route,
        page: () => Multiplexor()
    ),
    GetPage(
      name: SignIn.route,
      page: () => SignIn(),
      binding: WayagramBinding(),
    ),
    GetPage(
      name: SignUp.route,
      page: () => SignUp(),
      binding: WayagramBinding(),
    ),
    GetPage(
      name: VerifyOTP.route,
      page: () => VerifyOTP(),
      binding: WayagramBinding(),
    ),
    GetPage(
        name: CreatePIN.route,
        page: () => CreatePIN()
    ),
    GetPage(
        name: UpdateProfile.route,
        page: () => UpdateProfile()
    ),

    GetPage(
        name: CreatePIN.route,
        page: () => CreatePIN()
    ),
    GetPage(
        name: ConfirmPIN.route,
        page: () => ConfirmPIN()
    ),
    GetPage(
        name: Interests.route,
        page: () => Interests()
    ),

    GetPage(
      name: Home.route,
      page: () => Home(),
      binding: WayagramBinding(),
    ),

    GetPage(
      name: Profile.route,
      page: () => Profile(),
      binding: WayagramBinding(),
    ),

    GetPage(
      name: GroupsAndPages.route,
      page: () => GroupsAndPages(),
      binding: WayagramBinding(),
    ),

    GetPage(
      name: Settings.route,
      page: () => Settings(),
      binding: WayagramBinding(),
    ),

    GetPage(
      name: Search.route,
      page: () => Search(),
      binding: WayagramBinding(),
    ),

    GetPage(
      name: Contact.route,
      page: () => Contact(),
      binding: WayagramBinding(),
    ),
  ];
}
