import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/general_settings/change_pin/data/change_pin_repo.dart';

final pinProvider = StateProvider<String>((ref) => '');
final confirmPinProvider = StateProvider<String>((ref) => '');
final newPinConfirmationProvider = StateProvider<String>(
    (ref) => ''); // this code needs to  be refactored after the first deployment , it is hard working with it

final loadingProvider = StateProvider<bool>((ref) => false);
final isPinValidProvider = StateProvider<bool>((ref) {
  final pin = ref.watch(pinProvider);
  final confirmPin = ref.watch(confirmPinProvider);
  return pin.length == 4 && pin == confirmPin;
});

final isChangePinValidProvider = StateProvider<bool>((ref) {
  // this code needs to  be refactored after the first deployment , it is hard working with it
  final pin = ref.watch(pinProvider);
  final confirmPin = ref.watch(confirmPinProvider);
  final newConfirmPin = ref.watch(newPinConfirmationProvider);
  return pin.length == 4 && confirmPin.length == 4 && confirmPin == newConfirmPin;
});

class TransactionPinVm extends StateNotifier<void> {
  final WalletRepository _walletRepository = WalletRepository.instance;
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();
  final ChangePinRepo _changePinRepo = ChangePinRepo();
  final _logger = getLogger("TransactionPinVm");
  TransactionPinVm(this.ref) : super(null);
  final Ref ref;

  void handleKeyPress(String value) {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);
    final newConfirmPin = ref.read(newPinConfirmationProvider);

    if (pin.length < 4) {
      ref.read(pinProvider.notifier).state = pin + value;
    } else if (confirmPin.length < 4) {
      ref.read(confirmPinProvider.notifier).state = confirmPin + value;
    } else if (newConfirmPin.length < 4) {
      ref.read(newPinConfirmationProvider.notifier).state = newConfirmPin + value;
    }
  }

  void handleBackspace() {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);
    final newConfirmPin = ref.read(
        newPinConfirmationProvider); // this code needs to  be refactored after the first deployment , it is hard working with it

    if (newConfirmPin.isNotEmpty) {
      ref.read(newPinConfirmationProvider.notifier).state = newConfirmPin.substring(0, newConfirmPin.length - 1);
    } // this code needs to  be refactored after the first deployment , it is hard working with it
    else if (confirmPin.isNotEmpty) {
      ref.read(confirmPinProvider.notifier).state = confirmPin.substring(0, confirmPin.length - 1);
    } else if (pin.isNotEmpty) {
      ref.read(pinProvider.notifier).state = pin.substring(0, pin.length - 1);
    }
  }

  void handleLongPressBackspace() {
    ref.read(pinProvider.notifier).state = '';
    ref.read(confirmPinProvider.notifier).state = '';
    ref.read(newPinConfirmationProvider.notifier).state =
        ''; // this code needs to  be refactored after the first deployment , it is hard working with it
  }

  Future<void> submitPins() async {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);
    ref.read(isPinValidProvider.notifier).state = pin.length == 4 && pin != confirmPin;

    ref.read(isPinValidProvider.notifier).state = pin.length == 4 && pin == confirmPin;

    if (pin.length == 4 && pin == confirmPin) {
      try {
        ref.read(loadingProvider.notifier).state = true;
        //  final user = _localDataSource.getUser();
        final userId = _localDataSource.getUserId();

        final response =
            await _walletRepository.createPin(CreateWalletPin(confirmPin: confirmPin, pin: pin, userId: userId));
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

  Future<void> changeTransactionPin() async {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);
    final newConfirmPin = ref.read(newPinConfirmationProvider);
    ref.read(isPinValidProvider.notifier).state = pin.length == 4 && pin != confirmPin;

    ref.read(isPinValidProvider.notifier).state = pin.length == 4 && pin == confirmPin;

    if (pin.length == 4 && confirmPin.length == 4 && newConfirmPin == confirmPin) {
      ref.read(loadingProvider.notifier).state = true;
      try {
        final userId = _localDataSource.getUserId();

        final response = await _changePinRepo.changePin(userId: userId ?? '', oldPin: pin, confirmPin: newConfirmPin);

        if (response.success) {
          WayaSnackBar.showToast('Pin Changed Successfully');
          Future.delayed(Duration(seconds: 2), () {
            WayaNav.offNamed('/general-settings');
          });
          ref.read(pinProvider.notifier).state = '';
          ref.read(confirmPinProvider.notifier).state = '';
          ref.read(newPinConfirmationProvider.notifier).state =
              ''; // this code needs to  be refactored after the first deployment , it is hard working with it
        }
      } catch (e) {
        _logger.e(e);
      } finally {
        ref.read(loadingProvider.notifier).state = false;
      }
    }
  }

  Future<void> resetPin(String otp) async {
    final pin = ref.read(pinProvider);
    final confirmPin = ref.read(confirmPinProvider);
    final newConfirmPin = ref.read(newPinConfirmationProvider);
    ref.read(isPinValidProvider.notifier).state = pin.length == 4 && pin != confirmPin;

    ref.read(isPinValidProvider.notifier).state = pin.length == 4 && pin == confirmPin;

    if ( confirmPin.length == 4 && newConfirmPin == confirmPin) {
      ref.read(loadingProvider.notifier).state = true;
      try {
        final userId = _localDataSource.getUserId();

        final response = await _changePinRepo.resetPin(userId: userId ?? '',
            pin: confirmPin, confirmPin: newConfirmPin, otp: otp);

        if (response.success) {
          WayaSnackBar.showToast('Pin Changed Successfully');
          Future.delayed(Duration(seconds: 2), () {
            WayaNav.offNamed('/general-settings');
          });
          ref.read(pinProvider.notifier).state = '';
          ref.read(confirmPinProvider.notifier).state = '';
          ref.read(newPinConfirmationProvider.notifier).state =
          ''; // this code needs to  be refactored after the first deployment , it is hard working with it
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
    ref.read(newPinConfirmationProvider.notifier).state =
        ''; // this code needs to  be refactored after the first deployment , it is hard working with it
  }
}

final transactionPinProvider = StateNotifierProvider<TransactionPinVm, void>((ref) {
  return TransactionPinVm(ref);
});
