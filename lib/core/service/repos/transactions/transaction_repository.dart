import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<void> getTransactionForExport() async {
    //getExternalStorageDirectory();
    final directory = await getTemporaryDirectory(); //
    debugPrint('LOG PDF $directory');

    final filePath = '${directory!.path}/transaction.pdf';

    /*final filePath = await FileSaver.instance.saveFile(
      name: 'transaction.pdf',
      //bytes: response.data,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );*/

    final data = await download(
        'wayagram-wallet/api/v2/client/transactions/export', filePath,
        (data, size) {
      debugPrint('PPDF size $size');
    });

    debugPrint('PPDF ${data.data}');
  }

  Future<void> getTransactionForExportTwo() async {
    //getExternalStorageDirectory();
    final directory = await getTemporaryDirectory(); //
    debugPrint('LOG PDF $directory');

    final filePath = '${directory.path}/transaction.pdf';

    final data = await download(
        'wayagram-wallet/api/v2/client/transactions/export', filePath,
            (data, size) {
          debugPrint('PPDF size $size');
        });

    debugPrint('PPDF ${data.data}');
  }

  Future<WayaRequestResponse> getTransactionForExportThree() {
    return get(
      'wayagram-wallet/api/v2/client/transactions/export',
    );
  }


}


