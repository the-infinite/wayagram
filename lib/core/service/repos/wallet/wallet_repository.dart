import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/service/repos/wallet/wallet_model.dart';

class WalletRepository extends BaseRepository {

  Future<WayaRequestResponse> createPin(CreateWalletPin payload) {
    return post(
        'wayagram-wallet/api/v2/client/wallet-pin/create', payload.toJson());
  }
}