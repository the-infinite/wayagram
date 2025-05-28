import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class TransactionRepository extends BaseRepository {
  Future<WayaRequestResponse> getUserTransactions(
      {int? page = 1, int? limit = 100, String? filters}) {
    return get(
        'wayagram-wallet/api/v2/client/transactions?page=$page&limit=$limit&${filters ?? ""}');
  }

  Future<WayaRequestResponse> getSingleTransactions(String transactionId) {
    return get(
      'wayagram-wallet/api/v2/client/transactions/$transactionId',
    );
  }
}
