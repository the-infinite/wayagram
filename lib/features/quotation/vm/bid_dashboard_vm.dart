import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import '../seller/data/model/bid_dashboard_state.dart';

class BidDashboardVm extends StateNotifier<BidDashboardState> {
  final repo = ShopRepository.instance;
  final logger = getLogger('BidDashboardVm');

  BidDashboardVm() : super(BidDashboardState());

  List<Map<String, dynamic>> salesMetrics = [
    {"title": "Total Settlements", "metrics": "N100,000", "color": Color(0xffE3EFFC)},
    {"title": "Won Bids", "metrics": "50", "color": Color(0xffE7F6EC)},
    {"title": "Open Bids", "metrics": "100", "color": Color(0xffFEF6E7)},
  ];
  Future<void> getUserBidDashboard() async {
    state = state.copyWith(hasShop: false);
  }
}

final bidDashboardVmProvider = StateNotifierProvider.autoDispose<BidDashboardVm, BidDashboardState>((ref) {
  return BidDashboardVm();
});
