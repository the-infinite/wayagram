import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/wallet/model/dto.dart';

class WalletRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.wallet;
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
    return get('$serviceUrl/client/wallet/get-external-wallet?accountNumber=$accountNumber');
  }

  Future<WayaRequestResponse> payForService(WalletPaymentData data) {
    return post('$serviceUrl/client/payment/pay-for-service', data.toJson(), showErrors: true);
  }

  Future<WayaRequestResponse> getPayoutMethod() {
    return get('$serviceUrl/client/payout/methods');
  }

  Future<WayaRequestResponse> getSinglePayoutMethod(String id) {
    return get('$serviceUrl/client/payout/methods/$id');
  }

  Future<WayaRequestResponse> getSingleRequest(String id) {
    return get('$serviceUrl/client/payout/requests/$id');
  }

  Future<WayaRequestResponse> getBanks() {
    return get('$serviceUrl/client/payout/bank/banks');
  }

  Future<WayaRequestResponse> verifyName(String acctNumber, String bankCode) {
    final payload = {
      "accountNumber": acctNumber,
      "bankCode": bankCode
    };
    return post("$serviceUrl/client/payout/bank/name-enquiry", payload);
  }

  Future<WayaRequestResponse> getRequestPayout(int page) {
    return get('$serviceUrl/client/payout/requests?page=$page&limit=10');
  }

  Future<WayaRequestResponse> createPayoutRequest(String amount, String paymentMethodId) {
    final payload = {"userId": ConversationState.self.id, "amount": amount, "payoutMethodId": paymentMethodId};
    return post('$serviceUrl/client/payout/requests', payload);
  }

  Future<WayaRequestResponse> createPayoutMethod(String acctNum, String acctName,
      String bankName, String bankCode) {

    final payload = {
      "accountNumber": acctNum,
      "accountName": acctName,
      "bankName": bankName,
      "bankCode": bankCode
    };
    return post('$serviceUrl/client/payout/methods', payload);
  }

  Future<WayaRequestResponse> deletePayoutMethod(id) {
    return delete("$serviceUrl/client/payout/methods/$id", showErrors: true);
  }

  //payout
  Future<WayaRequestResponse> requestPayout(String contestId) {
   
    return post('$serviceUrl/client/payout/requests', {"contestId": contestId},formdata: false);
  }

   Future<WayaRequestResponse> fetchPayoutHistory(String referenceId,String purpose, {int page = 1, int limit = 10}) {
  
    return get('$serviceUrl/client/payout/requests?page=$page&limit=$limit&referenceId=$referenceId&purpose=$purpose');
  }


}
