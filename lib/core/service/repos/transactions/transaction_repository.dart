import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

class TransactionRepository extends BaseRepository {
  Future<WayaRequestResponse> getUserTransactions(
      {int? page = 1, int? limit = 100, String? filters}) {
    return get(
        'wayagram-wallet/api/v2/client/transactions?page=$page&limit=$limit&${filters ??
            ""}');
  }

  Future<WayaRequestResponse> getSingleTransactions(String transactionId) {
    return get(
      'wayagram-wallet/api/v2/client/transactions/$transactionId',
    );
  }

  Future<void> getTransactionForExport() async {
    final secureDataSource = WayaSecureDataSource();

    try {
      String? value = await FileSaver.instance.saveAs(
        name: "transaction",
        link: LinkDetails(
            link:
            "${WayaConstants.baseUrl}/${WayaServiceUri
                .wallet}/client/transactions/export",
            method: "GET",
            headers: {
              'Authorization': 'Bearer ${await secureDataSource.getToken()}'
            }),
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );

      print("resposeeee $value");
    } catch (e) {
      print("error $e");
    }
  }
}
