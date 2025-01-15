import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';

class BottomBarItem {
  final String icon;
  final String label;

  BottomBarItem({required this.icon, required this.label});
}

class BottomViewVm extends ChangeNotifier {
  final Ref ref;
  BottomViewVm(this.ref);
  final List<BottomBarItem> barItems = [
    BottomBarItem(icon: WayaAssests.icons.bExplore.path, label: 'Explore'),
    BottomBarItem(icon: WayaAssests.icons.bShop.path, label: 'Shop'),
    BottomBarItem(icon: WayaAssests.icons.bDonation.path, label: 'Donations'),
    BottomBarItem(icon: WayaAssests.icons.bBid.path, label: 'Bid'),
    BottomBarItem(icon: WayaAssests.icons.bChat.path, label: 'Chat'),
    BottomBarItem(icon: WayaAssests.icons.bMenu.path, label: 'Menu'),
  ];




}

final bottomViewVmProvider =
    ChangeNotifierProvider.autoDispose((ref) => BottomViewVm(ref));
