import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/core/components/waya_webview.dart';
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
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/add_evidence.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/dispute_chat/dispute_chat.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/seller_dispute.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/seller_dispute_detail.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/application_product_details.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/product_listing/product_listing.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_deal_ad.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_gram_deals.dart';
import 'package:wayagram/features/wallet/transactions/view/all_transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_details.dart';
import 'package:wayagram/features/wallet/transactions/view/verify_transaction.dart';
import 'package:wayagram/features/wallet/view/bank_transfer_screen.dart';
import 'package:wayagram/features/wallet/view/fund_account_screen.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:wayagram/features/ugt/create_contest/create_contest.dart';
import 'package:wayagram/features/ugt/ugt_get_started.dart';
import 'package:wayagram/features/ugt/ugt_home.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_page.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';

class WayaAppRoutes {
  static final routes = <String, Widget Function()>{
    '/': () => SplashScreen(),
    LoginCoverPage.route: () => LoginCoverPage(),
    OnboardingView.route: () => OnboardingView(),
    AccountCreation.route: () => AccountCreation(),
    ChangedPasswordSuccess.route: () => ChangedPasswordSuccess(),
    SetNotification.route: () => SetNotification(),
    SuccessfulSetup.route: () => SuccessfulSetup(),
    ForgotPasswordStep.route: () => ForgotPasswordStep(),
    TransactionPinView.route: () => TransactionPinView(),
    SelectInterest.route: () => SelectInterest(),
    AddBusinessAccountView.route: () => AddBusinessAccountView(),
    LoginPage.route: () => LoginPage(),
    WelcomeBackPage.route: () => WelcomeBackPage(),
    BottomView.route: () => BottomView(),
    ProductDetail.route: () => ProductDetail(),
    OrderDetails.route: () => OrderDetails(),
    ConfirmOrderDelivery.route: () => ConfirmOrderDelivery(),
    CartView.route: () => CartView(),
    AllSellerOrders.route: () => AllSellerOrders(),
    SellerOrderDetails.route: () => SellerOrderDetails(),
    Checkout.route: () => Checkout(),
    FilterView.route: () => FilterView(),
    GeneralSettingsPage.route: () => GeneralSettingsPage(),
    ChangePasswordGenSettings.route: () => ChangePasswordGenSettings(),
    ChangePinPage.route: () => ChangePinPage(),
    WayaWebview.route: () => WayaWebview(),
    FundWalletOptionsScreen.route: () => FundWalletOptionsScreen(),
    WalletPage.route: () => WalletPage(),
    FundAccountScreen.route: () => FundAccountScreen(),
    TransactionDetailsScreen.route: () => TransactionDetailsScreen(),
    VerifyTransactionScreen.route: () => VerifyTransactionScreen(),
    AllTransactionHistory.route: () => AllTransactionHistory(),
    BankTransferScreen.route: () => BankTransferScreen(),
    ProfilePage.route: () => ProfilePage(),
    EditNamePage.route: () => EditNamePage(),
    EditProfilePage.route: () => EditProfilePage(),
    AddProduct.route: () => AddProduct(),
    ProductListing.route: () => ProductListing(),
    WayaDealAd.route: () => WayaDealAd(),
    WayaGramDeals.route: () => WayaGramDeals(),
    ApplicationProductDetails.route: () => ApplicationProductDetails(),
    CreateShop.route: () => CreateShop(),
    SellerDispute.route: () => SellerDispute(),
    SellerDisputeDetail.route: () => SellerDisputeDetail(),
    AddEvidence.route: () => AddEvidence(),
    DisputeChat.route: () => DisputeChat(),
    UgtGetStarted.route: () => UgtGetStarted(),
    UgtHome.route: () => UgtHome(),
    CreateContest.route: () => CreateContest()
  };

  static List<GetPage> get getPages => routes.entries.map((entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      }).toList();
}
