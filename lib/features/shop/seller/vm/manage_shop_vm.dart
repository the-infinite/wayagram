import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/repo/seller_repository.dart';

class ManageShopVm extends StateNotifier<ManageShopState> {
  final SellerRepository _sellerRepository;
  final _logger = getLogger('ManageShopVm');

  ManageShopVm(this._sellerRepository) : super(ManageShopState());

  List<Map<String, dynamic>> salesMetrics = [
    {"title": "Total Sales", "metrics": "N100,000", "color": Color(0xffE3EFFC)},
    {"title": "Total Products", "metrics": "50", "color": Color(0xffE7F6EC)},
    {"title": "Pending Orders", "metrics": "100", "color": Color(0xffFEF6E7)},
  ];
  Future<void> getUserShop() async {
    state = state.copyWith(hasShop: false);
  }
}

final manageShopVmProvider =
    StateNotifierProvider.autoDispose<ManageShopVm, ManageShopState>((ref) {
  return ManageShopVm(SellerRepository());
});
