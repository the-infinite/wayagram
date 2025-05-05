// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/moments/data/moment_helper/moment_helper_funcs.dart';
import 'package:wayagram/features/moments/data/repo/moment_repository.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:wayagram/features/moments/views/trim_video.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import '../data/model/moment_state.dart';
import 'package:wayagram/core/utils/utils.dart';
import '../views/media_moment.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/features/moments/data/model/moment_viewer_response_model.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class MomentVm extends StateNotifier<MomentState> {
  final Ref ref;
  final MomentRepository _momentRepository;
  final WayaSecureDataSource _secureDataSource;
  MomentVm(this._secureDataSource, this._momentRepository, this.ref)
      : super(MomentState(
          backgroundColor: const Color(0xFF1D2939),
          textStyle: GoogleFonts.roboto(
            fontSize: 32.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        )) {
    initializeUser();
  }

  void initializeUser() async {
    final userid = await _secureDataSource.getUserId();
    state = state.copyWith(userId: userid!);
  }

  void reset() {
    state = MomentState(
      backgroundColor: const Color(0xFF1D2939),
      textStyle: GoogleFonts.roboto(
        fontSize: 32.sp,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      myMoments: state.myMoments,
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
      fontSize: 32.sp,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ));
  }

  Future<void> pickMedia(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      //? This i sfor the case as it might be.
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        MediaType? mediaType;

        //? This is for videos.
        if (WayaFileExtensions.videos.contains(file.extension)) {
          mediaType = MediaType.video;
        }

        //? This is for images.
        else if (WayaFileExtensions.images.contains(file.extension)) {
          mediaType = MediaType.image;
        }

        //? If this is set...
        if (mediaType != null) {
          if (mediaType == MediaType.video) {
            final videoFile = File(file.path!);
            final videoDuration = await _getVideoDuration(videoFile);

            if (videoDuration > 30) {
              final trimmedFile =
                  await WayaNav.to(VideoTrimmerScreen(videoFile: videoFile));

              if (trimmedFile != null) {
                state = state.copyWith(
                  selectedFile: trimmedFile,
                  mediaType: mediaType,
                  isImagePickerOpen: false,
                );
                WayaNav.toNamed(MediaMoment.route);
              }
            } else {
              state = state.copyWith(
                selectedFile: videoFile,
                mediaType: mediaType,
                isImagePickerOpen: false,
              );
              WayaNav.toNamed(MediaMoment.route);
            }
          } else {
            state = state.copyWith(
              selectedFile: File(file.path!),
              mediaType: mediaType,
              isImagePickerOpen: false,
            );
            WayaNav.toNamed(MediaMoment.route);
          }
        }

        //? This is fine.
        else {
          WayaUtils.showModalSheet(context,
              child: WayaErrorDialog(
                  title: 'Unsupported file type: ${file.extension}'));
        }
      } else {
        state = state.copyWith(
          type: StatusType.text,
          isImagePickerOpen: false,
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<int> _getVideoDuration(File videoFile) async {
    final videoPlayerController = VideoPlayerController.file(videoFile);
    await videoPlayerController.initialize();
    final duration = videoPlayerController.value.duration.inSeconds;
    await videoPlayerController.dispose();
    return duration;
  }

  Future<void> cropImage(BuildContext context, WidgetRef ref) async {
    if (state.selectedFile == null || state.mediaType != MediaType.image) {
      return;
    }

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

//> generate image preview
  Future<File> generateImagePreview(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    final thumbnail = img.copyResize(image!, width: 150);
    final previewFile = File(
        '${imageFile.path}_preview.${WayaFileHelper.getFileExtension(imageFile.path)}');
    await previewFile.writeAsBytes(img.encodeJpg(thumbnail, quality: 60));

    return previewFile;
  }

//> generate video preview
  Future<File?> generateVideoPreview(String videoPath) async {
    final thumb = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      quality: 60,
    );

    return thumb != null ? File(thumb) : null;
  }

//> generate text preview
  Future<Uint8List?> captureTextMomentPreview(GlobalKey previewKey) async {
    RenderRepaintBoundary boundary =
        previewKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    if (boundary.debugNeedsPaint) {
      await Future.delayed(Duration(milliseconds: 20));
      return captureTextMomentPreview(previewKey);
    }

    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> submitMoment(
      {required BuildContext context,
      GlobalKey<State<StatefulWidget>>? previewKey}) async {
    final text = state.text;
    final backgroundColor = state.backgroundColor;
    final textStyle = state.textStyle;
    final selectedAsset = state.selectedFile;
    final caption = state.caption;
    final mediaType = state.mediaType;
    String content = '';
    String contentType = '';
    String color = '';
    String fontType = '';

    debugPrint('Submitting moment:');
    debugPrint('Text: $text');
    debugPrint('Background Color: $backgroundColor');
    debugPrint('Text Style: $textStyle');
    debugPrint('Media Type: $mediaType');
    debugPrint('Has Media: ${selectedAsset != null}');
    debugPrint('Caption: $caption');

    state = state.copyWith(isCreatingMoment: true);
    if (state.type == StatusType.text) {
      // text
      content = text;
      contentType = 'text';
      fontType = MomentHelper.textStyleToJson(textStyle);
      color = MomentHelper.colorToHex(backgroundColor);

      if (previewKey != null) {
        final previewBytes = await captureTextMomentPreview(previewKey);
        if (previewBytes != null) {
          final tempDir = await getTemporaryDirectory();
          final fileName =
              '${ConversationState.self.id}-${DateTime.now().millisecondsSinceEpoch}_text_preview.png';
          final filePath = path.join(tempDir.path, fileName);

          final textPreviewFile =
              await File(filePath).writeAsBytes(previewBytes);
        }
      }
    } else if (state.type == StatusType.media &&
        state.mediaType == MediaType.image) {
      contentType = 'image';
      // image
      if (state.selectedFile != null) {
        final publicUrl = await WayaFileRepository.instance.uploadFile(
          selectedAsset!,
          "su-${ConversationState.self.id}-${DateTime.now().millisecondsSinceEpoch}${WayaFileHelper.getFileExtension(selectedAsset.path)}}",
        );
        //> get preview
        final preview = await generateImagePreview(state.selectedFile!);

        if (publicUrl != null) {
          content = publicUrl;
        } else {
          // image uploading failed
          state = state.copyWith(isCreatingMoment: false);
          return;
        }
      } else if (state.mediaUrl != null) {
        content = state.mediaUrl!;
      }
    } else if (state.type == StatusType.media &&
        state.mediaType == MediaType.video) {
      contentType = 'video';
      if (state.selectedFile != null) {
        final publicUrl = await WayaFileRepository.instance.uploadFile(
          selectedAsset!,
          "su-${ConversationState.self.id}-${DateTime.now().millisecondsSinceEpoch}${WayaFileHelper.getFileExtension(selectedAsset.path)}}",
        );
        //> get preview
        final preview = await generateVideoPreview(publicUrl ?? '');

        if (publicUrl != null) {
          content = publicUrl;
        } else {
          // image uploading failed
          state = state.copyWith(isCreatingMoment: false);
          return;
        }
      } else if (state.mediaUrl != null) {
        content = state.mediaUrl!;
      }
    }

    try {
      final userId = await _secureDataSource.getUserId();

      final userProfile =
          ref.watch(profileVmProvider).userAccountModel?.data?.userdata?.user;

      final response = state.isEditingMode
          ? await _momentRepository.editMoment(
              userId: userId!,
              name:
                  "${userProfile?.firstName.capitalizeFirst ?? ''} ${userProfile?.lastName.capitalizeFirst ?? ''}",
              image: userProfile?.profilePicture ?? '',
              content: content,
              caption: caption,
              color: color,
              momentId: state.momentId,
              fontType: fontType,
              contentType: contentType)
          : await _momentRepository.createMoment(
              userId: userId!,
              name:
                  "${userProfile?.firstName.capitalizeFirst ?? ''} ${userProfile?.lastName.capitalizeFirst ?? ''}",
              image: userProfile?.profilePicture ?? '',
              content: content,
              caption: caption,
              color: color,
              fontType: fontType,
              contentType: contentType);
      if (response.success) {
        reset();
        final momentData = MomentData.fromJson(response.data['data']);
        if (content.trim().isNotEmpty && selectedAsset != null) {
          final target = await WayaFileHelper.getMomentDirectory(
              momentData, "/x/x/$content");
          try {
            await selectedAsset.copy(target.path);
          } catch (e) {
            WayaDebugConsoleController.instance.addException(
              WayaDebugHelpers.getMessage(e),
              e,
              WayaDebugEventModule.moments,
              WayaDebugHelpers.getStackTrace(e),
            );
          }
        }
        WayaNav.removeUntilNamed(
          MyMoments.route,
          predicate: (route) => route.settings.name == BottomView.route,
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isCreatingMoment: false);
    }
  }

  Future<PaginatedResult<MomentData>?> getUserMoments(int page) async {
    try {
      state = state.copyWith(isLoadingUserMoments: true);
      final userId = await _secureDataSource.getUserId();
      final response =
          await _momentRepository.getUserMoments(userId: userId!, page: page);
      List<MomentData> moments = [];
      bool hasNextPage = false;
      if (response.success) {
        MomentResponseModel responseModel =
            MomentResponseModel.fromJson(response.data);

        moments = responseModel.data.docs;
        moments = moments.reversed.where((m) => m.active).toList();
        hasNextPage = responseModel.data.hasNextPage;
        state = state.copyWith(myMoments: moments);
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: moments);
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      state = state.copyWith(isLoadingUserMoments: false);
    }
  }

  void getMomentId(String mId) {
    state = state.copyWith(momentId: mId);
  }

  Future<PaginatedResult<MomentViewer>?> momentViewers(
      {required int page}) async {
    try {
      state = state.copyWith(isLoadingUserMoments: true);

      final response = await _momentRepository.momentViewers(
          momentId: state.momentId, page: page);
      List<MomentViewer> momentViewers = [];
      bool hasNextPage = false;
      if (response.success) {
        MomentViewerResponseModel responseModel =
            MomentViewerResponseModel.fromJson(response.data);
        List<MomentViewer> viewers = responseModel.data.docs;
        hasNextPage = responseModel.data.hasNextPage;
        for (MomentViewer viewer in viewers) {
          final detail = await UserResource.getUserDetails(viewer.userId);
          if (detail == null) continue;
          final user = detail.$1;
          final profile = detail.$2;
          viewer = viewer.copyWith(
            name:
                "${user.firstName.capitalizeFirst} ${user.lastName.capitalizeFirst}",
            username: "${profile.username}",
            image: user.profilePicture,
          );

          momentViewers.add(viewer);
        }
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: momentViewers);
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
      return null;
    } finally {
      state = state.copyWith(isLoadingUserMoments: false);
    }
  }

  Future<void> deleteMoment(String momentId) async {
    try {
      final response = await _momentRepository.deleteMoment(momentId);

      if (response.success) {
        WayaSnackBar.showToast("Moment Deleted Successfully");

        List<MomentData> moments = List.from(state.myMoments);
        moments.where((m) => m.id != momentId).toList();

        state = state.copyWith(
            myMoments: moments.where((m) => m.id != momentId).toList());
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<MomentData?> getSingleMoment(String id) async {
    try {
      final response = await _momentRepository.getSingleMoment(id: id);
      List<MomentData>? moments;
      if (response.success) {
        MomentResponseModel responseModel =
            MomentResponseModel.fromJson(response.data);

        moments = responseModel.data.docs;
      }

      return moments?[0];
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<void> reportMoment(
      {required String momentId,
      required String reason,
      String? comment,
      required BuildContext context}) async {
    try {
      state = state.copyWith(isReportingMoment: true);
      final userId = await _secureDataSource.getUserId();
      final response = await _momentRepository.reportMoment(
          userId: userId!, momentId: momentId, reason: reason);
      if (response.success && context.mounted) {
        // show success modal
        WayaNav.goBack();
        await WayaUtils.showNotice(
            context: context,
            title: "Report Submitted Successfully",
            onPress: () {
              WayaNav.goBack();
            },
            icon: Image.asset(
              WayaAssets.images.eCheckEvent.path,
              scale: 1.5,
            ),
            message: 'Thank you for reporting. We take your feedback seriously',
            buttonText: 'Dismiss');
        debugPrint(response.data.toString());
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isReportingMoment: false);
    }
  }

  // Future<void> postSingleUserMoment({required MomentData moment}) async {
  //   try {
  //     final profileId = await _secureDataSource.getUserId();
  //     if (profileId == moment.userId) return;
  //     final response = await _momentRepository.viewMoments(
  //         profileId: profileId!,
  //         momentId: moment.id,
  //         likeMoment: state.isLiked,
  //         comment: state.isComment);

  //     if (response.success) {
  //       debugPrint(response.data.toString());
  //     }
  //   } catch (error) {
  //     debugPrint(error.toString());
  //   }
  // }

  void initializeEditMoment(MomentData moment) async {
    state = state.copyWith(
        isEditingMode: true,
        caption: moment.caption,
        showCaption:
            moment.caption != null && moment.caption!.isNotEmpty ? true : false,
        momentId: moment.id,
        selectedFile: null,
        type: moment.contentType == 'text' ? StatusType.text : StatusType.media,
        mediaType:
            moment.content == 'video' ? MediaType.video : MediaType.image,
        backgroundColor: moment.color != null && moment.color!.isNotEmpty
            ? MomentHelper.hexToColor(moment.color!)
            : null,
        text: moment.contentType == 'text' ? moment.content : '',
        textStyle: moment.fontType != null && moment.fontType!.isNotEmpty
            ? MomentHelper.textStyleFromJson(moment.fontType!)
            : GoogleFonts.roboto(
                fontSize: 32.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        mediaUrl: moment.contentType != 'text' ? moment.content : '');

    if (moment.contentType != 'text') {
      WayaNav.toNamed(MediaMoment.route);
    }
  }

  bool hasViewedMoment(String id) {
    return WayaLocalDataSource.instance.getViewedMoments()?.contains(id) ??
        false;
  }
}

final momentVmProvider = StateNotifierProvider<MomentVm, MomentState>((ref) {
  return MomentVm(WayaSecureDataSource(), MomentRepository(), ref);
});
