import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

final orderPinProvider = StateProvider<String>((ref) => '');

class ConfirmOrderDeliveryVm extends StateNotifier<void> {
  ConfirmOrderDeliveryVm(this.ref) : super(null);
  final Ref ref;

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

  void submitPins(BuildContext context) {
    final pin = ref.read(orderPinProvider);

    if (pin.length < 10) {
      WayaHelpers.showNotice(
          context: context,
          title: 'Invalid Code Entered!',
          message:
              'The code you entered is incorrect. Please double-check and try \n again',
          onPress: () => Navigator.of(context).pop(),
          icon: Image.asset('assets/images/d-code-invalid.png'),
          buttonText: 'Try Again');
    } else {
      WayaHelpers.showNotice(
          context: context,
          title: 'Handover Successful!',
          message:
              'The confirmation code has been verified. The product is now \n officially handed over to the buyer',
          onPress: () => WayaNav.toNamed('/explore'),
          icon: Image.asset('assets/images/d-code-valid.png'),
          buttonText: 'Go To Shop');
    }
  }

  void clearPins() {
    ref.read(orderPinProvider.notifier).state = '';
  }
}

final confirmOrderDeliveryVmProvider =
    StateNotifierProvider<ConfirmOrderDeliveryVm, void>((ref) {
  return ConfirmOrderDeliveryVm(ref);
});
