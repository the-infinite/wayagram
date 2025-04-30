import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/helpers/debug.dart';
import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/wallet/model/dto.dart';

class WalletResource {
  final repo = WalletRepository.instance;
  static final instance = WalletResource._();

  WalletResource._();

  /// Helper function used to get the wallet associated with a given account
  /// number. Since this returns the userId as a subproperty, you can also use
  /// it to fetch the user's full details with the [UserResource] class.
  Future<ExternalWalletModel?> getUserWallet(String accountNumber) async {
    try {
      final response = await repo.getExternalWallet(accountNumber);

      //? If this was fine, return the wallet.
      if (response.success) {
        return ExternalWalletModel.fromJson(response.data['data']);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.wallets,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This is fine.
    return null;
  }

  /// Helper function used to make a payment using the wallet API for a service.
  /// It can be said that
  Future<bool> payForService(WalletPaymentData data) async {
    try {
      final response = await repo.payForService(data);

      //? If this was fine, return the wallet.
      if (response.success) {
        return response.success;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.wallets,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return false;
  }
}
