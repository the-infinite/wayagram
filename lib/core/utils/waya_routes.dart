import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/view/change_password_gen_set/change_password_gen_set.dart';
import 'package:wayagram/features/general_settings/view/change_pin/change_pin_page.dart';

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
    '/product-detail': () => ProductDetail(),
    '/order-detail': () => OrderDetails(),
    '/confirm-order-delivery': () => ConfirmOrderDelivery(),
    '/cart': () => CartView(),
    '/checkout': () => Checkout(),
    '/filter': () => FilterView(),
    '/general-settings': () => GeneralSettingsPage(),
    '/change-password-gen-set': () => ChangePasswordGenSettings(),
    '/change-pin-page': () => ChangePinPage(),
  };

  static List<GetPage> get getPages => routes.entries.map((entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      }).toList();
}
