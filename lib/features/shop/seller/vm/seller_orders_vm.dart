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
    SalesMetric(
        title: "Pending Orders", metrics: "0", color: Color(0xffFEF6E7)),
    SalesMetric(
        title: "Delivered Orders", metrics: "0", color: Color(0xffE3EFFC)),
    SalesMetric(title: "Shipped Orders", metrics: "0", color: Color(0xffE7F6EC))
  ];

class SellerOrdersVm extends StateNotifier<SellerOrdersState> {
  final Ref ref;
  final OrderRepository _orderRepository;
  SellerOrdersVm(this._orderRepository, this.ref) : super(SellerOrdersState()) {
    state = state.copyWith(salesMetric: orderMetrics);
  }



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

  Future<PaginatedResult<Order>?> getOrders(int page) async {
    try {
      final response =
          await _orderRepository.getSellerOrders(state.shopId, page);
      List<Order> orders = [];
      bool hasNextPage = false;
      if (response.success) {
        OrdersResponse ordersResponse = OrdersResponse.fromJson(response.data);
        orders = ordersResponse.data.data;
        hasNextPage = ordersResponse.data.pagination.hasNextPage;
        if (ordersResponse.data.data.isNotEmpty) {
          final numberOfPendingOrders = ordersResponse.data.data
              .where((value) => value.status == 'pending')
              .toList()
              .length;
          final numberOfCompletedOrders = ordersResponse.data.data
              .where((value) => value.status == 'completed')
              .toList()
              .length;
          final numberOfProecessedOrders = ordersResponse.data.data
              .where((value) => value.status == 'processing')
              .toList()
              .length;

          
        final updatedMetrics = state.salesMetric.map((metric) {
          if (metric.title == "Pending Orders") {
            return metric.copyWith(metrics: "$numberOfPendingOrders");
          } else if (metric.title == "Delivered Orders") {
            return metric.copyWith(metrics: "$numberOfCompletedOrders");
          } else if (metric.title == "Shipped Orders") {
            return metric.copyWith(metrics: "$numberOfProecessedOrders");
          }
          return metric;
        }).toList();

        // Update the state
        state = state.copyWith(salesMetric: updatedMetrics);
        }
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
