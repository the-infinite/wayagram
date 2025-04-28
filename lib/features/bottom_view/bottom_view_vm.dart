import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

class BottomBarItem {
  final String icon;
  final String label;
  final bool isChat;
  final void Function(WidgetRef)? onTap;

  BottomBarItem({
    required this.icon,
    required this.label,
    this.isChat = false,
    this.onTap,
  });
}

class BottomViewVm extends ChangeNotifier {
  final Ref ref;
  static final exploreScrollController = ScrollController();

  BottomViewVm(this.ref);

  //? This is fine.
  final List<BottomBarItem> barItems = [
    BottomBarItem(
      icon: WayaAssets.icons.bExplore.path,
      label: 'Explore',
      onTap: (ref) {
        exploreScrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
        ref.read(successfulSetupVmProvider.notifier).getUserData();
        ref.read(selectInterestProvider.notifier).getUserInterest();
        ref.read(shopVmProvider.notifier).allCategories(1);
        ref.read(shopVmProvider.notifier).getAllProducts(page: 1, limit: 20);
        ref.read(eventVmProvider.notifier).getEventWithStatus(page: 1);
        ref.read(cartVmProvider.notifier).loadCart();
      },
    ),
    BottomBarItem(icon: WayaAssets.icons.bShop.path, label: 'Shop'),
    BottomBarItem(icon: WayaAssets.icons.bDonation.path, label: 'Donations'),
    BottomBarItem(icon: WayaAssets.icons.bBid.path, label: 'Bid'),
    BottomBarItem(icon: WayaAssets.icons.bChat.path, label: 'Chat', isChat: true),
    BottomBarItem(icon: WayaAssets.icons.bMenu.path, label: 'More'),
  ];
}

final bottomViewVmProvider = ChangeNotifierProvider.autoDispose((ref) => BottomViewVm(ref));
