import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/features/auth/account_creation/view/account_creation.dart';
import 'package:wayagram/features/auth/account_creation/view/successful_setup.dart';
import 'package:wayagram/features/auth/account_creation/view/set_notification.dart';
import 'package:wayagram/features/auth/add_business_account/views/add_business_account_view.dart';
import 'package:wayagram/features/auth/forgot_password/view/changed_password_success.dart';
import 'package:wayagram/features/auth/forgot_password/view/forgot_password_step.dart';
import 'package:wayagram/features/auth/interests/views/select_interest.dart';
import 'package:wayagram/features/auth/transaction_pin/views/transaction_pin_view.dart';
import 'package:wayagram/features/auth/login/view/login_cover_page.dart';
import 'package:wayagram/features/auth/login/view/login_page.dart';
import 'package:wayagram/features/auth/login/view/welcome_back.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/explore/views/explore.dart';
import 'package:wayagram/features/onboarding/views/onboarding_view.dart';
import 'package:wayagram/features/onboarding/views/splash_screen.dart';
import 'package:wayagram/features/shop/views/product_detail.dart';

class WayaAppRoutes {
  static final routes = <String, Widget Function()>{
    '/': () => SplashScreen(),
    '/login-cover-page': () => LoginCoverPage(),
    '/onboarding': () => OnboardingView(),
    '/account-creation': () => AccountCreation(),
    '/changed-password-success': () => ChangedPasswordSuccess(),
    '/set-notification': () => SetNotification(),
    '/account-setup-success': () => SuccessfulSetup(),
    '/forgot-password': () => ForgotPasswordStep(),
    '/setup-pin': () => TransactionPinView(),
    '/select-interests': () => SelectInterest(),
    '/add-business-account': () => AddBusinessAccountView(),
    '/login': () => LoginPage(),
    '/welcome-back': () => WelcomeBackPage(),
    '/explore': () => BottomView(),
    '/product-detail': () => ProductDetail()
  };

  static List<GetPage> get getPages => routes.entries.map((entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      }).toList();
}
