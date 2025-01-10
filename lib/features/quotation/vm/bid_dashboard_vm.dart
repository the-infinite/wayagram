import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/repo/seller_repository.dart';

import '../seller/data/model/bid_dashboard_state.dart';

class BidDashboardVm extends StateNotifier<BidDashboardState> {
  final SellerRepository _sellerRepository;
  final _logger = getLogger('BidDashboardVm');

  BidDashboardVm(this._sellerRepository) : super(BidDashboardState());

  List<Map<String, dynamic>> salesMetrics = [
    {"title": "Total Settlements", "metrics": "N100,000", "color": Color(0xffE3EFFC)},
    {"title": "Won Bids", "metrics": "50", "color": Color(0xffE7F6EC)},
    {"title": "Open Bids", "metrics": "100", "color": Color(0xffFEF6E7)},
  ];
  Future<void> getUserBidDashboard() async {
    state = state.copyWith(hasShop: false);
  }
}

final bidDashboardVmProvider =
StateNotifierProvider.autoDispose<BidDashboardVm, BidDashboardState>((ref) {
  return BidDashboardVm(SellerRepository());
});
