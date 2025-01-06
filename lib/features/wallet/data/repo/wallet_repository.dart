import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';

class WalletRepository extends BaseRepository {
  static const serviceUrl = 'wayagram-wallet';
  Future<WayaRequestResponse> createPin(CreateWalletPin payload) {
    return post(
        '$serviceUrl/api/v2/client/wallet-pin/create', payload.toJson());
  }

  Future<WayaRequestResponse> getUserWallet() {
    return get('$serviceUrl/api/v2/client/wallet');
  }
}
