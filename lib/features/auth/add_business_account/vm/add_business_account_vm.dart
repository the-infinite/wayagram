import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/repos/auth/auth_repository.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

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
    final formData = FormData.fromMap({
      'nin': await MultipartFile.fromFile(_uploadedDocuments
          .firstWhere((element) => element.type == 'nin')
          .file
          .path),
      'cacDocument': await MultipartFile.fromFile(_uploadedDocuments
          .firstWhere((element) => element.type == 'cac')
          .file
          .path),
      'utilityBill': await MultipartFile.fromFile(_uploadedDocuments
          .firstWhere((element) => element.type == 'bill')
          .file
          .path),
      'passport': await MultipartFile.fromFile(_uploadedDocuments
          .firstWhere((element) => element.type == 'passport')
          .file
          .path),
      'businessId': localDataSource.getSelectedBusinessType().value,
      'cacNumber': cac.text
    });

    try {
      _isLoading = true;
      notifyListeners();
      final response = await _authRepository.businessKyc(formData);
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
