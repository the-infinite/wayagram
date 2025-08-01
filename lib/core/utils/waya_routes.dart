import 'package:flutter/material.dart';
import 'package:wayagram/core/components/waya_webview.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/view/activity_log.dart';
import 'package:wayagram/features/auth/account_creation/view/two_factor_auth.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/auth/verify_email/verify_email.dart';
import 'package:wayagram/features/buyer_dispute/views/detail.dart';
import 'package:wayagram/features/chat/view/archived.dart';
import 'package:wayagram/features/chat/view/profile.dart';
import 'package:wayagram/features/chat/view/profile/edit_group.dart';
import 'package:wayagram/features/donation/view/create_donation.dart';
import 'package:wayagram/features/donation/view/donation_details.dart';
import 'package:wayagram/features/donation/view/donation_dashboard.dart';
import 'package:wayagram/features/donation/view/donations.dart';
import 'package:wayagram/features/donation/view/see_all_approved_donation.dart';
import 'package:wayagram/features/donation/view/see_all_live_donation.dart';
import 'package:wayagram/features/donation/view/see_all_pending_donation.dart';
import 'package:wayagram/features/donation/view/see_all_rejected_donation.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:wayagram/features/event/views/event_detail/event_detail.dart';
import 'package:wayagram/features/event/views/event_invite.dart';
import 'package:wayagram/features/event/views/event_dashboard.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/chat/view/chat.dart';
import 'package:wayagram/features/explore/views/chat_and_social.dart';
import 'package:wayagram/features/explore/views/chat_notifications/chat.dart';
import 'package:wayagram/features/explore/views/display_feed.dart';
import 'package:wayagram/features/follow/view/follow_page.dart';
import 'package:wayagram/features/general_settings/account_security/account_security.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/view/change_password_gen_set.dart';
import 'package:wayagram/features/general_settings/change_pin/change_pin_page.dart';
import 'package:wayagram/features/general_settings/donation/donation_settings_page.dart';
import 'package:wayagram/features/general_settings/edit_interest/edit_interest.dart';
import 'package:wayagram/features/general_settings/event/event_settings_page.dart';
import 'package:wayagram/features/general_settings/group/group_setting_page.dart';
import 'package:wayagram/features/general_settings/page/page_general_setting_page.dart';
import 'package:wayagram/features/general_settings/post_settings/post_settings_page.dart';
import 'package:wayagram/features/general_settings/privacy_settings/view/blocked_user_page.dart';
import 'package:wayagram/features/general_settings/privacy_settings/view/privacy_settings.dart';
import 'package:wayagram/features/general_settings/friend_follower/view/friend_follower_page.dart';
import 'package:wayagram/features/general_settings/notifications/view/default.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/general_settings/profile/view/profile_page.dart';
import 'package:wayagram/features/general_settings/quotation/quotation_settings_page.dart';
import 'package:wayagram/features/general_settings/reset_pin_page/reset_pin.dart';
import 'package:wayagram/features/general_settings/reset_pin_page/verify_transaction_identity.dart';
import 'package:wayagram/features/general_settings/reset_pin_page/verify_your_identity_page.dart';
import 'package:wayagram/features/general_settings/shop/shop_setting_page.dart';
import 'package:wayagram/features/group/view/add_group_member.dart';
import 'package:wayagram/features/group/view/confirm_group_details.dart';
import 'package:wayagram/features/group/view/create_group.dart';
import 'package:wayagram/features/group/view/create_group_post.dart';
import 'package:wayagram/features/group/view/edit_group_member.dart';
import 'package:wayagram/features/group/view/group_setting.dart';
import 'package:wayagram/features/group/view/group_suggestion.dart';
import 'package:wayagram/features/group/view/groups.dart';
import 'package:wayagram/features/group/view/members_screen.dart';
import 'package:wayagram/features/group/view/public_group.dart';
import 'package:wayagram/features/group/view/single_group_invitation.dart';
import 'package:wayagram/features/group/view/success_group.dart';
import 'package:wayagram/features/group/view/user_group_invitation.dart';
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
import 'package:wayagram/features/pages/view/edit_page_member.dart';
import 'package:wayagram/features/pages/view/page_follower.dart';
import 'package:wayagram/features/pages/view/page_settings.dart';
import 'package:wayagram/features/pages/view/pages.dart';
import 'package:wayagram/features/pages/view/public_page.dart';
import 'package:wayagram/features/pages/view/search_group_and_page.dart';
import 'package:wayagram/features/pages/view/search_page.dart';
import 'package:wayagram/features/pages/view/single_page_invitation.dart';
import 'package:wayagram/features/pages/view/success_page.dart';
import 'package:wayagram/features/pages/view/suggestion.dart';
import 'package:wayagram/features/pages/view/user_page_invitation.dart';
import 'package:wayagram/features/polls_and_voting/data/model/payout_review_model.dart';
import 'package:wayagram/features/polls_and_voting/views/payout_verification.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_request_payout.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_review.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_detail_screen.dart';
import 'package:wayagram/features/post/view/create_post.dart';
import 'package:wayagram/features/follow/view/mutual_page.dart';
import 'package:wayagram/features/polls_and_voting/views/add_choices.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_dashboard.dart';
import 'package:wayagram/features/polls_and_voting/views/create_poll.dart';
import 'package:wayagram/features/polls_and_voting/views/poll_summary.dart';
import 'package:wayagram/features/polls_and_voting/views/polls_and_votes.dart';
import 'package:wayagram/features/polls_and_voting/views/share_voting_link.dart';
import 'package:wayagram/features/post/view/edit_post.dart';
import 'package:wayagram/features/post/view/full_comment_details.dart';
import 'package:wayagram/features/post/view/single_post.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/features/promotion/views/promotion_dashboard.dart';
import 'package:wayagram/features/promotion/views/promotion_detail.dart';
import 'package:wayagram/features/quotation/buyer/views/bid/see_buyer_bids.dart';
import 'package:wayagram/features/quotation/buyer/views/buyer_checkout.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/create_request.dart';
import 'package:wayagram/features/quotation/seller/views/bids/all_seller_bids.dart';
import 'package:wayagram/features/quotation/seller/views/bids/see_seller_bids.dart';
import 'package:wayagram/features/quotation/seller/views/bids/seller_bid_details.dart';
import 'package:wayagram/features/quotation/seller/views/bids/seller_settlement.dart';
import 'package:wayagram/features/quotation/seller/views/order_details.dart';
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
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_deal_ad.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/waya_gram_deals.dart';
import 'package:wayagram/features/shop/views/favorites_product.dart';
import 'package:wayagram/features/shop/views/products_view_page.dart';
import 'package:wayagram/features/shop/views/seller_shop_products.dart';
import 'package:wayagram/features/shop/views/top_selling_list.dart';
import 'package:wayagram/features/support/views/chat.dart';
import 'package:wayagram/features/support/views/dispute.dart';
import 'package:wayagram/features/support/views/request.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/admin_transaction_history.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/all_state_contest.dart';
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
import 'package:wayagram/features/ugt/my_contest_details/ended_contest_page.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/my_contest_details/voters_list_page.dart';
import 'package:wayagram/features/wallet/transactions/view/all_transaction_history.dart';
import 'package:wayagram/features/wallet/transactions/view/payout_history.dart';
import 'package:wayagram/features/wallet/transactions/view/search_transaction.dart';
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
import '../../features/activity_logs/view/logs_and_audit.dart';
import '../../features/activity_logs/view/payment_activity.dart';
import '../../features/activity_logs/view/search_log.dart';
import '../../features/activity_logs/view/user_action.dart';
import '../../features/activity_logs/view/user_interaction.dart';
import '../../features/activity_logs/view/visited_page.dart';
import '../../features/donation/view/see_all_closed_donation.dart';
import '../../features/group/view/mute_group.dart';
import '../../features/group/view/search_group.dart';

