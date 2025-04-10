import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/core/components/waya_webview.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/view/activity_log.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/auth/verify_email/verify_email.dart';
import 'package:wayagram/features/buyer_dispute/views/detail.dart';
import 'package:wayagram/features/chat/view/archived.dart';
import 'package:wayagram/features/chat/view/profile.dart';
import 'package:wayagram/features/donation/view/create_donation.dart';
import 'package:wayagram/features/donation/view/donation_details.dart';
import 'package:wayagram/features/donation/view/donation_management.dart';
import 'package:wayagram/features/donation/view/donations.dart';
import 'package:wayagram/features/donation/view/see_all_approved_donation.dart';
import 'package:wayagram/features/donation/view/see_all_pending_donation.dart';
import 'package:wayagram/features/donation/view/see_all_rejected_donation.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:wayagram/features/event/views/event_detail/event_detail.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/chat/view/chat.dart';
import 'package:wayagram/features/explore/views/chat_and_social.dart';
import 'package:wayagram/features/explore/views/display_feed.dart';
import 'package:wayagram/features/follow/view/follow_page.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/view/change_password_gen_set.dart';
import 'package:wayagram/features/general_settings/change_pin/change_pin_page.dart';
import 'package:wayagram/features/general_settings/notifications/view/default.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/general_settings/profile/view/profile_page.dart';
import 'package:wayagram/features/general_settings/reset_pin_page/reset_pin.dart';
import 'package:wayagram/features/general_settings/reset_pin_page/verify_your_identity_page.dart';
import 'package:wayagram/features/group/view/add_group_member.dart';
import 'package:wayagram/features/group/view/confirm_group_details.dart';
import 'package:wayagram/features/group/view/create_group.dart';
import 'package:wayagram/features/group/view/create_group_post.dart';
import 'package:wayagram/features/group/view/group_setting.dart';
import 'package:wayagram/features/group/view/group_suggestion.dart';
import 'package:wayagram/features/group/view/groups.dart';
import 'package:wayagram/features/group/view/members_screen.dart';
import 'package:wayagram/features/group/view/public_group.dart';
import 'package:wayagram/features/group/view/success_group.dart';
import 'package:wayagram/features/group/view/view_full_media.dart';
import 'package:wayagram/features/kyc/view/kyc_update.dart';
import 'package:wayagram/features/moments/views/media_moment.dart';
import 'package:wayagram/features/moments/views/moment.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:wayagram/features/moments/views/trim_video.dart';
import 'package:wayagram/features/notifications/views/default.dart';
import 'package:wayagram/features/pages/view/add_team_member.dart';
import 'package:wayagram/features/pages/view/confirm_page_details.dart';
import 'package:wayagram/features/pages/view/create_page.dart';
import 'package:wayagram/features/pages/view/create_page_post.dart';
import 'package:wayagram/features/pages/view/pages.dart';
import 'package:wayagram/features/pages/view/public_page.dart';
import 'package:wayagram/features/pages/view/success_page.dart';
import 'package:wayagram/features/pages/view/suggestion.dart';
import 'package:wayagram/features/post/view/create_post.dart';
import 'package:wayagram/features/follow/view/mutual_page.dart';
import 'package:wayagram/features/polls_and_voting/views/add_choices.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_dashboard.dart';
import 'package:wayagram/features/polls_and_voting/views/create_poll.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_summary.dart';
import 'package:wayagram/features/polls_and_voting/views/polls_and_votes.dart';
import 'package:wayagram/features/polls_and_voting/views/share_voting_link.dart';
import 'package:wayagram/features/post/view/edit_post.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/features/promotion/views/promotion_dashboard.dart';
import 'package:wayagram/features/promotion/views/promotion_detail.dart';
import 'package:wayagram/features/quotation/buyer/views/bid/see_buyer_bids.dart';
import 'package:wayagram/features/quotation/buyer/views/buyer_checkout.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/create_request.dart';
import 'package:wayagram/features/quotation/seller/views/bids/all_seller_bids.dart';
import 'package:wayagram/features/quotation/seller/views/bids/map_screen.dart';
import 'package:wayagram/features/quotation/seller/views/bids/see_seller_bids.dart';
import 'package:wayagram/features/quotation/seller/views/bids/seller_bid_details.dart';
import 'package:wayagram/features/quotation/seller/views/bids/seller_settlement.dart';
import 'package:wayagram/features/quotation/seller/views/orders.dart';
import 'package:wayagram/features/referral/view/referral_history_page.dart';
import 'package:wayagram/features/referral/view/referral_page.dart';
import 'package:wayagram/features/role_access/view/add_team_member_page.dart';
import 'package:wayagram/features/role_access/view/member_details_page.dart';
import 'package:wayagram/features/role_access/view/role_access_page.dart';
import 'package:wayagram/features/shop/filter/views/product_search_result.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/create_shop.dart';
import 'package:wayagram/features/shop/seller/views/delivery_request/delivery_request.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/views/orders/all_seller_orders.dart';
import 'package:wayagram/features/shop/seller/views/orders/seller_order_details.dart';
import 'package:wayagram/features/shop/shop_dispute/views/add_evidence.dart';
import 'package:wayagram/features/shop/shop_dispute/views/dispute_chat/dispute_chat.dart';
import 'package:wayagram/features/shop/shop_dispute/views/init_dispute.dart';
import 'package:wayagram/features/shop/shop_dispute/views/seller_dispute.dart';
import 'package:wayagram/features/shop/shop_dispute/views/seller_dispute_detail.dart';
import 'package:wayagram/features/shop/seller/views/seller_products.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/application_product_details.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/product_listing/product_listing.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_deal_ad.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_gram_deals.dart';
import 'package:wayagram/features/shop/views/products_view_page.dart';
import 'package:wayagram/features/support/views/chat.dart';
import 'package:wayagram/features/support/views/dispute.dart';
import 'package:wayagram/features/support/views/request.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/admin_transaction_history.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/contest_active_disqualify.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/manage_application_contest.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/manage_leaderboard_contest.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/manage_state_single_contest.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/view_single_contestant_data.dart';
import 'package:wayagram/features/ugt/contest_profiles/contest_profile_page.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/contest_dashboard.dart';
import 'package:wayagram/features/ugt/contest_setting/contest_setting_content.dart';
import 'package:wayagram/features/ugt/create_contest/steps/edit_stage_preference.dart';
import 'package:wayagram/features/ugt/create_contest_post/create_contest_post.dart';
import 'package:wayagram/features/ugt/my_contest_details/create_profile.dart';
import 'package:wayagram/features/ugt/my_contest_details/admin_contest_details.dart';
import 'package:wayagram/features/ugt/my_contest_details/edit_contestant_profile.dart';
import 'package:wayagram/features/ugt/my_contest_details/full_media_view.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/my_contest_details/voters_list_page.dart';
import 'package:wayagram/features/wallet/transactions/view/all_transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_details.dart';
import 'package:wayagram/features/wallet/transactions/view/verify_transaction.dart';
import 'package:wayagram/features/wallet/view/add_payout_method_screen.dart';
import 'package:wayagram/features/wallet/view/bank_transfer_screen.dart';
import 'package:wayagram/features/wallet/view/enter_request_amount_screen.dart';
import 'package:wayagram/features/wallet/view/fund_account_screen.dart';
import 'package:wayagram/features/wallet/view/fund_wallet_options_screen.dart';
import 'package:wayagram/features/ugt/create_contest/create_contest.dart';
import 'package:wayagram/features/ugt/ugt_get_started.dart';
import 'package:wayagram/features/ugt/ugt_home.dart';
import 'package:wayagram/features/wallet/view/payout_details.dart';
import 'package:wayagram/features/wallet/view/payout_success_screen.dart';
import 'package:wayagram/features/wallet/view/request_payout.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';
import 'package:wayagram/features/ugt/my_contest_details/register_contest.dart';
import 'package:wayagram/features/event/views/all_upcoming_events.dart';
import 'package:wayagram/features/explore/search/search.dart';
import 'package:wayagram/shared/features/quotation/view/all_buy_request.dart';

