import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/view/change_password_gen_set.dart';
import 'package:wayagram/features/general_settings/change_pin/change_pin_page.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/general_settings/profile/view/profile_page.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/create_shop.dart';
import 'package:wayagram/features/shop/seller/views/orders/all_seller_orders.dart';
import 'package:wayagram/features/shop/seller/views/orders/seller_order_details.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/application_product_details.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/product_listing/product_listing.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_deal_ad.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_gram_deals.dart';
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
    LoginPage.route: () => LoginPage(),
    '/welcome-back': () => WelcomeBackPage(),
    BottomView.route: () => BottomView(),
    '/product-detail': () => ProductDetail(),
    '/order-detail': () => OrderDetails(),
    '/confirm-order-delivery': () => ConfirmOrderDelivery(),
    '/cart': () => CartView(),
    '/seller-orders': () => AllSellerOrders(),
    '/seller-order-details': () => SellerOrderDetails(),
    '/checkout': () => Checkout(),
    '/filter': () => FilterView(),
    GeneralSettingsPage.route: () => GeneralSettingsPage(),
    '/change-password-gen-set': () => ChangePasswordGenSettings(),
    '/change-pin-page': () => ChangePinPage(),
    '/fund-wallet-page': () => FundWalletPage(),
    WalletPage.route: () => WalletPage(),
    ProfilePage.route: () => ProfilePage(),
    EditNamePage.route: () => EditNamePage(),
    EditProfilePage.route: () => EditProfilePage(),
    '/add-product': () => AddProduct(),
    '/waya_product_listing': () => ProductListing(),
    '/waya-deal-ad': () => WayaDealAd(),
    '/wayagram-deal': () => WayaGramDeals(),
    '/waya-application-product-detail': () => ApplicationProductDetails(),
    CreateShop.route: () => CreateShop(),
  };

  static List<GetPage> get getPages => routes.entries.map((entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      }).toList();
}
