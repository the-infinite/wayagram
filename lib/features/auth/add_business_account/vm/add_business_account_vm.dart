import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
class DocType {
  final File file;
  final String name;
  final String type;

  DocType({required this.file, required this.type, required this.name});
}

class AddBusinessAccountVm extends ChangeNotifier {
  final WayaLocalDataSource localDataSource = WayaLocalDataSource();
  String selected = '';
  final TextEditingController businessName = TextEditingController();
  final TextEditingController businessAddress = TextEditingController();
  final TextEditingController cac = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  final _logger = getLogger('AddBusinessAccountVm');
  List<DocType> _uploadedDocuments = [];

  bool _isButtonEnabled = false;

  final Ref ref;

  AddBusinessAccountVm(this.ref) {
    selected = localDataSource.getSelectedBusinessType().label;
  }

  List<DocType> get uploadedDocuments => _uploadedDocuments;
  String get isSelected => selected;
  bool get isButtonEnabled => _isButtonEnabled;
  bool get isLoading => _isLoading;

  void selectType(String type) {
    selected = type;
    notifyListeners();
  }

  void addFile(File? file, String type) {
    if (file != null) {
      _uploadedDocuments.add(
          DocType(file: file, type: type, name: file.path.split('/').last));
    }

    notifyListeners();
  }

  void removeFile(type) {
    _uploadedDocuments.removeWhere((element) => element.type == type);
    notifyListeners();
  }

  void validateInputs() {
    if (selected == 'CAC') {
      _isButtonEnabled = businessName.text.isNotEmpty &&
          businessAddress.text.isNotEmpty &&
          cac.text.isNotEmpty;
    } else {
      _isButtonEnabled =
          businessName.text.isNotEmpty && businessAddress.text.isNotEmpty;
    }
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    businessName.addListener(validateInputs);
    businessAddress.addListener(validateInputs);
    cac.addListener(validateInputs);
  }

  @override
  void dispose() {
    businessName.dispose();
    businessAddress.dispose();
    cac.dispose();
    super.dispose();
  }

  Future<void> submit(BuildContext context) async {
Future<MultipartFile> formattedImage(File file) async {
  final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

  return await MultipartFile.fromFile(
    file.path,
    filename: file.uri.pathSegments.last, 
    contentType: DioMediaType.parse(mimeType),
  );
}

    final formdata = isSelected == 'CAC'
        ? {
            'nin': await formattedImage(uploadedDocuments
                .firstWhere((element) => element.type == 'nin')
                .file),
            'cacDocument': await formattedImage(uploadedDocuments
                .firstWhere((element) => element.type == 'cac')
                .file),
            'utilityBill': await formattedImage(uploadedDocuments
                .firstWhere((element) => element.type == 'bill')
                .file),
            'passport': await formattedImage(uploadedDocuments
                .firstWhere((element) => element.type == 'passport')
                .file),
            'businessId': localDataSource.getBusiness().id,
            'cacNumber': cac.text
          }
        : {
            'nin': await formattedImage(uploadedDocuments
                .firstWhere((element) => element.type == 'nin')
                .file),
            'utilityBill': await formattedImage(uploadedDocuments
                .firstWhere((element) => element.type == 'bill')
                .file),
            'passport': await formattedImage(uploadedDocuments
                .firstWhere((element) => element.type == 'passport')
                .file),
            'businessId': localDataSource.getBusiness().id,
          };

    //         FormData formData = FormData();

    // for (var entry in formdata.entries) {
    //   formData.fields.add(
    //     MapEntry(
    //       entry.key, // Field name
    //       (await MultipartFile.fromFile(
    //         entry.value.path,
    //         filename: entry.value.path.split('/').last,
    //       )).toString(),
    //     ),
    //   );
    // }

    try {
      _isLoading = true;
      notifyListeners();
      final response = await _authRepository.businessKyc(formdata);
      if (response.data['statusCode'] == 200 && context.mounted) {
        WayaHelpers.showNotice(
            context: context,
            title: 'KYC Documents Submitted \n Successfully',
            message:
                'Your documents are under review. We’ll notify you once the \n verification process is complete',
            onPress: () => WayaNav.toNamed("/explore"),
            icon: Image.asset('assets/images/auth/doc-success.png'),
            buttonText: 'Go To HomePage');
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

final addBusinessAccountProvider =
    ChangeNotifierProvider.autoDispose((ref) => AddBusinessAccountVm(ref));
