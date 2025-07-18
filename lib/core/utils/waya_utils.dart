import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/model/base_model.dart';
import 'package:wayagram/shared/model/media_upload_model.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';

import '../components/components.dart';

class WayaUtils {
  WayaUtils._();

  static Future<T?> showNotice<T>({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onPress,
    required Widget icon,
    ValueNotifier<bool>? actionNotifier,
    String? buttonText,
    Color? buttonColor,
    String? secondButtonText,
    Widget? buttonLeadingWidget,
    Widget? buttonCenterWidget,
    Widget? secondButtonCenterWidget,
    bool isDismissible = true,
    VoidCallback? onCancel,
  }) {
    final notifier = actionNotifier ?? ValueNotifier(false);
    return showModalSheet<T>(
      context,
      isDismissible: isDismissible,
      child: WayaNoticeModal(
        title: title,
        onPress: onPress ?? () => {},
        message: message,
        icon: icon,
        actionNotifier: notifier,
        buttonText: buttonText,
        leadingIcon: buttonLeadingWidget,
        buttonColor: buttonColor,
        secondButtonCenterWidget: secondButtonCenterWidget,
        buttonCenterWidget: buttonCenterWidget,
        secondButtonText: secondButtonText,
        onCancel: onCancel,
      ),
    ).then((result) {
      //? Don't forget to dispose your popups.
      if (actionNotifier == null) {
        notifier.dispose();
      }

      return result;
    });
  }

  static Future<List<Select>> showSelectModal({
    required BuildContext context,
    required String title,
    String? subTitle,
    double? contextHeight,
    required List<Select> items,
    List<Select>? selectedItems,
    bool multi = false,
  }) async {
    final result = await showModalSheet(
      context,
      isDismissible: !multi,
      child: WayaBottomSheetContent(
        title: title,
        items: items,
        contextHeight: contextHeight,
        subTitle: subTitle,
        selectedItems: selectedItems,
        multi: multi,
      ),
    );

    return result ?? [];
  }

  static copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    WayaSnackBar.showToast('Copied');
  }

  static Future<T?> showModalSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    Color? backgroundColor,
  }) {
    // Get the theme.
    final theme = Theme.of(context);

    // Return the modal.
    return Get.bottomSheet(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        child: child,
      ),
      backgroundColor: backgroundColor ?? theme.colorScheme.scaffoldColor2,
      isScrollControlled: true,
      isDismissible: isDismissible,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    );
  }

  static showModalSheetUgt(BuildContext context, {required Widget child}) {
    // Get the theme.
    final theme = Theme.of(context);

    // Return the modal.
    return Get.bottomSheet(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        child: child,
      ),
      backgroundColor: theme.colorScheme.scaffoldColor2,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    );
  }

  static showModalSheetQuotation(BuildContext context,
      {required Widget child}) {
    // Get the theme.
    final theme = Theme.of(context);

    // Return the modal.
    return Get.bottomSheet(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        child: child,
      ),
      backgroundColor: theme.colorScheme.scaffoldColor2,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    );
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

  static Future<File?> pickAndCropImage(
      [double ratioX = 1, double ratioY = 1]) async {
    final image = await pickImageFromGallery();
    if (image != null) {
      return cropImage(image, ratioX, ratioY);
    }
    return image;
  }

  static Future<File> cropImage(File pickedImage,
      [double ratioX = 1, double ratioY = 1]) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatio: CropAspectRatio(
        ratioX: ratioX,
        ratioY: ratioY,
      ),
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

    //? Check if the user has cancelled the cropping
    if (croppedFile != null) {
      return File(croppedFile.path);
    }

    //? Return the original image if cropping is cancelled
    else {
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
        } else if (value is List<String>) {
          return value.any((element) =>
              element.toLowerCase().contains(searchTerm.toLowerCase()));
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

  static List<T> strictSearch<T extends BaseModel<T>>(
    List<T> data,
    List<String> accessorKeys,
    String searchTerm, {
    List<List<String>>? combinedFields,
  }) {
   
    if (searchTerm.isEmpty) {
      return [];
    }
    

    final lowerSearchTerm = searchTerm.toLowerCase();

    final filteredData = data.where((item) {
      final map = item.toMap();

      final hasMatchInIndividualFields = accessorKeys.any((key) {
          print("accessorKeys $accessorKeys ");
        final value = map[key];
      
        return _checkValueMatch(value, lowerSearchTerm);
      });

      if (hasMatchInIndividualFields) return true;

      if (combinedFields != null) {
        for (final fieldGroup in combinedFields) {
          final combinedValue = fieldGroup.map((key) {
            final value = map[key];
            if (value is String) {
              return value;
            } else if (value is List<String>) {
              return value.join(' ');
            }
            return '';
          }).join(' ');

          if (combinedValue.toLowerCase().contains(lowerSearchTerm)) {
            return true;
          }
        }
      }

      return false;
    }).toList();

    return filteredData;
  }

  static bool _checkValueMatch(dynamic value, String lowerSearchTerm) {
    if (value == null) return false;

    if (value is String) {
      print("wefwefwefew yes string ");
      return value.toLowerCase().contains(lowerSearchTerm);
    }

    if (value is List) {
      print("wefwefwefew yes ");
      return value.any((element) {
        if (element is String) {
          return element.toLowerCase().contains(lowerSearchTerm);
        }
        return false;
      });
    }

    return false;
  }

  static String timeLeftUntil(String isoDate) {
    final targetDate = DateTime.parse(isoDate).toUtc();
    final now = DateTime.now().toUtc();
    final difference = targetDate.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} left';
    } else {
      return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'} left';
    }
  }
}
