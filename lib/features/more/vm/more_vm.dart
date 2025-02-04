import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/more/data/model/more_option_model.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';

class MoreVm {
  final BuildContext context;
  late final List<MoreOptionModel> moreOptions;

  MoreVm(this.context) {
    moreOptions = [
      MoreOptionModel(
          asset: WayaAssets.icons.mWallet.path,
          content:
              "You can fund your wallet to perform transactions seamlessly",
          title: "Wallet",
          onTap: () {
            WayaNav.toNamed(WalletPage.route);
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mPages.path,
          content: "Create pages so you can manage different activities",
          title: "Pages",
          onTap: () {
            WayaNav.toNamed('/createPage');

          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mGroup.path,
          content:
              "Create groups and manage who is following you and who you follow.",
          title: "Group",
          onTap: () {
            WayaNav.toNamed('/createGroup');
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mShop.path,
          content:
              "Buy and sell product from the convince of your home or store",
          title: "Shop",
          onTap: () {
            Navigator.pushNamed(context, BottomView.route, arguments: 1);
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mQuotation.path,
          content:
              "Create groups and manage who is following you and who you follow.",
          title: "Get Quotation",
          onTap: () {
            Navigator.pushNamed(context, BottomView.route, arguments: 3);
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mStream.path,
          content: "Start a live conversation and allows friends to interact",
          title: "Live Streaming",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssets.icons.mEvents.path,
          content: "Start an event or discover various event around you",
          title: "Events",
          onTap: () {
            WayaNav.toNamed(EventView.route);
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mUgt.path,
          content: "A contest open for various school and other categories",
          title: "University Got Talent",
          onTap: () {
            WayaNav.toNamed('/ugt-get-started');
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mPoll.path,
          content: "Create both paid and free poll for your different audience",
          title: "Poll & Vote",
          onTap: () {
            WayaNav.toNamed('/poll-and-voting');
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mDonation.path,
          content: "Create Donation Posts and also help people in need",
          title: "Donation",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssets.icons.mPromotion.path,
          content:
              "Promote your goods and services so it can be seen by more people.",
          title: "Promotion",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssets.icons.mFollow.path,
          content: "Manage your following, followers in one place.",
          title: "Followers & Following",
          onTap: () {
            WayaNav.toNamed('/mutualPage',arguments: 'more');
          }),
      MoreOptionModel(
          asset: WayaAssets.icons.mSupport.path,
          content: "For assistance, please reach out to our support team.",
          title: "Support",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssets.icons.mChat.path,
          content: "Chat and call your family and friends",
          title: "Chat & Call",
          onTap: () {}),
    ];
  }
}
