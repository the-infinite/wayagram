import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/cart/data/repo/cart_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_state.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_response_model.dart';

class DeliveryRequestVm extends StateNotifier<DeliveryRequestState> {
  final Ref ref;
  final CartRepository _cartRepository;

  DeliveryRequestVm(this._cartRepository, this.ref)
      : super(DeliveryRequestState());

  Future<List<DeliveryRequestData>?> getRequests() async {
    try {
      final shopId = ref.watch(manageShopVmProvider).singleShop?.id;
      final response = await _cartRepository.getPendingDelivery(id: shopId!);

      List<DeliveryRequestData> requests = [];
      if (response.success) {
        DeliveryRequestResponseModel responseModel =
            DeliveryRequestResponseModel.fromJson(response.data);
        requests = responseModel.data;
        state = state.copyWith(deliveryRequest: requests);
      }
      return requests;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  List<DeliveryRequestData> get filteredRequests {
    if (state.deliveryRequests.isEmpty) return [];
    return state.deliveryRequests.where((req) {
      // search filter
      if (state.search.text.isNotEmpty) {
        final query = state.search.text.toLowerCase();
        return req.userId.contains(query);
      }

      return true;
    }).toList();
  }
}

final deliveryRequestVmProvider =
    StateNotifierProvider<DeliveryRequestVm, DeliveryRequestState>((ref) {
  final cartRepo = ref.watch(cartRepositoryProvider);
  return DeliveryRequestVm(cartRepo, ref);
});