class WayaAppRoutes {
  WayaAppRoutes._();
  static final routes = <String, WidgetBuilder>{
    '/': (context) => SplashScreen(),
    LoginCoverPage.route: (context) => LoginCoverPage(),
    OnboardingView.route: (context) => OnboardingView(),
    AccountCreation.route: (context) =>
        AccountCreation(referral: WayaNav.parameters['referral'].toString()),
    ChangedPasswordSuccess.route: (context) => ChangedPasswordSuccess(),
    SetNotification.route: (context) => SetNotification(),
    SuccessfulSetup.route: (context) => SuccessfulSetup(),
    ForgotPasswordStep.route: (context) => ForgotPasswordStep(),
    TransactionPinView.route: (context) => TransactionPinView(),
    SelectInterest.route: (context) => SelectInterest(),
    AddBusinessAccountView.route: (context) => AddBusinessAccountView(),
    LoginPage.route: (context) => LoginPage(),
    WelcomeBackPage.route: (context) => WelcomeBackPage(),
    BottomView.route: (context) => BottomView(),
    ProductDetail.route: (context) =>
        ProductDetail(id: WayaNav.parameters['id'].toString()),
    OrderDetails.route: (context) => OrderDetails(),
    ConfirmOrderDelivery.route: (context) => ConfirmOrderDelivery(),
    CartView.route: (context) => CartView(),
    AllSellerOrders.route: (context) => AllSellerOrders(),
    SellerOrderDetails.route: (context) => SellerOrderDetails(),
    SellerBidDetails.route: (context) => SellerBidDetails(
          id: WayaNav.parameters['id'].toString(),
          requestId: WayaNav.parameters['requestId'].toString(),
        ),
    SellerSettlement.route: (context) => SellerSettlement(),
    SeeSellerBids.route: (context) => SeeSellerBids(
          id: WayaNav.parameters['id'].toString(),
          requestId: WayaNav.parameters['requestId'].toString(),
        ),
    SeeBuyerBids.route: (context) =>
        SeeBuyerBids(id: WayaNav.parameters['id'].toString()),
    Checkout.route: (context) => Checkout(),
    BuyerCheckout.route: (context) => BuyerCheckout(
          id: WayaNav.parameters['id'].toString(),
          requestId: WayaNav.parameters['requestId'].toString(),
        ),
    FilterView.route: (context) => FilterView(),
    GeneralSettingsPage.route: (context) => GeneralSettingsPage(),
    ChangePasswordGenSettings.route: (context) => ChangePasswordGenSettings(),
    ChangePinPage.route: (context) => ChangePinPage(),
    ResetPinPage.route: (context) => ResetPinPage(),
    VerifyYourIdentityPage.route: (context) => VerifyYourIdentityPage(),
    WayaWebview.route: (context) => WayaWebview(),
    FundWalletOptionsScreen.route: (context) => FundWalletOptionsScreen(),
    WalletPage.route: (context) => WalletPage(),
    FundAccountScreen.route: (context) => FundAccountScreen(),
    TransactionDetailsScreen.route: (context) => TransactionDetailsScreen(),
    VerifyTransactionScreen.route: (context) => VerifyTransactionScreen(),
    AllTransactionHistory.route: (context) => AllTransactionHistory(),
    BankTransferScreen.route: (context) => BankTransferScreen(),
    EditNamePage.route: (context) => EditNamePage(),
    EditProfilePage.route: (context) => EditProfilePage(),
    AddProduct.route: (context) => AddProduct(),
    //ProductListing.route: () => ProductListing(),
    WayaDealAd.route: (context) => WayaDealAd(),
    WayaGramDeals.route: (context) => WayaGramDeals(),
    ApplicationProductDetails.route: (context) => ApplicationProductDetails(),
    CreateShop.route: (context) => CreateShop(),
    SellerDispute.route: (context) => SellerDispute(),
    SellerDisputeDetail.route: (context) => SellerDisputeDetail(),
    AddEvidence.route: (context) => AddEvidence(),
    DisputeChat.route: (context) =>
        DisputeChat(id: WayaNav.parameters['id'].toString()),
    UgtGetStarted.route: (context) => UgtGetStarted(),
    UgtHome.route: (context) => UgtHome(),
    CreateContest.route: (context) => CreateContest(),
    CreateContestPost.route: (context) => CreateContestPost(),
    EditContestantProfile.route: (context) => EditContestantProfile(),
    ViewSingleContestantData.route: (context) => ViewSingleContestantData(),
    ContestActiveDisqualify.route: (context) => ContestActiveDisqualify(),
    AllStateContest.route: (context) => AllStateContest(),
    ContestProfilePage.route: (context) => ContestProfilePage(
          id: WayaNav.parameters['id'].toString(),
          contest: WayaNav.parameters['contest'].toString(),
        ),
    ManageApplicationContest.route: (context) => ManageApplicationContest(),
    ManageStateSingleContest.route: (context) => ManageStateSingleContest(),
    DashboardContestPage.route: (context) => DashboardContestPage(),
    PayoutHistory.route: (context) => PayoutHistory(),
    WayaSocialNotificationsScreen.route: (context) =>
        WayaSocialNotificationsScreen(),
    ManageLeaderboardContest.route: (context) => ManageLeaderboardContest(),
    AdminTransactionHistory.route: (context) => AdminTransactionHistory(),
    ContestSettingContent.route: (context) => ContestSettingContent(),
    EditStagePreference.route: (context) => EditStagePreference(),
    CreateRequest.route: (context) => CreateRequest(),
    AllSellerBids.route: (context) => AllSellerBids(),
    ManageShop.route: (context) => ManageShop(),
    UpgradeToBusiness.route: (context) => UpgradeToBusiness(),
    CreatePoll.route: (context) => CreatePoll(),
    PollAndVoting.route: (context) => PollAndVoting(),
    AddChoices.route: (context) => AddChoices(),
    PollSummary.route: (context) => PollSummary(),
    PollDashboard.route: (context) => PollDashboard(),
    PollReview.route: (context) => PollReview(
          id: WayaNav.parameters['id'].toString(),
          module: WayaNav.parameters['Module'] as PayoutModule,
          model: WayaNav.parameters['Model'] as PayoutReviewModel,
        ),
    PageSetting.route: (context) => PageSetting(),
    PollRequestPayout.route: (context) => PollRequestPayout(),
    SearchGroupAndPage.route: (context) => SearchGroupAndPage(),
    SearchGroup.route: (context) => SearchGroup(),
    PayoutVerification.route: (context) => PayoutVerification(),
    SearchTransaction.route: (context) => SearchTransaction(),
    UpcomingContestDetails.route: (context) => UpcomingContestDetails(),
    CreateProfile.route: (context) => CreateProfile(),
    RegisterContest.route: (context) => RegisterContest(),
    EditInterest.route: (context) => EditInterest(),
    VotersListPage.route: (context) => VotersListPage(),
    AdminContestDetails.route: (context) => AdminContestDetails(
          id: WayaNav.parameters['id'].toString(),
        ),
    ShareVotingLink.route: (context) => ShareVotingLink(),
    DeliveryRequest.route: (context) => DeliveryRequest(),
    SellerProducts.route: (context) => SellerProducts(),
    ProductsViewPage.route: (context) => ProductsViewPage(),
    WayaNotifications.route: (context) => WayaNotifications(),
    NotificationSettingsScreen.route: (context) => NotificationSettingsScreen(),
    Moment.route: (context) => Moment(),
    EventView.route: (context) => EventView(),
    AddEvent.route: (context) => AddEvent(),
    EventDetail.route: (context) =>
        EventDetail(id: WayaNav.parameters['id'].toString()),
    CreatePage.route: (context) => CreatePage(),
    CreateGroup.route: (context) => CreateGroup(),
    ConfirmPageDetails.route: (context) => ConfirmPageDetails(),
    ConfirmGroupDetails.route: (context) => ConfirmGroupDetails(),
    SuccessPage.route: (context) => SuccessPage(),
    SuccessGroup.route: (context) => SuccessGroup(),
    Pages.route: (context) => Pages(),
    SearchPage.route: (context) => SearchPage(),
    Groups.route: (context) => Groups(),
    Suggestion.route: (context) => Suggestion(),
    GroupSuggestion.route: (context) => GroupSuggestion(),
    Promote.route: (context) => Promote(),
    PromotionDashboard.route: (context) => PromotionDashboard(),
    PromotionDetail.route: (context) =>
        PromotionDetail(id: WayaNav.parameters['id'].toString()),
    PublicPage.route: (context) => PublicPage(
          id: WayaNav.parameters['id'].toString(),
        ),
    MembersScreen.route: (context) => MembersScreen(
          id: WayaNav.parameters['id'].toString(),
        ),
    CreatePost.route: (context) => CreatePost(),
    CreateGroupPost.route: (context) => CreateGroupPost(
          id: WayaNav.parameters['id'].toString(),
        ),
    CreatePagePost.route: (context) => CreatePagePost(
          id: WayaNav.parameters['id'].toString(),
        ),
    MutualPage.route: (context) => MutualPage(
          initialTab: WayaNav.parameters['tab'] ?? 'followers',
          userId: WayaNav.parameters['uid'].toString(),
          source: WayaNav.parameters['source'] ?? 'any',
        ),
    FollowRelationshipsPage.route: (context) => FollowRelationshipsPage(),
    PublicGroup.route: (context) =>
        PublicGroup(id: WayaNav.parameters['id'].toString()),
    AddTeamMember.route: (context) =>
        AddTeamMember(id: WayaNav.parameters['id'].toString()),
    DisplayFeed.route: (context) => DisplayFeed(),
    GroupSetting.route: (context) => GroupSetting(),
    PageFollowerScreen.route: (context) => PageFollowerScreen(
          id: WayaNav.parameters['id'].toString(),
        ),
    AllUpcomingEvents.route: (context) => AllUpcomingEvents(),
    MediaMoment.route: (context) => MediaMoment(),
    MyMoments.route: (context) => MyMoments(),
    VideoTrimmerScreen.route: (context) => VideoTrimmerScreen(),
    ViewFullMedia.route: (context) => ViewFullMedia(),
    EndedContestPage.route: (context) => EndedContestPage(
          id: WayaNav.parameters['id'].toString(),
        ),
    EditPost.route: (context) => EditPost(
          initialContent: WayaNav.parameters['initialContent'].toString(),
          initialMedia: WayaNav.parameters['initialMedia'].toString(),
          postId: WayaNav.parameters['postId'].toString(),
          privacy: WayaNav.parameters['privacy'].toString(),
        ),
    AddGroupMember.route: (context) =>
        AddGroupMember(id: WayaNav.parameters['id'].toString()),
    SearchView.route: (context) => SearchView(),
    EditGroupMemberInfo.route: (context) =>
        EditGroupMemberInfo(id: WayaNav.parameters['id'].toString()),
    EditPageMemberInfo.route: (context) =>
        EditPageMemberInfo(id: WayaNav.parameters['id'].toString()),
    PollDetailScreen.route: (context) =>
        PollDetailScreen(id: WayaNav.parameters['id'].toString()),
    ArchivedChatsScreen.route: (context) => ArchivedChatsScreen(),
    Donations.route: (context) => Donations(),
    DonationDetails.route: (context) =>
        DonationDetails(id: WayaNav.parameters['id'].toString()),
    CreateDonation.route: (context) => CreateDonation(),
    DonationDashboard.route: (context) => DonationDashboard(),
    SeeAllDonations.route: (context) => SeeAllDonations(),
    SeeAllLiveDonations.route: (context) => SeeAllLiveDonations(),
    SeeAllRejectedDonations.route: (context) => SeeAllRejectedDonations(),
    SeeAllApprovedDonations.route: (context) => SeeAllApprovedDonations(),
    SeeAllClosedDonations.route: (context) => SeeAllClosedDonations(),
    ChatAndSocial.route: (context) => ChatAndSocial(),
    SupportRequestScreen.route: (context) => SupportRequestScreen(),
    SupportDisputeScreen.route: (context) => SupportDisputeScreen(),
    SupportChatScreen.route: (context) => SupportChatScreen(),
    InitDispute.route: (context) => InitDispute(),
    DisputeDetail.route: (context) =>
        DisputeDetail(id: WayaNav.parameters['id'].toString()),
    ProductSearchResult.route: (context) => ProductSearchResult(),
    LogsAndAuditTrials.route: (context) => LogsAndAuditTrials(),
    ActivityLog.route: (context) => ActivityLog(),
    QuotationSellerOrders.route: (context) => QuotationSellerOrders(),
    VisitedPage.route: (context) => VisitedPage(),
    DonationSettingsPage.route: (context) => DonationSettingsPage(),
    QuotationSettingsPage.route: (context) => QuotationSettingsPage(),
    ShopSettingPage.route: (context) => ShopSettingPage(),
    PageGeneralSetting.route: (context) => PageGeneralSetting(),
    GroupSettingPage.route: (context) => GroupSettingPage(),
    MuteGroup.route: (context) => MuteGroup(),
    UserPageInvitation.route: (context) => UserPageInvitation(),
    SinglePageInvitation.route: (context) =>
        SinglePageInvitation(id: WayaNav.parameters['id'].toString()),
    SingleGroupInvitation.route: (context) =>
        SingleGroupInvitation(id: WayaNav.parameters['id'].toString()),
    UserGroupInvitation.route: (context) => UserGroupInvitation(),
    EventSettingsPage.route: (context) => EventSettingsPage(),
    PostSettingsPage.route: (context) => PostSettingsPage(),
    UserAction.route: (context) => UserAction(),
    CmsClicks.route: (context) => CmsClicks(),
    UserInteraction.route: (context) => UserInteraction(),
    PaymentActivity.route: (context) => PaymentActivity(),
    SearchLog.route: (context) => SearchLog(),
    KycUpdate.route: (context) => KycUpdate(),
    QuotationOrderDetails.route: (context) => QuotationOrderDetails(
          requestId: WayaNav.parameters['id'].toString(),
        ),
    SellerBuyRequestsScreen.route: (context) => SellerBuyRequestsScreen(),
    BuyerBuyRequestsScreen.route: (context) => BuyerBuyRequestsScreen(),
    RoleAccessPage.route: (context) => RoleAccessPage(),
    AddTeamMemberPage.route: (context) => AddTeamMemberPage(),
    MemberDetailsPage.route: (context) => MemberDetailsPage(),
    VerifyEmail.route: (context) => VerifyEmail(),
    ReferralPage.route: (context) => ReferralPage(),
    ReferralHistoryPage.route: (context) => ReferralHistoryPage(),
    PrivacySettingsPage.route: (context) => PrivacySettingsPage(),
    FriendFollowerPage.route: (context) => FriendFollowerPage(),
    RequestPayout.route: (context) => RequestPayout(),
    AddPayoutMethodScreen.route: (context) => AddPayoutMethodScreen(),
    PayoutDetails.route: (context) => PayoutDetails(),
    PayoutSuccessScreen.route: (context) => PayoutSuccessScreen(),
    EnterRequestAmountScreen.route: (context) => EnterRequestAmountScreen(),
    BlockedUserPage.route: (context) => BlockedUserPage(),
    AccountSecurity.route: (context) => AccountSecurity(),
    EditChatGroupScreen.route: (context) => EditChatGroupScreen(
          groupId: WayaNav.parameters['id'].toString(),
          chatId: WayaNav.parameters['chatId'].toString(),
        ),
    SellerShopProducts.route: (context) => SellerShopProducts(
          vendorId: WayaNav.parameters['id'].toString(),
          shopId: WayaNav.parameters['shopId'].toString(),
        ),
    EventInvite.route: (context) => EventInvite(
          eventId: WayaNav.parameters["id"].toString(),
          eventTitle: WayaNav.parameters["title"].toString(),
        ),
    FavoritesProducts.route: (context) => FavoritesProducts(),
    TopSellingList.route: (context) => TopSellingList(),
    VerifyTransactionIdentity.route: (context) => VerifyTransactionIdentity(),
    TwoFactorAuth.route: (context) =>
        TwoFactorAuth(email: WayaNav.parameters["email"].toString()),
    SinglePost.route: (context) =>
        SinglePost(postId: WayaNav.parameters["postId"].toString()),
    EventDashboard.route: (context) =>
        EventDashboard(id: WayaNav.parameters["id"].toString()),
    CommentDetailsScreen.route: (context) => CommentDetailsScreen(
          id: WayaNav.parameters["id"].toString(),
          postId: WayaNav.parameters["post"].toString(),
          source: WayaNav.parameters["id"].toString(),
        ),
  };

