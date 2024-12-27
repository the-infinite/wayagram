import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBarItem {
  final String icon;
  final String label;

  BottomBarItem({required this.icon, required this.label});
}

class BottomViewVm extends ChangeNotifier {
  final Ref ref;
  BottomViewVm(this.ref);
  final List<BottomBarItem> barItems = [
    BottomBarItem(icon: 'assets/icons/b-explore.svg', label: 'Explore'),
    BottomBarItem(icon: 'assets/icons/b-shop.svg', label: 'Shop'),
    BottomBarItem(icon: 'assets/icons/b-donation.svg', label: 'Donations'),
    BottomBarItem(icon: 'assets/icons/b-bid.svg', label: 'Bid'),
    BottomBarItem(icon: 'assets/icons/b-chat.svg', label: 'Chat'),
    BottomBarItem(icon: 'assets/icons/b-menu.svg', label: 'Menu'),
  ];




}

final bottomViewVmProvider =
    ChangeNotifierProvider.autoDispose((ref) => BottomViewVm(ref));
