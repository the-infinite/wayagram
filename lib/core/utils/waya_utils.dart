import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/core/data/model/model.dart';import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../components/components.dart';

class WayaUtils {

   static Future<void> showNotice(
      {required BuildContext context,
      required String title,
      required String message,
      required VoidCallback onPress,
      required Widget icon,
      String? buttonText,
      String? secondButtonText,
      Widget? buttonCenterWidget,
      Widget? secondButtonCenterWidget,
      VoidCallback? onCancel}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WayaNoticeModal(
          title: title,
          onPress: onPress,
          message: message,
          icon: icon,
          buttonText: buttonText,
          secondButtonCenterWidget: secondButtonCenterWidget,
          buttonCenterWidget: buttonCenterWidget,
          secondButtonText: secondButtonText,
          onCancel: onCancel,
        );
      },
    );
  }

  static Future<Select> showSelectModal({
    required BuildContext context,
    required String title,
    required List<Select> items,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WayaBottomSheetContent(
          title: title,
          items: items,
        );
      },
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: Navigator.of(context),
      ),
    );
    return result;
  }

  static copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    WayaSnackBar.showToast('Copied');
  }

  static showModalSheet(BuildContext context, {required Widget child}) {
    return showModalBottomSheet(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
        builder: (context) => child);
  }

  static Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final filePath = File(pickedFile.path);

      return filePath;
    } else {
      return null;
    }
  }

  static Future<File?> pickAndCropImage() async {
    final image = await pickImageFromGallery();
    // if (image != null) {
    //   return cropImage(image);
    // }
    return image;
  }

  static Future<File> cropImage(File pickedImage) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return pickedImage;
    }
  }
}