  /// Route generator for handling routes with query parameters
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    final routeName = uri.path;
    final queryParams = uri.queryParameters;

    // Handle routes with query parameters
    switch (routeName) {
      case '/conversation/chat':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => SingleChatScreen(chatId: queryParams['id']!),
            settings: settings,
          );
        }
        break;
      case '/p': // ProfilePage route
        final username = queryParams['u'];
        final id = queryParams['id'];
        final source = queryParams['source'] ?? 'any';

        if (username != null) {
          return MaterialPageRoute(
            builder: (context) => ProfilePage(
              id: '',
              username: username,
              source: source,
            ),
            settings: settings,
          );
        } else if (id != null) {
          return MaterialPageRoute(
            builder: (context) => ProfilePage(
              id: id,
              username: null,
              source: source,
            ),
            settings: settings,
          );
        }
        break;
      case '/conversation/chat/profile':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => ChatProfilePage(chatId: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/quotation/buyer/order':
        final id = queryParams['id'];
        final requestId = queryParams['requestId'];
        if (id != null && requestId != null) {
          return MaterialPageRoute(
            builder: (context) => BuyerCheckout(id: id, requestId: requestId),
            settings: settings,
          );
        }
        break;

      case '/quotation/seller/order':
        final id = queryParams['id'];
        final requestId = queryParams['requestId'];
        if (id != null && requestId != null) {
          return MaterialPageRoute(
            builder: (context) =>
                SellerBidDetails(id: id, requestId: requestId),
            settings: settings,
          );
        }
        break;

      case '/quotation/buyer/bids':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => SeeBuyerBids(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/quotation/seller/bids':
        final id = queryParams['id'];
        final requestId = queryParams['requestId'];
        if (id != null && requestId != null) {
          return MaterialPageRoute(
            builder: (context) => SeeSellerBids(id: id, requestId: requestId),
            settings: settings,
          );
        }
        break;

      case '/quotation/seller/bid':
        final id = queryParams['id'];
        final requestId = queryParams['requestId'];
        if (id != null && requestId != null) {
          return MaterialPageRoute(
            builder: (context) =>
                SellerBidDetails(id: id, requestId: requestId),
            settings: settings,
          );
        }
        break;

      case '/quotation/seller/orders/one':
        final requestId = queryParams['requestId'] ?? queryParams['id'];
        if (requestId != null) {
          return MaterialPageRoute(
            builder: (context) => QuotationOrderDetails(requestId: requestId),
            settings: settings,
          );
        }
        break;

      case '/product':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => ProductDetail(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/donation':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => DonationDetails(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/group':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => PublicGroup(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/groups/public':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => PublicGroup(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/page':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => PublicPage(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/pages/public':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => PublicPage(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/group/invitation':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => SingleGroupInvitation(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/page/invitation':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => SinglePageInvitation(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/group/members':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => MembersScreen(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/group/add_member':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => AddGroupMember(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/page/add_member':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => AddTeamMember(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/page/post':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => CreatePagePost(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/group/post':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => CreateGroupPost(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/event':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => EventDetail(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/event-detail':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => EventDetail(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/contest':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => AdminContestDetails(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/dispute/chat':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => DisputeChat(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/dispute':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => DisputeDetail(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/follow':
        final uid = queryParams['uid'];
        final tab = queryParams['tab'] ?? 'followers';
        final source = queryParams['source'] ?? 'any';
        if (uid != null) {
          return MaterialPageRoute(
            builder: (context) =>
                MutualPage(userId: uid, initialTab: tab, source: source),
            settings: settings,
          );
        }
        break;

      case '/follow/relationships':
        final uid = queryParams['uid'];
        final tab = queryParams['tab'] ?? 'followers';
        final source = queryParams['source'] ?? 'any';
        if (uid != null) {
          return MaterialPageRoute(
            builder: (context) =>
                MutualPage(userId: uid, initialTab: tab, source: source),
            settings: settings,
          );
        }
        break;

      case '/userGroupInvitation/single':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => SingleGroupInvitation(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/userPageInvitation/single':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => SinglePageInvitation(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/groups/members':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => MembersScreen(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/groups/members/add':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => AddGroupMember(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/pages/team/add':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => AddTeamMember(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/groups/post/new':
        if (queryParams.containsKey('id')) {
          return MaterialPageRoute(
            builder: (context) => CreateGroupPost(id: queryParams['id']!),
            settings: settings,
          );
        }
        break;

      case '/contest-profile-page':
        final id = queryParams['id'];
        final contest = queryParams['contest'];
        if (id != null && contest != null) {
          return MaterialPageRoute(
            builder: (context) => ContestProfilePage(id: id, contest: contest),
            settings: settings,
          );
        }
        break;

      case '/two-factor-authentication':
        final email = queryParams['email'];
        if (email != null) {
          return MaterialPageRoute(
            builder: (context) => TwoFactorAuth(email: email),
            settings: settings,
          );
        }
        break;
    }

    // If no custom route matches, return null to fall back to default route handling
    return null;
  }

  /// Helper that shows an example of the generator route pattern with GetX and
  /// a little bit of hard coded magic.
  static String getSingleChatRoute(String id) =>
      "${SingleChatScreen.route}?id=$id";

  /// Helper that shows an example of the generator route pattern with GetX and
  /// a little bit of hard coded magic.
  static String getProfileRoute(
    String id, [
    String source = 'any',
    String? username,
  ]) =>
      "${ProfilePage.route}?${username != null ? 'u=$username' : 'id=$id&source=$source'}";

  /// Helper function that is used to get the route to the chat of a single
  /// dispute by its ID.
  static String getDisputeChatsRoute(String id) =>
      "${DisputeChat.route}?id=$id";

  /// Helper function that is used to navigate to the route that contains all
  /// the bids of sellers
  static String getBuyerBidsRoute(String id) => "${SeeBuyerBids.route}?id=$id";

  /// Helper function that is used to navigate to the route that contains all
  /// the bids of sellers
  static String getSellerBidsRoute(String id, String requestId) =>
      "${SeeSellerBids.route}?id=$id&requestId=$requestId";

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
  /// single group invitation by its ID.
  static String getGroupInvitation(String id) =>
      "${SingleGroupInvitation.route}?id=$id";

  /// Helper function used to generate the route that is supposed to take you a
  /// single page invitation by its ID.
  static String getPageInvitation(String id) =>
      "${SinglePageInvitation.route}?id=$id";

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
      "${PollDetailScreen.route}?id=$id";

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
      "${DonationDetails.route}?id=$id";

  /// Helper function used to generate the route that is supposed to take you a
  /// single bid's details screen.
  static String getBidDetailsScreen(String id, String requestId) =>
      "${SellerBidDetails.route}?id=$id&requestId=$requestId";

  /// Helper function used to generate the route that leads to the quotation
  /// checkout screen for a buyer.
  static String getQuotationCheckoutScreen(String id, String requestId) =>
      "${BuyerCheckout.route}?id=$id&requestId=$requestId";

  /// Helper function used to generate the route that is supposed to take you a
  /// single donation by its ID.
  static String getWalletDetailsPage(String id) =>
      "${BankTransferScreen.route}?id=$id";

  /// Helper function used to generate the route tha tis supposed to take you to
  /// a single order's details screen.
  static String getQuotationOrderDetailsScreen(String id) =>
      "${QuotationOrderDetails.route}?id=$id&requestId=$id";

  /// Helper function used to generate the route that takes a user to the screen
  /// for the details of a single product.
  static String getPromotionDetailScreen(String id) =>
      "${PromotionDetail.route}?id=$id";

  /// Helper function used to generate the route that takes a user to the screen
  /// to edit the profile of a single chat group.
  static String getEditChatGroupProfileScreen(String id, String chatId) =>
      "${EditChatGroupScreen.route}?id=$id&chatId=$chatId";

  static String getEditPostScreen(
          String postId, String content, String privacy, String media) =>
      "${EditPost.route}?postId=$postId&privacy=$privacy&initialContent=$content&initialMedia=$media";

  static String getSellerShopDetailScreen(String vendorId, String shopId) =>
      "${SellerShopProducts.route}?id=$vendorId&shopId=$shopId";

  static String getEventInviteScreen(String id, String title) =>
      "${EventInvite.route}?id=$id&title=$title";

  static String getSinglePostScreen(String postId) =>
      "${SinglePost.route}?postId=$postId";

  static String getCommentDetailsScreen(String id, String postId,
          [String? source]) =>
      "${CommentDetailsScreen.route}?id=$id&post=$postId&source=$source";

  static String get2FaScreen(
    String email,
  ) =>
      "${TwoFactorAuth.route}?email=$email";
  static String getSingleEventDashboard(String id) =>
      "${EventDashboard.route}?id=$id";
//
}
