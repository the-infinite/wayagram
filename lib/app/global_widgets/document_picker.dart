import 'dart:io';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'overlays.dart';

/// DocumentSaver saves [File] found on filepath to
/// the platform document directory.
class DocumentSaver {
  static const String eventImagePath = "/events";
  static const String idImagePath = "/ids";

  /// [savePermanently] permanently saves the file found in [filepath]
  /// into the Platform's Document directory, like this:
  /// PlatformDocumentDirectory/savePath/renameTo.fileExtension.
  /// [savePath] can be any of the static const String in [DocumentSaver].
  /// [storageKey] is any of [StorageKey] static members,
  /// to specify the key with which this file can be accessed
  /// If [savePath] is empty, the document is saved in the root of Platform's Document directory.
  /// If operation is not successful, [savePermanently] throws an error/exception.
/*   static Future<bool> savePermanently(
      {required String filepath,
      required String renameTo,
      required String storageKey,
      String savePath = ""}) async {
    try {
      await Permission.storage.request();
      final path = await _localPath;
      File file = File.fromUri(Uri.file(filepath));
      file = await file
          .copy('$path$savePath/$renameTo')
          .then((file) => file.create(recursive: true));
      if (file.path == path) {
        LocalStorage()
            .saveString(key: StorageKey.profilePicsUrl, value: file.path);

        return false;
      } else
        return true;
    } catch (ex) {
      rethrow;
    }
  }
 */
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

/// Images picked using the camera are saved to your application's local cache, and should therefore be expected to only
/// be around temporarily. If you require your picked image to be stored permanently, use [DocumentSaver.save]
class DocumentPicker extends StatefulWidget {
  final double renderHeight;
  final double renderWidth;
  final String actionWord;
  final double radius;
  final dynamic controller;

  /// if [networkImage] is not null,
  /// then [DocumentPicker] will display the
  /// image fetched through the url specified by [networkImage]
  final String? networkImage;

  /// if [displayPickedImage] is false, picked document path is displayed instead
  final bool displayPickedImage;
  final Function(
    String imagePath,
    String base64Image,
  ) onSelected;