import '../../features/activity_logs/view/cms_clicks.dart';
import '../../features/activity_logs/view/account_activity.dart';
import '../../features/activity_logs/view/logs_and_audit.dart';
import '../../features/activity_logs/view/payment_activity.dart';
import '../../features/activity_logs/view/search_log.dart';
import '../../features/activity_logs/view/user_action.dart';
import '../../features/activity_logs/view/user_interaction.dart';
import '../../features/activity_logs/view/visited_page.dart';

class WayaAppRoutes {
  WayaAppRoutes._();
  static final routes = <String, Widget Function()>{
    '/': () => SplashScreen(),
    LoginCoverPage.route: () => LoginCoverPage(),
    OnboardingView.route: () => OnboardingView(),
    AccountCreation.route: () =>
        AccountCreation(referral: WayaNav.search['referral'].toString()),
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
    ProductDetail.route: () =>
        ProductDetail(id: WayaNav.search['id'].toString()),
    OrderDetails.route: () => OrderDetails(),
    ConfirmOrderDelivery.route: () => ConfirmOrderDelivery(),
    CartView.route: () => CartView(),
    AllSellerOrders.route: () => AllSellerOrders(),
    SellerOrderDetails.route: () => SellerOrderDetails(),
    SellerBidDetails.route: () => SellerBidDetails(
          id: WayaNav.search['id'].toString(),
          requestId: WayaNav.search['requestId'].toString(),
        ),
    SellerSettlement.route: () => SellerSettlement(),
    SeeSellerBids.route: () =>
        SeeSellerBids(id: WayaNav.search['id'].toString()),
    SeeBuyerBids.route: () => SeeBuyerBids(id: WayaNav.search['id'].toString()),
    Checkout.route: () => Checkout(),
    BuyerCheckout.route: () => BuyerCheckout(),
    FilterView.route: () => FilterView(),
    GeneralSettingsPage.route: () => GeneralSettingsPage(),
    ChangePasswordGenSettings.route: () => ChangePasswordGenSettings(),
    ChangePinPage.route: () => ChangePinPage(),
    ResetPinPage.route: () => ResetPinPage(),
    VerifyYourIdentityPage.route: () => VerifyYourIdentityPage(),
    WayaWebview.route: () => WayaWebview(),
    FundWalletOptionsScreen.route: () => FundWalletOptionsScreen(),
    WalletPage.route: () => WalletPage(),
    FundAccountScreen.route: () => FundAccountScreen(),
    TransactionDetailsScreen.route: () => TransactionDetailsScreen(),
    VerifyTransactionScreen.route: () => VerifyTransactionScreen(),
    AllTransactionHistory.route: () => AllTransactionHistory(),
    BankTransferScreen.route: () => BankTransferScreen(),
    ProfilePage.route: () => ProfilePage(
          id: WayaNav.search['id'].toString(),
          source: WayaNav.search['source'].toString(),
        ),
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
    DisputeChat.route: () => DisputeChat(id: WayaNav.search['id'].toString()),
    UgtGetStarted.route: () => UgtGetStarted(),
    UgtHome.route: () => UgtHome(),
    CreateContest.route: () => CreateContest(),
    CreateContestPost.route: () => CreateContestPost(),
    EditContestantProfile.route: () => EditContestantProfile(),
    ViewSingleContestantData.route: () => ViewSingleContestantData(),
    ContestActiveDisqualify.route: () => ContestActiveDisqualify(),
    ContestProfilePage.route: () => ContestProfilePage(
          id: WayaNav.search['id'].toString(),
          contest: WayaNav.search['contest'].toString(),
        ),
    ManageApplicationContest.route: () => ManageApplicationContest(),
    ManageStateSingleContest.route: () => ManageStateSingleContest(),
    DashboardContestPage.route: () => DashboardContestPage(),
    ManageLeaderboardContest.route: () => ManageLeaderboardContest(),
    AdminTransactionHistory.route: () => AdminTransactionHistory(),
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
    VotersListPage.route: () => VotersListPage(),
    AdminContestDetails.route: () => AdminContestDetails(
          id: WayaNav.search['id'].toString(),
        ),
    ShareVotingLink.route: () => ShareVotingLink(),
    DeliveryRequest.route: () => DeliveryRequest(),
    SellerProducts.route: () => SellerProducts(),
    ProductsViewPage.route: () => ProductsViewPage(),
    WayaNotifications.route: () => WayaNotifications(),
    NotificationSettingsScreen.route: () => NotificationSettingsScreen(),
    Moment.route: () => Moment(),
    EventView.route: () => EventView(),
    AddEvent.route: () => AddEvent(),
    EventDetail.route: () => EventDetail(
          id: WayaNav.search['id'].toString(),
        ),
    CreatePage.route: () => CreatePage(),
    CreateGroup.route: () => CreateGroup(),
    ConfirmPageDetails.route: () => ConfirmPageDetails(),
    ConfirmGroupDetails.route: () => ConfirmGroupDetails(),
    SuccessPage.route: () => SuccessPage(),
    SuccessGroup.route: () => SuccessGroup(),
    Pages.route: () => Pages(),
    Groups.route: () => Groups(),
    Suggestion.route: () => Suggestion(),
    GroupSuggestion.route: () => GroupSuggestion(),
    Promote.route: () => Promote(),
    PromotionDashboard.route: () => PromotionDashboard(),
    PromotionDetail.route: () => PromotionDetail(),
    PublicPage.route: () => PublicPage(
          id: WayaNav.search['id'].toString(),
        ),
    MembersScreen.route: () => MembersScreen(
          id: WayaNav.search['id'].toString(),
        ),
    CreatePost.route: () => CreatePost(),
    CreateGroupPost.route: () => CreateGroupPost(
          id: WayaNav.search['id'].toString(),
        ),
    CreatePagePost.route: () => CreatePagePost(
          id: WayaNav.search['id'].toString(),
        ),
    MutualPage.route: () => MutualPage(
          initialTab: WayaNav.search['tab'] ?? 'followers',
          userId: WayaNav.search['uid'].toString(),
          source: WayaNav.search['source'] ?? 'any',
        ),
    FollowRelationshipsPage.route: () => FollowRelationshipsPage(),
    PublicGroup.route: () => PublicGroup(
          id: WayaNav.search['id'].toString(),
        ),
    AddTeamMember.route: () => AddTeamMember(
          id: WayaNav.search['id'].toString(),
        ),
    SingleChatScreen.route: () =>
        SingleChatScreen(chatId: WayaNav.search['id'].toString()),
    ChatProfilePage.route: () =>
        ChatProfilePage(chatId: WayaNav.search['id'].toString()),
    DisplayFeed.route: () => DisplayFeed(),
    GroupSetting.route: () => GroupSetting(),
    AllUpcomingEvents.route: () => AllUpcomingEvents(),
    MediaMoment.route: () => MediaMoment(),
    MyMoments.route: () => MyMoments(),
    CandidatePostScreen.route: () => CandidatePostScreen(),
    VideoTrimmerScreen.route: () => VideoTrimmerScreen(),
    ViewFullMedia.route: () => ViewFullMedia(),
    EditPost.route: () => EditPost(
          initialContent: '',
          initialImageUrl: '',
          title: '',
          postId: '',
        ),
    AddGroupMember.route: () => AddGroupMember(
          id: WayaNav.search['id'].toString(),
        ),
    SearchView.route: () => SearchView(),
    ArchivedChatsScreen.route: () => ArchivedChatsScreen(),
    Donations.route: () => Donations(),
    DonationDetails.route: () => DonationDetails(),
    CreateDonation.route: () => CreateDonation(),
    DonationManagement.route: () => DonationManagement(),
    SeeAllDonations.route: () => SeeAllDonations(),
    SeeAllRejectedDonations.route: () => SeeAllRejectedDonations(),
    SeeAllApprovedDonations.route: () => SeeAllApprovedDonations(),
    ChatAndSocial.route: () => ChatAndSocial(),
    SupportRequestScreen.route: () => SupportRequestScreen(),
    SupportDisputeScreen.route: () => SupportDisputeScreen(),
    SupportChatScreen.route: () => SupportChatScreen(),
    InitDispute.route: () => InitDispute(),
    DisputeDetail.route: () =>
        DisputeDetail(id: WayaNav.search['id'].toString()),
    ProductSearchResult.route: () => ProductSearchResult(),
    LogsAndAuditTrials.route: () => LogsAndAuditTrials(),
    AccountActivity.route: () => AccountActivity(),
    ActivityLog.route: () => ActivityLog(),
    QuotationSellerOrders.route: () => QuotationSellerOrders(),
    VisitedPage.route: () => VisitedPage(),
    UserAction.route: () => UserAction(),
    CmsClicks.route: () => CmsClicks(),
    UserInteraction.route: () => UserInteraction(),
    PaymentActivity.route: () => PaymentActivity(),
    SearchLog.route: () => SearchLog(),
    KycUpdate.route: () => KycUpdate(),
    SellerBuyRequestsScreen.route: () => SellerBuyRequestsScreen(),
    BuyerBuyRequestsScreen.route: () => BuyerBuyRequestsScreen(),
    RoleAccessPage.route: () => RoleAccessPage(),
    AddTeamMemberPage.route: () => AddTeamMemberPage(),
    MemberDetailsPage.route: () => MemberDetailsPage(),
    VerifyEmail.route: () => VerifyEmail(),
    ReferralPage.route: () => ReferralPage(),
    ReferralHistoryPage.route: () => ReferralHistoryPage(),
    RequestPayout.route: () => RequestPayout(),
    AddPayoutMethodScreen.route: () => AddPayoutMethodScreen(),
    PayoutDetails.route: () => PayoutDetails(),
    PayoutSuccessScreen.route: () => PayoutSuccessScreen(),
    EnterRequestAmountScreen.route: () => EnterRequestAmountScreen(),
  };

