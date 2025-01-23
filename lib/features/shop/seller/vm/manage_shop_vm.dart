import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/vm/create_shop_vm.dart';
import 'package:wayagram/features/shop/seller/vm/delivery_request_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

List<SalesMetric> salesMetrics = [
  SalesMetric(title: "Total Sales", metrics: "0", color: Color(0xffE3EFFC)),
  SalesMetric(title: "Total Products", metrics: "0", color: Color(0xffE7F6EC)),
  SalesMetric(title: "Pending Orders", metrics: "0", color: Color(0xffFEF6E7))
];

class ManageShopVm extends StateNotifier<ManageShopState> {
  final ShopRepository _shopRepository;
  final WayaSecureDataSource _secureDataSource;
  final Ref ref;

  final _logger = getLogger('ManageShopVm');

  ManageShopVm(this._shopRepository, this._secureDataSource, this.ref)
      : super(ManageShopState.initial()) {
    state = state.copyWith(salesMetric: salesMetrics);
  }

  Future<void> getSellerShops() async {
    final isBusiness = ref.read(successfulSetupVmProvider).business!.id;
    if (isBusiness == null || isBusiness.isEmpty) {
      print("gergre $isBusiness");
      // account is most likely a personal account
      state = state.copyWith(isPersonalNotUpgradedToBusiness: true);
      return;
    }

    state = state.copyWith(isPersonalNotUpgradedToBusiness: false);

    try {
      state = state.copyWith(isLoading: true);
      final response = await _shopRepository.getShopBySellerId(isBusiness);

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
    ref.read(shopVmProvider.notifier).getAllProducts();
    ref.read(deliveryRequestVmProvider.notifier).getRequests();
    updateMetrics();
  }

  void updateMetrics() {
    final productState = ref.read(shopVmProvider).products.length;
    state = state.copyWith(numberOfProducts: productState);

    List<SalesMetric> sales = [];
    sales = List.from(state.salesMetric);

    sales.map((value) {
      if (value.title == "Total Products") {
        value.copyWith(metrics: "$productState");
      }
      return value;
    }).toList();
    state = state.copyWith(salesMetric: sales);
  }
}

final manageShopVmProvider =
    StateNotifierProvider.autoDispose<ManageShopVm, ManageShopState>((ref) {
  return ManageShopVm(ShopRepository(), WayaSecureDataSource(), ref);
});
