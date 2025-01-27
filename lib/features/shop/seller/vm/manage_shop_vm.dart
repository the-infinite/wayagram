import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/data/repo/order_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/vm/create_shop_vm.dart';
import 'package:wayagram/features/shop/seller/vm/delivery_request_vm.dart';
import 'package:wayagram/features/shop/seller/vm/seller_products_vm.dart';

List<SalesMetric> salesMetrics = [
  SalesMetric(title: "Total Sales", metrics: "0", color: Color(0xffE3EFFC)),
  SalesMetric(title: "Total Products", metrics: "0", color: Color(0xffE7F6EC)),
  SalesMetric(title: "Pending Orders", metrics: "0", color: Color(0xffFEF6E7))
];

class ManageShopVm extends StateNotifier<ManageShopState> {
  final ShopRepository _shopRepository;
  final WayaSecureDataSource _secureDataSource;
  final OrderRepository _orderRepository;
  final Ref ref;

  final _logger = getLogger('ManageShopVm');

  ManageShopVm(this._shopRepository, this._orderRepository,
      this._secureDataSource, this.ref)
      : super(ManageShopState.initial()) {
    state = state.copyWith(salesMetric: salesMetrics);
  }

  Future<void> getSellerShops() async {
    final isBusiness = ref.read(successfulSetupVmProvider).business;
    if (isBusiness == null) {
      print("gergre $isBusiness");
      // account is most likely a personal account
      state = state.copyWith(isPersonalNotUpgradedToBusiness: true);
      return;
    }

    state = state.copyWith(isPersonalNotUpgradedToBusiness: false);

    try {
      final userId = await _secureDataSource.getUserId();
      state = state.copyWith(isLoading: true);
      final response = await _shopRepository.getShopBySellerId(userId!);

      if (response.success) {
        ShopResponseModel responseModel =
            ShopResponseModel.fromJson(response.data);

        state = state.copyWith(hasShop: responseModel.data.isNotEmpty);
        // state = state.copyWith(shop: responseModel.data);
        if (responseModel.data.isEmpty) {
          await ref
              .read(createShopVmProvider.notifier)
              .createSellerShop(hasNoShop: true);
          return;
        } else {
          state = state.copyWith(shop: responseModel.data);
        }
      }
    } catch (e) {
      _logger.e(" $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshShops() async {
    await getSellerShops();
  }

  void getCurrentShop(ShopData? shop) {
    state = state.copyWith(singleShop: shop);
  }

  void fetchData() async {
    state = state.copyWith(isLoadingOrder: true);
    await getOrders(shopId: state.singleShop!.id);
    final List<SellerProduct>? products = await ref
        .read(sellerProductsVmProvider.notifier)
        .sellerProducts(shopId: state.singleShop!.id);

    final List<DeliveryRequestData>? requests =
        await ref.read(deliveryRequestVmProvider.notifier).getRequests();
    state = state.copyWith(isLoadingOrder: false);
    updateMetrics(products: products, requests: requests);
  }

  void updateMetrics(
      {required List<SellerProduct>? products,
      required List<DeliveryRequestData>? requests}) {
    if (products != null && products.isNotEmpty) {
      state = state.copyWith(numberOfProducts: products.length);

      List<SalesMetric> sales = List.from(state.salesMetric);

      sales = sales.map((value) {
        if (value.title == "Total Products") {
          return value.copyWith(metrics: "${products.length}");
        }
        return value;
      }).toList();

      state = state.copyWith(salesMetric: sales);
    }

    if (requests != null) {
      state = state.copyWith(numberOfRequests: requests.length);
    }
  }

  Future<void> getOrders({required String shopId}) async {
    try {
      final response = await _orderRepository.getSellerOrders(shopId, 1);

      if (response.success) {
        OrdersResponse ordersResponse = OrdersResponse.fromJson(response.data);
        state = state.copyWith(orders: ordersResponse.data.data);
        if (ordersResponse.data.data.isNotEmpty) {
          state =
              state.copyWith(numberOfOrders: ordersResponse.data.data.length);
          final numberOfPendingOrders = ordersResponse.data.data
              .where((value) => value.status == 'pending')
              .toList()
              .length;
          List<SalesMetric> sales = List.from(state.salesMetric);
          sales = sales.map((value) {
            if (value.title == "Pending Orders") {
              return value.copyWith(metrics: "$numberOfPendingOrders");
            }
            return value;
          }).toList();

          state = state.copyWith(salesMetric: sales);
        }
      }
    } catch (e) {
      print(e);
    } finally {}
  }
}

final manageShopVmProvider =
    StateNotifierProvider.autoDispose<ManageShopVm, ManageShopState>((ref) {
  return ManageShopVm(
      ShopRepository(), OrderRepository(), WayaSecureDataSource(), ref);
});
