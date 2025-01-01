import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class DocType {
  final File file;
  final String name;
  final String type;

  DocType({required this.file, required this.type, required this.name});
}

class AddBusinessAccountVm extends ChangeNotifier {
  String _isSelected = '';
  final TextEditingController businessName = TextEditingController();
  final TextEditingController businessAddress = TextEditingController();
  final TextEditingController cac = TextEditingController();
  List<DocType> _uploadedDocuments = [];
  bool _isButtonEnabled = false;

  final Ref ref;

  AddBusinessAccountVm(this.ref);

  List<DocType> get uploadedDocuments => _uploadedDocuments;
  String get isSelected => _isSelected;
  bool get isButtonEnabled => _isButtonEnabled;

  void selectType(String type) {
    _isSelected = type;
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
    _uploadedDocuments.where((doc) => doc.type == type).toList();
    notifyListeners();
  }

  void validateInputs() {
    if (_isSelected == 'WITH-CAC') {
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

  void submit(BuildContext context) {
    WayaHelpers.showNotice(
        context: context,
        title: 'KYC Documents Submitted \n Successfully',
        message:
            'Your documents are under review. We’ll notify you once the \n verification process is complete',
        onPress: () => WayaNav.toNamed("/explore"),
        icon: Image.asset('assets/images/auth/doc-success.png'),
        buttonText: 'Go To HomePage');
  }
}

final addBusinessAccountProvider =
    ChangeNotifierProvider.autoDispose((ref) => AddBusinessAccountVm(ref));
