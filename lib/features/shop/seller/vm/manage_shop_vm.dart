import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageShopVm extends ChangeNotifier {
  final Ref ref;
  ManageShopVm(this.ref);

  List<Map<String, dynamic>> salesMetrics = [
    {
      "title": "Total Sales",
      "metrics": "N100,000",
      "color": Color(0xffE3EFFC)
    },
    {"title": "Total Products", "metrics": "50", "color": Color(0xffE7F6EC)},
    {"title": "Pending Orders", "metrics": "100", "color": Color(0xffFEF6E7)},
  ];
}

final manageShopVmProvider = ChangeNotifierProvider<ManageShopVm>((ref) {
  return ManageShopVm(ref);
});
