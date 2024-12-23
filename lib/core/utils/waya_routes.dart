import 'package:get/route_manager.dart';
import 'package:wayagram/features/auth/account_creation/view/account_creation.dart';
import 'package:wayagram/features/auth/account_creation/view/explore.dart';
import 'package:wayagram/features/auth/account_creation/view/set_notification.dart';
import 'package:wayagram/features/auth/forgot_password/view/changed_password_success.dart';
import 'package:wayagram/features/auth/forgot_password/view/forgot_password_step.dart';
import 'package:wayagram/features/onboarding/views/onboarding_view.dart';
import 'package:wayagram/features/onboarding/views/splash_screen.dart';

class WayaAppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const accountCreation = '/account-creation';
  static const changedPasswordSuccess = '/changed-password-success';
  static const setNotification = '/set-notification';
  static const accountSetUpSuccess = '/account-setup-success';
  static const forgotPassword = '/forgot-password';

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
    GetPage(
        name: changedPasswordSuccess,
        page: () => ChangedPasswordSuccess(),
        transition: Transition.cupertino),
    GetPage(
        name: setNotification,
        page: () => SetNotification(),
        transition: Transition.cupertino),
    GetPage(
        name: accountSetUpSuccess,
        page: () => Explore(),
        transition: Transition.cupertino),
        GetPage(
        name: forgotPassword,
        page: () => ForgotPasswordStep(),
        transition: Transition.cupertino),
  ];
}
