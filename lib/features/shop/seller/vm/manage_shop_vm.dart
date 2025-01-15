import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/seller/data/model/manage_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';
import 'package:wayagram/features/shop/seller/data/repo/seller_repository.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';

class ManageShopVm extends StateNotifier<ManageShopState> {
  final SellerRepository _sellerRepository;
  final SuccessfulSetUpState _setUpState;
  final _logger = getLogger('ManageShopVm');

  ManageShopVm(this._sellerRepository, this._setUpState)
      : super(ManageShopState());

  List<Map<String, dynamic>> salesMetrics = [
    {"title": "Total Sales", "metrics": "N100,000", "color": Color(0xffE3EFFC)},
    {"title": "Total Products", "metrics": "50", "color": Color(0xffE7F6EC)},
    {"title": "Pending Orders", "metrics": "100", "color": Color(0xffFEF6E7)},
  ];
  Future<void> getSellerShops() async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _sellerRepository.getShopBySellerId(_setUpState.business!.id!);
      if (response.success) {
        ShopResponseModel responseModel =
            ShopResponseModel.fromJson(response.data);

        state = state.copyWith(hasShop: responseModel.data.isNotEmpty);
        // state = state.copyWith(shop: responseModel.data);
        print(state.hasShop);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
       state = state.copyWith(isLoading: false);
    }
   
  }
}

final manageShopVmProvider =
    StateNotifierProvider.autoDispose<ManageShopVm, ManageShopState>((ref) {
  final setUp = ref.watch(successfulSetupVmProvider);
  return ManageShopVm(SellerRepository(), setUp);
});
