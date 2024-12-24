import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/interests/views/select_interest.dart';

final pinProvider = StateProvider<String>((ref) => '');
final confirmPinProvider = StateProvider<String>((ref) => '');
final isPinValidProvider = StateProvider<bool>((ref) {
  final pin = ref.watch(pinProvider);
  final confirmPin = ref.watch(confirmPinProvider);
  return pin.length == 4 && pin == confirmPin;
});

class TransactionPinVm extends StateNotifier<void> {
  TransactionPinVm(this.ref) : super(null);
  final Ref ref;

  void handleKeyPress(String value) {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);

    if (pin.length < 4) {
      ref.read(pinProvider.notifier).state = pin + value;
    } else if (confirmPin.length < 4) {
      ref.read(confirmPinProvider.notifier).state = confirmPin + value;
    }
  }

  void handleBackspace() {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);

    if (confirmPin.isNotEmpty) {
      ref.read(confirmPinProvider.notifier).state =
          confirmPin.substring(0, confirmPin.length - 1);
    } else if (pin.isNotEmpty) {
      ref.read(pinProvider.notifier).state = pin.substring(0, pin.length - 1);
    }
  }

  void handleLongPressBackspace() {
    ref.read(pinProvider.notifier).state = '';
    ref.read(confirmPinProvider.notifier).state = '';
  }

  void submitPins() {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);
    ref.read(isPinValidProvider.notifier).state =
        pin.length == 4 && pin != confirmPin;
    if (pin.length == 4 && pin == confirmPin) {
     WayaNav.toNamed('/select-interests');
     
    }
       ref.read(isPinValidProvider.notifier).state = pin.length == 4 && pin == confirmPin;
  }

  void clearPins() {
    ref.read(pinProvider.notifier).state = '';
    ref.read(confirmPinProvider.notifier).state = '';
  }
}

final transactionPinProvider =
    StateNotifierProvider<TransactionPinVm, void>((ref) {
  return TransactionPinVm(ref);
});
