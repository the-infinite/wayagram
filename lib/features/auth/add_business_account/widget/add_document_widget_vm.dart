import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddDocumentWidgetVm extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final Ref ref;

  AddDocumentWidgetVm(this.ref);

  Future<void> uploadFile(Function(File file) addFile, String? type) async {
    if (type != null && type == 'image') {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        addFile(file);
      } else {
        print('No image selected.');
      }
      notifyListeners();
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        addFile(file);
      } else {
        // User canceled the picker
        print('No image selected.');
      }
      notifyListeners();
    }
  }
}

final addDocumentWidgetProvider =
    ChangeNotifierProvider.autoDispose((ref) => AddDocumentWidgetVm(ref));
