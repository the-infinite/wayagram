import 'package:file_saver/file_saver.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/config/environment.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'transaction_repository.g.dart';

class TransactionRepository extends BaseRepositoryRiverpod {
  TransactionRepository(super.ref);

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

  Future<void> getTransactionForExport() async {
    final secureDataSource = WayaSecureDataSource();

    try {
      String? _ = await FileSaver.instance.saveAs(
        name: "transaction",
        link: LinkDetails(
            link:
                "${AppEnvironment.apiBaseUrl}${WayaServiceUri.wallet}/client/transactions/export",
            method: "GET",
            headers: {
              'Authorization': 'Bearer ${await secureDataSource.getToken()}'
            }),
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );
    } catch (_) {}
  }
}

@riverpod
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepository(ref);
}
