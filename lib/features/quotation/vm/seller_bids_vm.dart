import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardMetric {
  final String title;
  final Color color;
  final String key;

  DashboardMetric({
    required this.title,
    required this.color,
      required this.key,
  });
}

class SellerBidsVm extends ChangeNotifier {
  final Ref ref;
  SellerBidsVm(this.ref);

  List<Map<String, dynamic>> orderMetrics = [
    {"title": "Open Bids", "metrics": "100", "color": Color(0xffFEF6E7)},
    {"title": "Won Bids", "metrics": "284", "color": Color(0xffE7F6EC)},
    {"title": "Closed Bids", "metrics": "50", "color": Color(0xffE3EFFC)},
  ];

  List<Map<String, dynamic>> otherMetrics = [
    {"title": "Paid Orders", "metrics": "100", "color": Color(0xffF7F9FC)},
    {"title": "Local Shipment Timer", "metrics": "4hrs 5min Left", "color": Color(0xffFFF0EB)},
  ];
}

final sellerBidsVmProvider = ChangeNotifierProvider<SellerBidsVm>((ref) {
  return SellerBidsVm(ref);
});
