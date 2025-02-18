import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/moments/data/moment_helper/moment_helper_funcs.dart';
import 'package:wayagram/features/moments/data/repo/moment_repository.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:wayagram/features/moments/views/trim_video.dart';
import 'package:wayagram/shared/repo/upload_file_repository.dart';
import '../data/model/moment_state.dart';
import 'package:wayagram/core/utils/utils.dart';
import '../views/media_moment.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/features/moments/data/model/moment_viewer_response_model.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/features/moments/data/model/folllowed_user_moments_model.dart';

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
        )) {
    initializeUser();
  }

  void initializeUser() async {
    final userid = await _secureDataSource.getUserId();
    print("wewefw $userid");
    state = state.copyWith(userId: userid!);
  }

  void reset() {
    state = MomentState(
        backgroundColor: const Color(0xFF1D2939),
        textStyle: GoogleFonts.roboto(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        moments: state.moments,
        myMoments: state.myMoments);
  }

  void updateBackgroundColor(Color color) {
    state = state.copyWith(backgroundColor: color);
  }

  void updateTextStyle(TextStyle style) {
    state = state.copyWith(textStyle: style);
    print(style);
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

  // void updateComment(String comment) {
  //   state = state.copyWith(comment: comment, isComment: comment.isNotEmpty);
  // }

  // void toggleLiked() {
  //   state = state.copyWith(isLiked: !state.isLiked);
  // }

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
          if (mediaType == MediaType.video) {
            final videoFile = File(file.path!);
            final videoDuration = await _getVideoDuration(videoFile);

            if (videoDuration > 15) {
              final trimmedFile = await Navigator.push<File>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoTrimmerScreen(videoFile: videoFile),
                ),
              );

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
      print("Failed to pick media: $e");
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

  Future<void> submitMoment({required BuildContext context}) async {
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
      fontType = MomentHelper.textStyleToJson(textStyle);
      color = MomentHelper.colorToHex(backgroundColor);
    } else if (state.type == StatusType.media &&
        state.mediaType == MediaType.image) {
      // image
      contentType = 'image';
      if (state.selectedFile != null) {
        String? publicUrl = await WayaUtils.uploadFile(
            repository: _uploadFileRepository, file: selectedAsset!);

        if (publicUrl != null) {
          content = publicUrl;
        } else {
          // image uploading failed
          state = state.copyWith(isCreatingMoment: false);
        }
      } else if (state.mediaUrl != null) {
        content = state.mediaUrl!;
      }
    } else if (state.type == StatusType.media &&
        state.mediaType == MediaType.video) {
      contentType = 'video';
      if (state.selectedFile != null) {
        String? publicUrl = await WayaUtils.uploadFile(
            repository: _uploadFileRepository, file: selectedAsset!);

        if (publicUrl != null) {
          content = publicUrl;
        } else {
          // image uploading failed
          state = state.copyWith(isCreatingMoment: false);
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
      if (response.success && context.mounted) {
        reset();
        Navigator.pushReplacementNamed(context, MyMoments.route);
        // WayaNav.toNamed(MyMoments.route);
      }
    } catch (error) {
      print(error);
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
        moments.where((m) => m.active).toList();
        hasNextPage = responseModel.data.hasNextPage;
        state = state.copyWith(myMoments: moments);
      }

      return PaginatedResult(hasNextPage: hasNextPage, items: moments);
    } catch (error) {
      print(error);
      return null;
    } finally {
      state = state.copyWith(isLoadingUserMoments: false);
    }
  }

  void getMomentId(String mId) {
    state = state.copyWith(momentId: mId);
  }

  Future<PaginatedResult<MomentViewer>?> momentViewers(int page) async {
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
    } catch (error) {
      print(error);
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
    } catch (error) {
      print(error);
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
        Navigator.of(context).pop();
        await WayaUtils.showNotice(
            context: context,
            title: "Report Submitted Successfully",
            onPress: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              WayaAssets.images.eCheckEvent.path,
              scale: 1.5,
            ),
            message: 'Thank you for reporting. We take your feedback seriously',
            buttonText: 'Dismiss');
        print(response.data);
      }
    } catch (error) {
      print(error);
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
  //       print(response.data);
  //     }
  //   } catch (error) {
  //     print(error);
  //   }
  // }

// moments of the user I am follwing
  Future<void> getAllMoments() async {
    try {
      final response = await _momentRepository.getAllMoments();

      if (response.success) {
        FolllowedUserMomentsModel responseModel =
            FolllowedUserMomentsModel.fromJson(response.data);
        state = state.copyWith(moments: responseModel.data);
      }
    } catch (error) {
      print(error);
    }
  }

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
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        mediaUrl: moment.contentType != 'text' ? moment.content : '');

    if (moment.contentType != 'text') {
      WayaNav.toNamed(MediaMoment.route);
    }
  }
}

final momentVmProvider = StateNotifierProvider<MomentVm, MomentState>((ref) {
  return MomentVm(
      UploadFileRepository(), WayaSecureDataSource(), MomentRepository(), ref);
});
