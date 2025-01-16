import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/seller/data/repo/seller_repository.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/vm/create_shop_vm.dart';

class ManageShopVm extends StateNotifier<ManageShopState> {
  final SellerRepository _sellerRepository;
  final WayaSecureDataSource _secureDataSource;
  final Ref ref;

  final _logger = getLogger('ManageShopVm');

  ManageShopVm(this._sellerRepository, this._secureDataSource, this.ref)
      : super(ManageShopState.initial());

  List<Map<String, dynamic>> salesMetrics = [
    {"title": "Total Sales", "metrics": "N100,000", "color": Color(0xffE3EFFC)},
    {"title": "Total Products", "metrics": "50", "color": Color(0xffE7F6EC)},
    {"title": "Pending Orders", "metrics": "100", "color": Color(0xffFEF6E7)},
  ];
  Future<void> getSellerShops() async {
    state = state.copyWith(isLoading: true);
    final businessId = ref.watch(successfulSetupVmProvider).business!.id;

    try {
      final response = await _sellerRepository.getShopBySellerId(businessId!);

      if (response.data['statusCode'] == 400 &&
          response.data['data'] == 'Shop not found') {
        print("oke okeefwefewfefeffefefefefeeee");
        await ref
            .read(createShopVmProvider.notifier)
            .createSellerShop(hasNoShop: true);
        return;
      }
      if (response.success) {
        ShopResponseModel responseModel =
            ShopResponseModel.fromJson(response.data);

        state = state.copyWith(hasShop: responseModel.data.isNotEmpty);
        // state = state.copyWith(shop: responseModel.data);

        state = state.copyWith(shop: responseModel.data);
      }
    } catch (e) {
      _logger.e("wefewfewfe $e");
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
}

final manageShopVmProvider =
    StateNotifierProvider.autoDispose<ManageShopVm, ManageShopState>((ref) {
  return ManageShopVm(SellerRepository(), WayaSecureDataSource(), ref);
});
