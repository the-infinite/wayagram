import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/repos/auth/auth_repository.dart';
import 'package:wayagram/core/service/repos/wallet/wallet_model.dart';
import 'package:wayagram/core/service/repos/wallet/wallet_repository.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/interests/views/select_interest.dart';

final pinProvider = StateProvider<String>((ref) => '');
final confirmPinProvider = StateProvider<String>((ref) => '');
final loadingProvider = StateProvider<bool>((ref) => false);
final isPinValidProvider = StateProvider<bool>((ref) {
  final pin = ref.watch(pinProvider);
  final confirmPin = ref.watch(confirmPinProvider);
  return pin.length == 4 && pin == confirmPin;
});

class TransactionPinVm extends StateNotifier<void> {
  final WalletRepository _walletRepository = WalletRepository();
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();
  final _logger = getLogger("TransactionPinVm");
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

  Future<void> submitPins() async {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);
    ref.read(isPinValidProvider.notifier).state =
        pin.length == 4 && pin != confirmPin;

    ref.read(isPinValidProvider.notifier).state =
        pin.length == 4 && pin == confirmPin;

    if (pin.length == 4 && pin == confirmPin) {
      try {
        ref.read(loadingProvider.notifier).state = true;
       final user = _localDataSource.getUser();
        final response = await _walletRepository.createPin(CreateWalletPin(
            confirmPin: confirmPin,
            pin: pin,
            userId: user["id"]));
          _logger.d("  ${response.data}");
        if (response.data["statusCode"] == 200) {
          WayaNav.toNamed('/set-notification');
        }
      } catch (e) {
        _logger.e(e);
      } finally {
        ref.read(loadingProvider.notifier).state = false;
      }
    }
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
