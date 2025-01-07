import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/service/repos/wallet/wallet_model.dart';

class WalletRepository extends BaseRepository {
  Future<WayaRequestResponse> createPin(CreateWalletPin payload) {
    return post(
        'wayagram-wallet/api/v2/client/wallet-pin/create', payload.toJson());
  }

  Future<WayaRequestResponse> confirmWalletPin(ConfirmWalletPin payload) {
    return post('wayagram-wallet/api/v2/client/wallet-pin/confirm-pin',
        payload.toJson());
  }

  Future<WayaRequestResponse> checkWalletPinStatus(String userId) {
    return post('wayagram-wallet/api/v2/client/wallet-pin/check-status',
        {"userId": userId});
  }

  Future<WayaRequestResponse> getUserWallet() {
    return get('wayagram-wallet/api/v2/client/wallet');
  }

  Future<WayaRequestResponse> getWalletFundingOptions() {
    return get('wayagram-wallet/api/v2/client/wallet/fund-wallet-options');
  }

  Future<WayaRequestResponse> fundWallet(FundWallet payload) {
    return post(
        'wayagram-wallet/api/v2/client/wallet/fund-wallet', payload.toJson());
  }

  Future<WayaRequestResponse> verifyWalletFunding(VerifyTransaction payload) {
    return post('wayagram-wallet/api/v2/client/wallet/verify-wallet-funding',
        payload.toJson());
  }

  Future<WayaRequestResponse> payForService(PayForService payload) {
    return post('wayagram-wallet/api/v2/client/payment/pay-for-service',
        payload.toJson());
  }
}
