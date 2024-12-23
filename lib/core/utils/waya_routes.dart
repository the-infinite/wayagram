import 'package:get/route_manager.dart';
import 'package:wayagram/features/account_creation/view/account_creation.dart';
import 'package:wayagram/features/onboarding/views/onboarding_view.dart';
import 'package:wayagram/features/onboarding/views/splash_screen.dart';

class WayaAppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const accountCreation = '/account-creation';


  static final routes = [
    GetPage(
        name: splash,
        page: () => SplashScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: onboarding,
        page: () => OnboardingView(),
        transition: Transition.cupertino),
    GetPage(
        name: accountCreation,
        page: () => AccountCreation(),
        transition: Transition.cupertino),
    
  ];
}
