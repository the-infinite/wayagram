import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/buyer/views/dialogs/review_product.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';

final orderPinProvider = StateProvider<String>((ref) => '');

class States {
  final bool isLoading;

  States({this.isLoading = false});

  States copyWith({bool? isLoading}) {
    return States(isLoading: isLoading ?? this.isLoading);
  }
}

class ConfirmOrderDeliveryVm extends StateNotifier<States> {
  ConfirmOrderDeliveryVm(this._shopRepository, this.ref) : super(States());
  final Ref ref;
  final ShopRepository _shopRepository;

  void handleKeyPress(String value) {
    final pin = ref.read(orderPinProvider);

    if (pin.length < 10) {
      ref.read(orderPinProvider.notifier).state = pin + value;
    }
  }

  void handleBackspace() {
    final pin = ref.read(orderPinProvider);

    if (pin.isNotEmpty) {
      ref.read(orderPinProvider.notifier).state =
          pin.substring(0, pin.length - 1);
    }
  }

  void handleLongPressBackspace() {
    ref.read(orderPinProvider.notifier).state = '';
  }

  Future<void> submitPins(BuildContext context, Order order) async {
    final pin = ref.read(orderPinProvider);

    try {
      if (pin.length < 10) {
        WayaUtils.showNotice(
            context: context,
            title: 'Invalid Code Entered!',
            message:
                'The code you entered is incorrect. Please double-check and try again',
            onPress: () {
               WayaNav.goBack();
            
            },
            icon: Image.asset('assets/icons/d-code-invalid.svg'),
            buttonText: 'Try Again');

        return;
      }
      state = state.copyWith(isLoading: true);
      final response =
          await _shopRepository.addToken(deliveryToken: pin.toString());

      if (response.success && context.mounted) {
        clearPins();
        state = state.copyWith(isLoading: false);
        await WayaUtils.showModalSheet(context,
            child: ReviewProduct(
              order: order,
            ));
      }
    } catch (error) {
      debugPrint(error.toString());
      clearPins();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearPins() {
    ref.read(orderPinProvider.notifier).state = '';
  }
}

final confirmOrderDeliveryVmProvider =
    StateNotifierProvider<ConfirmOrderDeliveryVm, States>((ref) {
  return ConfirmOrderDeliveryVm(ShopRepository.instance, ref);
});
