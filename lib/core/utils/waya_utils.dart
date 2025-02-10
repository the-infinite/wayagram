import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/model/base_model.dart';
import 'package:wayagram/shared/model/media_upload_model.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

import '../components/components.dart';

class WayaUtils {
  WayaUtils._();

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
    return showModalSheet(context,
        child: WayaNoticeModal(
          title: title,
          onPress: onPress,
          message: message,
          icon: icon,
          buttonText: buttonText,
          secondButtonCenterWidget: secondButtonCenterWidget,
          buttonCenterWidget: buttonCenterWidget,
          secondButtonText: secondButtonText,
          onCancel: onCancel,
        ));
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

  static Future<T?> showModalSheet<T>(BuildContext context,
      {required Widget child}) {
    return showModalBottomSheet<T?>(
      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) => child,
    );
  }

  static showModalSheetUgt(BuildContext context, {required Widget child}) {
    return showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      /*isDismissible: true,
        enableDrag: false,*/
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) => child,
    );
  }

  static showModalSheetQuotation(BuildContext context,
      {required Widget child}) {
    return showModalBottomSheet(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
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
    if (image != null) {
      return cropImage(image);
    }
    return image;
  }

  static Future<File> cropImage(File pickedImage) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: WayaColors.primary,
          toolbarWidgetColor: WayaColors.white,
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

  static List<T> search<T extends BaseModel<T>>(
    List<T> data,
    List<String> accessorKeys,
    String searchTerm,
  ) {
    if (searchTerm.isEmpty) {
      return data;
    }

    return data.where((item) {
      final map = item.toMap();
      return accessorKeys.any((key) {
        final value = map[key];
        if (value is String) {
          return value.toLowerCase().contains(searchTerm.toLowerCase());
        }
        return false;
      });
    }).toList();
  }

  static Future<String?> uploadFile(
      {required UploadFileRepository repository, required File file}) async {
    String publicUrl = '';
    try {
      // filename and content-type
      String fileName = WayaHelpers.extractFileName(file);
      String? contentType = WayaHelpers.getContentType(file);

      final uploadUrlResponse =
          await repository.getUploadUrl(fileName: fileName);
      if (uploadUrlResponse.success) {
        MediaUploadModel uploadModel =
            MediaUploadModel.fromJson(uploadUrlResponse.data);

        final String url = uploadModel.data!.url!;
        publicUrl = uploadModel.data!.publicUrl!;
        await repository.putFile(
            url: url, file: file, contentType: contentType!);
      }

      return publicUrl;
    } catch (error) {
      return null;
    }
  }
}