  /// Helper that shows an example of the generator route pattern with GetX and
  /// a little bit of hard coded magic.
  static String getSingleChatRoute(String id) =>
      "${SingleChatScreen.route}?id=$id";

  /// Helper that shows an example of the generator route pattern with GetX and
  /// a little bit of hard coded magic.
  static String getProfileRoute(String id, [String source = 'any']) =>
      "${ProfilePage.route}?id=$id&source=$source";

  /// Helper function that is used to get the route to the details of a single
  /// dispute by its ID.
  static String getDisputeDetailsRoute(String id) =>
      "${DisputeDetail.route}?id=$id";

  /// Helper function that is used to get the route to the chat of a single
  /// dispute by its ID.
  static String getDisputeChatsRoute(String id) =>
      "${DisputeChat.route}?id=$id";

  /// Helper function that is used to navigate to the route that contains all
  /// the bids of sellers
  static String getBuyerBidsRoute(String id) => "${SeeBuyerBids.route}?id=$id";

  /// Helper function that is used to navigate to the route that contains all
  /// the bids of sellers
  static String getSellerBidsRoute(String id) =>
      "${SeeSellerBids.route}?id=$id";

  /// Helper function used to generate the route that is supposed to navigate to
  /// all the followers, followings, and mutuals that one user has with another
  /// one.
  static String getFollowersPage(String uid,
          [String tab = 'followers', String source = 'any']) =>
      "${MutualPage.route}?tab=$tab&source=$source&uid=$uid";