  const DocumentPicker({
    this.networkImage,
    required this.renderHeight,
    required this.renderWidth,
    this.radius = 5,
    required this.onSelected,
    this.displayPickedImage = true,
    required this.actionWord,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _DocumentPickerState createState() => _DocumentPickerState();
}

class DocumentEventPicker extends StatefulWidget {
  final double renderHeight;
  final double renderWidth;
  final String actionWord;
  final double radius;
  final dynamic controller;

  /// if [networkImage] is not null,
  /// then [DocumentPicker] will display the
  /// image fetched through the url specified by [networkImage]
  final String? networkImage;

  /// if [displayPickedImage] is false, picked document path is displayed instead
  final bool displayPickedImage;
  final Function(
      String imagePath,
      String base64Image,
      ) onSelected;

  const DocumentEventPicker({
    this.networkImage,
    required this.renderHeight,
    required this.renderWidth,
    this.radius = 5,
    required this.onSelected,
    this.displayPickedImage = true,
    required this.actionWord,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _DocumentEventPickerState createState() => _DocumentEventPickerState();
}

class DocumentVenuePicker extends StatefulWidget {
  final double renderHeight;
  final double renderWidth;
  final String actionWord;
  final double radius;
  final dynamic controller;

  /// if [networkImage] is not null,
  /// then [DocumentPicker] will display the
  /// image fetched through the url specified by [networkImage]
  final String? networkImage;

  /// if [displayPickedImage] is false, picked document path is displayed instead
  final bool displayPickedImage;
  final Function(
      String imagePath,
      String base64Image,
      ) onSelected;

  const DocumentVenuePicker({
    this.networkImage,
    required this.renderHeight,
    required this.renderWidth,
    this.radius = 5,
    required this.onSelected,
    this.displayPickedImage = true,
    required this.actionWord,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _DocumentVenuePickerState createState() => _DocumentVenuePickerState();
}


class _DocumentPickerState extends State<DocumentPicker> {
  String _path = "";
  late XFile? _pickedFile = XFile(_path);
  final ImagePicker _imagePicker = ImagePicker();

  _DocumentPickerState();

  @override
  Widget build(BuildContext context) {
    final Widget choosePhotoPrompt =
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(CupertinoIcons.cloud_upload, size: 45, color: Colors.white),
      const SizedBox(height: 5),
      Text(
        widget.actionWord,
        textAlign: TextAlign.center,
        style: AppTextStyle.bodyText2
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
      )
    ]);
    return GestureDetector(
      onTap: () => _onPressed(),
      child: Container(
        height: widget.renderHeight,
        width: widget.renderWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: !widget.displayPickedImage
            ? Text(
                _path.isEmpty ? widget.actionWord : _path.split("/").last,
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyText2,
              )
            : _path.isEmpty && widget.networkImage != null
                ? CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: widget.networkImage ?? "",
                    placeholder: (context, url) => Container(
                      color: AppColors.grey,
                    ),
                    height: widget.renderHeight,
                    width: widget.renderWidth,
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/no_image.jpg",
                      height: widget.renderHeight,
                      fit: BoxFit.contain,
                      width: widget.renderWidth,
                    ),
                  )
                : _path.isEmpty && widget.networkImage == null
                    ? choosePhotoPrompt
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.file(
                          File(widget.controller == null ?_pickedFile!.path: widget.controller!.passport),
                          fit: BoxFit.contain,
                          height: widget.renderHeight,
                          width: widget.renderWidth,
                        ),
                      ),
      ),
    );
  }

  void _onPressed() {
    AppOverlay.showActionDialog(
        title: widget.actionWord,
        content: "",
        actions: {
          "Camera": _fromCamera,
          "Gallery": _fromGallery,
          "Cancel": Get.back
        });
  }

  void _fromGallery() async {
    Get.back();
    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);

    if (pickedFile != null) {
      await pickedFile.readAsBytes();
      final List<int> rawBytes = File(pickedFile.path).readAsBytesSync();
      final String base64Image = base64Encode(rawBytes);
      widget.onSelected(
          pickedFile.path, "data:image/png;base64," + base64Image);
      _pickedFile = pickedFile;
      _path = pickedFile.path;
    }
  }

  void _fromCamera() async {
     Get.back();
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      final List<int> rawBytes = await pickedFile.readAsBytes();
      final String base64Image = base64Encode(rawBytes);

      widget.onSelected(pickedFile.path, 'data:image/jpeg;base64,$base64Image');

      _pickedFile = pickedFile;
      _path = pickedFile.path;
    }
  }
}


class _DocumentEventPickerState extends State<DocumentEventPicker> {
  String _path = "";
  late XFile? _pickedFile = XFile(_path);
  final ImagePicker _imagePicker = ImagePicker();

  _DocumentEventPickerState();

