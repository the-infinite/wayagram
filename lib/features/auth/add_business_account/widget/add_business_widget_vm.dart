import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBusinessWidgetVm extends ChangeNotifier {
  final Ref ref;

  AddBusinessWidgetVm(this.ref);

  void uploadFile(Function(File file) addFile) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);

      addFile(file);
    } else {
      // User canceled the picker
    }
  }
}
