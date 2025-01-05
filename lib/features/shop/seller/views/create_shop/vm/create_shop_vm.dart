import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/seller/data/repo/seller_repository.dart';

class CreateShopVm extends StateNotifier<CreateShopState> {
  final SellerRepository _sellerRepository;
  final _logger = getLogger('CreateShopVm');
  CreateShopVm(this._sellerRepository) : super(CreateShopState());

  Future<void> createSellerShop() async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _sellerRepository.createShop(state.createShopModel);

      if (response.success) {
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final createShopVmProvider =
    StateNotifierProvider<CreateShopVm, CreateShopState>((ref) {
  return CreateShopVm(SellerRepository());
});
