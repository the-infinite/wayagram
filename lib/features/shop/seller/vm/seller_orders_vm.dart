import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/data/repo/order_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';

class SellerOrdersState {
  final List<SalesMetric> salesMetric;
  final String shopId;

  SellerOrdersState({this.salesMetric = const [], this.shopId = ''});

  SellerOrdersState copyWith({List<SalesMetric>? salesMetric, String? shopId}) {
    return SellerOrdersState(
        salesMetric: salesMetric ?? this.salesMetric,
        shopId: shopId ?? this.shopId);
  }
}

List<SalesMetric> orderMetrics = [
  SalesMetric(title: "Pending Orders", metrics: "0", color: Color(0xffFEF6E7)),
  SalesMetric(
      title: "Delivered Orders", metrics: "0", color: Color(0xffE3EFFC)),
  SalesMetric(title: "Shipped Orders", metrics: "0", color: Color(0xFFF6E8E7))
];

class SellerOrdersVm extends StateNotifier<SellerOrdersState> {
  final Ref ref;
  final OrderRepository _orderRepository;
  SellerOrdersVm(this._orderRepository, this.ref) : super(SellerOrdersState());

  //  List<Map<String, dynamic>> otherMetrics = [
  //    {"title": "Paid Orders", "metrics": "100", "color": Color(0xffF7F9FC)},
  //   {
  //     "title": "Local Shipment Timer",
  //     "metrics": "4hrs 5min Left",
  //     "color": Color(0xffFFF0EB)
  //   },

  // ];

  void getShopId(String id) {
    state = state.copyWith(shopId: id);
  }

  Future<PaginatedResult<Order>?> getOrders({required int page}) async {
    try {
      final response =
          await _orderRepository.getSellerOrders(state.shopId, page);
      List<Order> orders = [];
      bool hasNextPage = false;
      if (response.success) {
        OrdersResponse ordersResponse = OrdersResponse.fromJson(response.data);
        orders = ordersResponse.data.docs;
        hasNextPage = ordersResponse.data.hasNextPage;
      }
      return PaginatedResult<Order>(hasNextPage: hasNextPage, items: orders);
    } catch (e) {
      print(e);
      return null;
    } finally {}
  }
}

final sellerOrdersVmProvider =
    StateNotifierProvider<SellerOrdersVm, SellerOrdersState>((ref) {
  return SellerOrdersVm(OrderRepository(), ref);
});
