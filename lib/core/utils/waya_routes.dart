import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/view/change_password_gen_set.dart';
import 'package:wayagram/features/general_settings/change_pin/change_pin_page.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/general_settings/profile/view/profile_page.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_page.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';

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
    '/fund-wallet-page': () => FundWalletPage(),
    WalletPage.route: () => WalletPage(),
    ProfilePage.route: () => ProfilePage(),
    EditNamePage.route: () => EditNamePage(),
    EditProfilePage.route: () => EditProfilePage()
  };

  static List<GetPage> get getPages => routes.entries.map((entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      }).toList();
}
