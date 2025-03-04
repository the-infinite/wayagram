import 'package:wayagram/features/wallet/data/model/external_wallet_model.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

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

      return null;
    } catch (e) {
      return null;
    }
  }
}
