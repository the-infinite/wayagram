import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';

class BottomBarItem {
  final String icon;
  final String label;
  final bool isChat;

  BottomBarItem({
    required this.icon,
    required this.label,
    this.isChat = false,
  });
}

class BottomViewVm extends ChangeNotifier {
  final Ref ref;
  BottomViewVm(this.ref);
  final List<BottomBarItem> barItems = [
    BottomBarItem(icon: WayaAssets.icons.bExplore.path, label: 'Explore'),
    BottomBarItem(icon: WayaAssets.icons.bShop.path, label: 'Shop'),
    BottomBarItem(icon: WayaAssets.icons.bDonation.path, label: 'Donations'),
    BottomBarItem(icon: WayaAssets.icons.bBid.path, label: 'Bid'),
    BottomBarItem(icon: WayaAssets.icons.bChat.path, label: 'Chat', isChat: true),
    BottomBarItem(icon: WayaAssets.icons.bMenu.path, label: 'More'),
  ];
}

final bottomViewVmProvider = ChangeNotifierProvider.autoDispose((ref) => BottomViewVm(ref));