  /// Helper function used to generate the route that is supposed to take you a
  /// single page by its ID.
  static String getPageDetailsPage(String id) => "${PublicPage.route}?id=$id";

  /// Helper function used to generate the route that is supposed to take you a
  /// single group by its ID.
  static String getGroupDetailsPage(String id) => "${PublicGroup.route}?id=$id";

  /// Helper function used to generate the route that is supposed to take you a
  /// single group's members by its ID.
  static String getGroupMembersPage(String id) =>
      "${MembersScreen.route}?id=$id";

  /// Helper function used to generate the route that is supposed to take you a
  /// single group's screen for adding new members by its ID.
  static String getAddGroupMemberPage(String id) =>
      "${AddGroupMember.route}?id=$id";

  /// Helper function used to generate the route that is supposed to take you a
  /// single group's screen for adding new members by its ID.
  static String getAddPageTeamMemberPage(String id) =>
      "${AddTeamMember.route}?id=$id";

  /// Helper function used to generate the route that is supposed ot navigate to
  /// the chat profile of any given user.
  static String getChatProfile(String id) => "${ChatProfilePage.route}?id=$id";

  /// Helper function used to generate the route that is supposed ot navigate to
  /// the screen for making a new post for a page.
  static String getPagePostScreen(String id) =>
      "${CreatePagePost.route}?id=$id";

