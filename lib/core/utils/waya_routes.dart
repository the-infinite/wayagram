import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/features/auth/account_creation/view/account_creation.dart';
import 'package:wayagram/features/auth/account_creation/view/explore.dart';
import 'package:wayagram/features/auth/account_creation/view/set_notification.dart';
import 'package:wayagram/features/auth/forgot_password/view/changed_password_success.dart';
import 'package:wayagram/features/auth/forgot_password/view/forgot_password_step.dart';
import 'package:wayagram/features/auth/login/view/login_cover_page.dart';
import 'package:wayagram/features/auth/login/view/login_page.dart';
import 'package:wayagram/features/auth/login/view/welcome_back.dart';
import 'package:wayagram/features/onboarding/views/onboarding_view.dart';

class WayaAppRoutes {
  static final routes = <String, Widget Function()>{
    '/': () => LoginCoverPage(),
    // '/': () => SplashScreen(),
    '/onboarding': () => OnboardingView(),
    '/account-creation': () => AccountCreation(),
    '/changed-password-success': () => ChangedPasswordSuccess(),
    '/set-notification': () => SetNotification(),
    '/account-setup-success': () => Explore(),
    '/forgot-password': () => ForgotPasswordStep(),
    '/login': () => LoginPage(),
    '/welcome-back': () => WelcomeBackPage(),
  };

  static List<GetPage> get getPages => routes.entries.map((entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      }).toList();
}
