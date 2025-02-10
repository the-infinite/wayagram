import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/moments/data/repo/moment_repository.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';
import '../data/model/moment_state.dart';
import 'package:wayagram/core/utils/utils.dart';
import '../views/media_moment.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MomentVm extends StateNotifier<MomentState> {
  final Ref ref;
  final MomentRepository _momentRepository;
  final WayaSecureDataSource _secureDataSource;
  final UploadFileRepository _uploadFileRepository;
  MomentVm(this._uploadFileRepository, this._secureDataSource,
      this._momentRepository, this.ref)
      : super(MomentState(
          backgroundColor: const Color(0xFF1D2939),
          textStyle: GoogleFonts.roboto(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ));

  void reset() {
    state = MomentState(
      backgroundColor: const Color(0xFF1D2939),
      textStyle: GoogleFonts.roboto(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void updateBackgroundColor(Color color) {
    state = state.copyWith(backgroundColor: color);
  }

  void updateTextStyle(TextStyle style) {
    state = state.copyWith(textStyle: style);
  }

  void updateText(String text) {
    state = state.copyWith(text: text);
  }

  void setStatusType(StatusType type) {
    state = state.copyWith(type: type);
  }

  void updateCaption(String caption) {
    state = state.copyWith(caption: caption);
  }

  void setSelectedFile(File? asset) {
    MediaType? mediaType;

    state = state.copyWith(
      selectedFile: asset,
      mediaType: mediaType,
    );
  }

  void setImagePickerState(bool isOpen) {
    state = state.copyWith(isImagePickerOpen: isOpen);
  }

  void clearImage() {
    state = state.copyWith(selectedFile: null, caption: '', mediaType: null);
  }

  void toggleCaptionVisibility() {
    state = state.copyWith(showCaption: !state.showCaption);
  }

  void cycleBackgroundColor() {
    final colors = [
      const Color(0xFF1D2939),
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];

    final currentIndex = colors.indexOf(state.backgroundColor);
    final nextIndex = (currentIndex + 1) % colors.length;
    updateBackgroundColor(colors[nextIndex]);
  }

  void cycleFontStyle() {
    final fonts = [
      GoogleFonts.roboto(),
      GoogleFonts.playfairDisplay(),
      GoogleFonts.lobster(),
      GoogleFonts.pacifico(),
      GoogleFonts.permanentMarker(),
    ];

    final currentFont = state.textStyle.fontFamily;
    final currentIndex =
        fonts.indexWhere((font) => font.fontFamily == currentFont);
    final nextIndex = (currentIndex + 1) % fonts.length;

    updateTextStyle(fonts[nextIndex].copyWith(
      fontSize: 32,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ));
  }

  Future<void> pickMedia(BuildContext context) async {
    try {
      // Open file picker to select an image or video
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        MediaType? mediaType;
        if (file.extension == 'mp4' || file.extension == 'mov') {
          mediaType = MediaType.video;
        } else if (file.extension == 'jpg' ||
            file.extension == 'jpeg' ||
            file.extension == 'png') {
          mediaType = MediaType.image;
        }

        if (mediaType != null) {
          state = state.copyWith(
            selectedFile: File(file.path!),
            mediaType: mediaType,
            isImagePickerOpen: false,
          );

          WayaNav.toNamed(MediaMoment.route);
        } else {
          print('Unsupported file type: ${file.extension}');
        }
      } else {
        state = state.copyWith(
          type: StatusType.text,
          isImagePickerOpen: false,
        );
      }
    } catch (e) {
      // Handle any errors
      print("Failed to pick media");
    }
  }

  Future<void> cropImage(BuildContext context, WidgetRef ref) async {
    if (state.selectedFile == null || state.mediaType != MediaType.image)
      return;

    final file = state.selectedFile;
    if (file == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 100,
      maxWidth: 1080,
      maxHeight: 1920,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: false,
          statusBarColor: Colors.black,
          cropStyle: CropStyle.rectangle,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
          aspectRatioPickerButtonHidden: false,
          rotateButtonsHidden: false,
          resetButtonHidden: false,
          aspectRatioLockDimensionSwapEnabled: true,
          cropStyle: CropStyle.rectangle,
        ),
      ],
    );

    if (croppedFile != null) {
      // Convert cropped image
      state = state.copyWith(selectedFile: File(croppedFile.path));
    }
  }

  Future<void> submitMoment() async {
    final text = state.text;
    final backgroundColor = state.backgroundColor;
    final textStyle = state.textStyle;
    final selectedAsset = state.selectedFile;
    final caption = state.caption;
    final mediaType = state.mediaType;
    String content = '';
    String contentType = '';

    print('Submitting moment:');
    print('Text: $text');
    print('Background Color: $backgroundColor');
    print('Text Style: $textStyle');
    print('Media Type: $mediaType');
    print('Has Media: ${selectedAsset != null}');
    print('Caption: $caption');

    state = state.copyWith(isCreatingMoment: true);
    if (state.type == StatusType.text) {
      // text
      content = text;
      contentType = 'text';
    } else if (state.type == StatusType.media &&
        state.mediaType == MediaType.image) {
      // image
      contentType = 'image';
      String? publicUrl = await WayaUtils.uploadFile(
          repository: _uploadFileRepository, file: selectedAsset!);

      if (publicUrl != null) {
        print("ewwefewfwe $publicUrl $contentType");
        content = publicUrl;
      } else {
        // image uploading failed
        state = state.copyWith(isCreatingMoment: false);
      }
    }

    try {
      final userId = await _secureDataSource.getUserId();
      final userProfile =
          ref.watch(profileVmProvider).userAccountModel?.data?.userdata?.user;
      final response = await _momentRepository.createMoment(
          userId: userId!,
          name:
              "${userProfile?.firstName?.capitalizeFirst ?? ''} ${userProfile?.lastName?.capitalizeFirst ?? ''}",
          image: userProfile?.profilePicture,
          content: content,
          caption: caption,
          contentType: contentType);
      if (response.success) {
        print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isCreatingMoment: false);
    }
  }

  Future<void> getUserMoments() async {
    try {
      state = state.copyWith(isLoadingUserMoments: true);
      final userId = await _secureDataSource.getUserId();
      final response = await _momentRepository.getUserMoments(userId: userId!);

      if (response.success) {}
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isLoadingUserMoments: false);
    }
  }
}

final momentVmProvider = StateNotifierProvider<MomentVm, MomentState>((ref) {
  return MomentVm(
      UploadFileRepository(), WayaSecureDataSource(), MomentRepository(), ref);
});
