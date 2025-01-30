import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/core/components/waya_webview.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/view/chat.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/view/change_password_gen_set.dart';
import 'package:wayagram/features/general_settings/change_pin/change_pin_page.dart';
import 'package:wayagram/features/general_settings/notifications/view/default.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/general_settings/profile/view/profile_page.dart';
import 'package:wayagram/features/group/view/confirm_group_details.dart';
import 'package:wayagram/features/group/view/create_group.dart';
import 'package:wayagram/features/group/view/group_public.dart';
import 'package:wayagram/features/group/view/members_screen.dart';
import 'package:wayagram/features/group/view/success_group.dart';
import 'package:wayagram/features/notifications/views/default.dart';
import 'package:wayagram/features/pages/view/create_post.dart';
import 'package:wayagram/features/pages/view/mutual_page.dart';
import 'package:wayagram/features/pages/view/private_page.dart';
import 'package:wayagram/features/polls_and_voting/views/add_choices.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_dashboard.dart';
import 'package:wayagram/features/polls_and_voting/views/create_poll.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_summary.dart';
import 'package:wayagram/features/polls_and_voting/views/polls_and_votes.dart';
import 'package:wayagram/features/polls_and_voting/views/share_voting_link.dart';
import 'package:wayagram/features/quotation/buyer/views/bid/see_buyer_bids.dart';
import 'package:wayagram/features/quotation/buyer/views/buyer_checkout.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/create_request.dart';
import 'package:wayagram/features/quotation/seller/views/bids/all_seller_bids.dart';
import 'package:wayagram/features/quotation/seller/views/bids/map_screen.dart';
import 'package:wayagram/features/quotation/seller/views/bids/see_seller_bids.dart';
import 'package:wayagram/features/quotation/seller/views/bids/seller_bid_details.dart';
import 'package:wayagram/features/quotation/seller/views/bids/seller_settlement.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/create_shop.dart';
import 'package:wayagram/features/shop/seller/views/delivery_request/delivery_request.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/views/orders/all_seller_orders.dart';
import 'package:wayagram/features/shop/seller/views/orders/seller_order_details.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/add_evidence.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/dispute_chat/dispute_chat.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/seller_dispute.dart';
import 'package:wayagram/features/shop/seller/views/seller_dispute/views/seller_dispute_detail.dart';
import 'package:wayagram/features/shop/seller/views/seller_products.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/application_product_details.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/product_listing/product_listing.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_deal_ad.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_gram_deals.dart';
import 'package:wayagram/features/shop/views/products_view_page.dart';
import 'package:wayagram/features/ugt/contest_setting/contest_setting_content.dart';
import 'package:wayagram/features/ugt/create_contest/steps/edit_stage_preference.dart';
import 'package:wayagram/features/ugt/my_contest_details/create_profile.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/wallet/transactions/view/all_transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_details.dart';
import 'package:wayagram/features/wallet/transactions/view/verify_transaction.dart';
import 'package:wayagram/features/wallet/view/bank_transfer_screen.dart';
import 'package:wayagram/features/wallet/view/fund_account_screen.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:wayagram/features/ugt/create_contest/create_contest.dart';
import 'package:wayagram/features/ugt/ugt_get_started.dart';
import 'package:wayagram/features/ugt/ugt_home.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';
import 'package:wayagram/features/ugt/my_contest_details/register_contest.dart';

import '../../features/pages/view/confirm_page_details.dart';
import '../../features/pages/view/create_page.dart';
import '../../features/pages/view/pages.dart';
import '../../features/pages/view/success_page.dart';
import '../../features/pages/view/suggestion.dart';

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
    SellerBidDetails.route: () => SellerBidDetails(),
    SellerSettlement.route: () => SellerSettlement(),
    SeeSellerBids.route: () => SeeSellerBids(),
    SeeBuyerBids.route: () => SeeBuyerBids(),
    Checkout.route: () => Checkout(),
    BuyerCheckout.route: () => BuyerCheckout(),
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
    MapScreen.route: () => MapScreen(),
    AddEvidence.route: () => AddEvidence(),
    DisputeChat.route: () => DisputeChat(),
    UgtGetStarted.route: () => UgtGetStarted(),
    UgtHome.route: () => UgtHome(),
    CreateContest.route: () => CreateContest(),
    ContestSettingContent.route: () => ContestSettingContent(),
    EditStagePreference.route: () => EditStagePreference(),
    CreateRequest.route: () => CreateRequest(),
    AllSellerBids.route: () => AllSellerBids(),
    ManageShop.route: () => ManageShop(),
    UpgradeToBusiness.route: () => UpgradeToBusiness(),
    CreatePoll.route: () => CreatePoll(),
    PollAndVoting.route: () => PollAndVoting(),
    AddChoices.route: () => AddChoices(),
    PollSummary.route: () => PollSummary(),
    PollDashboard.route: () => PollDashboard(),
    UpcomingContestDetails.route: () => UpcomingContestDetails(),
    CreateProfile.route: () => CreateProfile(),
    RegisterContest.route: () => RegisterContest(),
    ShareVotingLink.route: () => ShareVotingLink(),
    DeliveryRequest.route: () => DeliveryRequest(),
    SellerProducts.route: () => SellerProducts(),
    ProductsViewPage.route: () => ProductsViewPage(),
    WayaNotifications.route: () => WayaNotifications(),
    NotificationSettingsScreen.route: () => NotificationSettingsScreen(),
    CreatePage.route: () => CreatePage(),
    CreateGroup.route: () => CreateGroup(),
    ConfirmPageDetails.route: () => ConfirmPageDetails(),
    ConfirmGroupDetails.route: () => ConfirmGroupDetails(),
    SuccessPage.route: () => SuccessPage(),
    SuccessGroup.route: () => SuccessGroup(),
    Pages.route: ()=> Pages(),
    Suggestion.route: ()=> Suggestion(),
    PrivatePage.route:()=> PrivatePage(),
    GroupPublic.route: ()=> GroupPublic(),
    MembersScreen.route:()=> MembersScreen(),
    CreatePost.route: ()=> CreatePost(),
    MutualPage.route: ()=> MutualPage(),

  };

  /// Helper that shows an example of the generator route pattern with GetX and
  /// a little bit of hard coded magic.
  static String getSingleChatRoute(String id) => "${SingleChatScreen.route}?id=$id";

  /// This is fine.
  static List<GetPage> get getPages => routes.entries.map((entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      }).toList();
}
