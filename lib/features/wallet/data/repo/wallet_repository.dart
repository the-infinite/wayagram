import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';

class WalletRepository extends BaseRepository {
  static const serviceUrl = 'wayagram-wallet/api/v2';
  static final instance = WalletRepository._();
  WalletRepository._();

  Future<WayaRequestResponse> createPin(CreateWalletPin payload) {
    return post('$serviceUrl/client/wallet-pin/create', payload.toJson());
  }

  Future<WayaRequestResponse> confirmWalletPin(ConfirmWalletPin payload) {
    return post('$serviceUrl/client/wallet-pin/confirm-pin', payload.toJson());
  }

  Future<WayaRequestResponse> checkWalletPinStatus(String userId) {
    return post('$serviceUrl/client/wallet-pin/check-status', {"userId": userId});
  }

  Future<WayaRequestResponse> getUserWallet() {
    return get('$serviceUrl/client/wallet');
  }

  Future<WayaRequestResponse> getWalletFundingOptions() {
    return get('$serviceUrl/client/wallet/fund-wallet-options');
  }

  Future<WayaRequestResponse> fundWallet(FundWallet payload) {
    return post('$serviceUrl/client/wallet/fund-wallet', payload.toJson());
  }

  Future<WayaRequestResponse> verifyWalletFunding(VerifyTransaction payload) {
    return post('$serviceUrl/client/wallet/verify-wallet-funding', payload.toJson());
  }

  Future<WayaRequestResponse> getExternalWallet(String accountNumber) {
    return get('$serviceUrl/client/wallet/get-external-wallet?accountNumber=9000000075');
  }

  Future<WayaRequestResponse> payForService(PayForService payload) {
    return post('$serviceUrl/client/payment/pay-for-service', payload.toJson());
  }
}