  @override
  Widget build(BuildContext context) {
    final Widget choosePhotoPrompt =
    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(CupertinoIcons.cloud_upload, size: 45, color: Colors.white),
      const SizedBox(height: 5),
      Text(
        widget.actionWord,
        textAlign: TextAlign.center,
        style: AppTextStyle.bodyText2
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
      )
    ]);
    return GestureDetector(
      onTap: () => _onPressed(),
      child: Container(
        height: widget.renderHeight,
        width: widget.renderWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: !widget.displayPickedImage
            ? Text(
          _path.isEmpty ? widget.actionWord : _path.split("/").last,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyText2,
        )
            : _path.isEmpty && widget.networkImage != null
            ? CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: widget.networkImage ?? "",
          placeholder: (context, url) => Container(
            color: AppColors.grey,
          ),
          height: widget.renderHeight,
          width: widget.renderWidth,
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/no_image.jpg",
            height: widget.renderHeight,
            fit: BoxFit.contain,
            width: widget.renderWidth,
          ),
        )
            : _path.isEmpty && widget.networkImage == null
            ? choosePhotoPrompt
            : ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image.file(
            File(widget.controller == null ?_pickedFile!.path: widget.controller!.eventPath.toString()),
            fit: BoxFit.contain,
            height: widget.renderHeight,
            width: widget.renderWidth,
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    AppOverlay.showActionDialog(
        title: widget.actionWord,
        content: "",
        actions: {
          "Camera": _fromCamera,
          "Gallery": _fromGallery,
          "Cancel": Get.back
        });
  }

  void _fromGallery() async {
    Get.back();
    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);

    if (pickedFile != null) {
      await pickedFile.readAsBytes();
      final List<int> rawBytes = File(pickedFile.path).readAsBytesSync();
      final String base64Image = base64Encode(rawBytes);
      widget.onSelected(
          pickedFile.path, "data:image/png;base64," + base64Image);
      _pickedFile = pickedFile;
      _path = pickedFile.path;
    }
  }

  void _fromCamera() async {
    Get.back();
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      final List<int> rawBytes = await pickedFile.readAsBytes();
      final String base64Image = base64Encode(rawBytes);

      widget.onSelected(pickedFile.path, 'data:image/jpeg;base64,$base64Image');

      _pickedFile = pickedFile;
      _path = pickedFile.path;
    }
  }
}

class _DocumentVenuePickerState extends State<DocumentVenuePicker> {
  String _path = "";
  late XFile? _pickedFile = XFile(_path);
  final ImagePicker _imagePicker = ImagePicker();

  _DocumentVenuePickerState();

  @override
  Widget build(BuildContext context) {
    final Widget choosePhotoPrompt =
    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(CupertinoIcons.cloud_upload, size: 45, color: Colors.white),
      const SizedBox(height: 5),
      Text(
        widget.actionWord,
        textAlign: TextAlign.center,
        style: AppTextStyle.bodyText2
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
      )
    ]);
    return GestureDetector(
      onTap: () => _onPressed(),
      child: Container(
        height: widget.renderHeight,
        width: widget.renderWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: !widget.displayPickedImage
            ? Text(
          _path.isEmpty ? widget.actionWord : _path.split("/").last,
          textAlign: TextAlign.center,
          style: AppTextStyle.bodyText2,
        )
            : _path.isEmpty && widget.networkImage != null
            ? CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: widget.networkImage ?? "",
          placeholder: (context, url) => Container(
            color: AppColors.grey,
          ),
          height: widget.renderHeight,
          width: widget.renderWidth,
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/no_image.jpg",
            height: widget.renderHeight,
            fit: BoxFit.contain,
            width: widget.renderWidth,
          ),
        )
            : _path.isEmpty && widget.networkImage == null
            ? choosePhotoPrompt
            : ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image.file(
            File(widget.controller == null ?_pickedFile!.path: widget.controller!.venuePath.toString()),
            fit: BoxFit.contain,
            height: widget.renderHeight,
            width: widget.renderWidth,
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    AppOverlay.showActionDialog(
        title: widget.actionWord,
        content: "",
        actions: {
          "Camera": _fromCamera,
          "Gallery": _fromGallery,
          "Cancel": Get.back
        });
  }

  void _fromGallery() async {
    Get.back();
    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);

    if (pickedFile != null) {
      await pickedFile.readAsBytes();
      final List<int> rawBytes = File(pickedFile.path).readAsBytesSync();
      final String base64Image = base64Encode(rawBytes);
      widget.onSelected(
          pickedFile.path, "data:image/png;base64," + base64Image);
      _pickedFile = pickedFile;
      _path = pickedFile.path;
    }
  }

  void _fromCamera() async {
    Get.back();
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      final List<int> rawBytes = await pickedFile.readAsBytes();
      final String base64Image = base64Encode(rawBytes);

      widget.onSelected(pickedFile.path, 'data:image/jpeg;base64,$base64Image');

      _pickedFile = pickedFile;
      _path = pickedFile.path;
    }
  }
}
