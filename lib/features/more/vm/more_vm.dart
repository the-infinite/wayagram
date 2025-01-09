import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/more/data/model/more_option_model.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';

class MoreVm {
  final BuildContext context;
  late final List<MoreOptionModel> moreOptions;

  MoreVm(this.context) {
    moreOptions = [
      MoreOptionModel(
          asset: WayaAssests.icons.mWallet.path,
          content: "You can fund your wallet to perform transactions seamlessly",
          title: "Wallet",
          onTap: () {
            WayaNav.toNamed(WalletPage.route);
          }),
      MoreOptionModel(
          asset: WayaAssests.icons.mPages.path,
          content: "Create pages so you can manage different activities",
          title: "Pages",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mGroup.path,
          content:
              "Create groups and manage who is following you and who you follow.",
          title: "Group",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mShop.path,
          content: "Buy and sell product from the convince of your home or store",
          title: "Shop",
          onTap: () {
            Navigator.pushNamed(context, BottomView.route, arguments: 1);
          }),
      MoreOptionModel(
          asset: WayaAssests.icons.mQuotation.path,
          content:
              "Create groups and manage who is following you and who you follow.",
          title: "Get Quotation",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mStream.path,
          content: "Start a live conversation and allows friends to interact",
          title: "Live Streaming",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mEvents.path,
          content: "Start an event or discover various event around you",
          title: "Events",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mUgt.path,
          content: "A contest open for various school and other categories",
          title: "University Got Talent",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mPoll.path,
          content: "Create both paid and free poll for your different audience",
          title: "Poll & Vote",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mDonation.path,
          content: "Create Donation Posts and also help people in need",
          title: "Donation",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mPromotion.path,
          content:
              "Promote your goods and services so it can be seen by more people.",
          title: "Promotion",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mFollow.path,
          content: "Manage your following, followers in one place.",
          title: "Followers & Following",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mSupport.path,
          content: "For assistance, please reach out to our support team.",
          title: "Support",
          onTap: () {}),
      MoreOptionModel(
          asset: WayaAssests.icons.mChat.path,
          content: "Chat and call your family and friends",
          title: "Chat & Call",
          onTap: () {}),
    ];
  }
}