  /// Helper function used to generate the route that is supposed ot navigate to
  /// the screen for making a new post for a group.
  static String getGroupPostScreen(String id) =>
      "${CreateGroupPost.route}?id=$id";

  /// Helper function used to generate the route that takes a user to the screen
  /// for the details of a single event.
  static String getEventDetailsScreen(String id) =>
      "${EventDetail.route}?id=$id";

  /// Helper that shows an example of the generator route pattern with GetX and
  /// a little bit of hard coded magic.
  static String getContestDetailRoute(String id) =>
      "${AdminContestDetails.route}?id=$id";

  /// Helper that shows an example of the generator route pattern with GetX and
  /// a little bit of hard coded magic.
  static String getContestantProfileRoute(String id, String contestId) =>
      "${ContestProfilePage.route}?id=$id&contest=$contestId";

  /// Helper function used to generate the route that is supposed to take you a
  /// single poll by its ID.
  static String getPollDetailsPage(String id) =>
      "${PollAndVoting.route}?id=$id";

  /// Helper function used to generate the route that takes a user to the screen
  /// for the details of a single product.
  static String getProductDetailScreen(String id) =>
      "${ProductDetail.route}?id=$id";

  /// Helper function used to generate the route that takes a user to the screen
  /// for the details of a account.
  static String getAccountCreationScreen(String referral) =>
      "${AccountCreation.route}?referral=$referral";

  /// Helper function used to generate the route that is supposed to take you a
  /// single donation by its ID.
  static String getDonationDetailsPage(String id) =>
      "${Donations.route}?id=$id";

  /// Helper function used to generate the route that is supposed to take you a
  /// single
  static String getBidDetailsScreen(String id, String requestId) =>
      "${SellerBidDetails.route}?id=$id&requestId=$requestId";

  /// Helper function used to generate the route that is supposed to take you a
  /// single donation by its ID.
  static String getWalletDetailsPage(String id) =>
      "${Donations.route}?id=$id";

  /// This is fine.
  static List<GetPage> get getPages {
    return routes.entries.map(
      (entry) {
        return GetPage(
          name: entry.key,
          page: entry.value,
          transition: Transition.cupertino,
        );
      },
    ).toList();
  }
}
