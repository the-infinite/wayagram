import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/data/model/order_state.dart';
import 'package:wayagram/features/shop/order/data/repo/order_repository.dart';

class OrderVm extends StateNotifier<OrderState> {
  final Ref ref;
  final OrderRepository _orderRepository;
  final WayaSecureDataSource _secureDataSource;

  OrderVm(this._orderRepository, this._secureDataSource, this.ref)
      : super(OrderState());

  Future<PaginatedResult<Order>?> getOrders({required int page}) async {
    try {
      state = state.copyWith(isLoading: false);
      final userId = await _secureDataSource.getUserId();
      final response = await _orderRepository.getUserOrders(userId!, page);
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
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> declineOrder(
      {required String orderId,
      required String reason,
      required String shopId,
      required BuildContext context}) async {
    try {
      state = state.copyWith(isRejecting: true);
      final response = await _orderRepository.declineOrder(
          orderId: orderId, reason: reason, shopId: shopId);

      if (response.success && context.mounted) {
        WayaSnackBar.showToast("You have declined this order");
        WayaNav.goBack();
        WayaNav.toNamed(BottomView.route,
            arguments: {'index': 1, 'current': 2});
      } else {
        if (response.data['responseCode'] == 704) {
          WayaSnackBar.showToast("Access not granted by the shop owner");
        }
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final orderVmProvider = StateNotifierProvider<OrderVm, OrderState>((ref) {
  return OrderVm(OrderRepository(), WayaSecureDataSource(), ref);
});
