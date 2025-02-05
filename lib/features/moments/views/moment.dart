import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/data/model/moment_state.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';

class Moment extends ConsumerWidget {
  static const route = "/moment";
  const Moment({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref
          .read(momentVmProvider.notifier)
          .setSelectedImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(
      BuildContext context, WidgetRef ref, File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
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
      ref
          .read(momentVmProvider.notifier)
          .setSelectedImage(File(croppedFile.path));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(momentVmProvider);
    final wayaTheme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: status.type == StatusType.media
              ? wayaTheme.colorScheme.black
              : status.backgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: wayaTheme.colorScheme.white,
                        size: 22,
                      ),
                      onPressed: () => WayaNav.goBack(),
                    ),
                    const Spacer(),
                    if (status.type == StatusType.text) ...[
                      IconButton(
                        icon:
                            SvgPicture.asset(WayaAssets.icons.cColorType.path),
                        onPressed: () {
                          ref
                              .read(momentVmProvider.notifier)
                              .cycleBackgroundColor();
                        },
                      ),
                      IconButton(
                        icon:
                            SvgPicture.asset(WayaAssets.icons.cFontStyle.path),
                        onPressed: () {
                          ref.read(momentVmProvider.notifier).cycleFontStyle();
                        },
                      ),
                    ] else if (status.type == StatusType.media) ...[
                      IconButton(
                        icon: Icon(Icons.crop_rotate,
                            color: wayaTheme.colorScheme.white),
                        onPressed: () =>
                            {_cropImage(context, ref, status.selectedImage!)},
                      ),
                      IconButton(
                        icon:
                            SvgPicture.asset(WayaAssets.icons.cFontStyle.path),
                        onPressed: () {
                          ref
                              .read(momentVmProvider.notifier)
                              .toggleCaptionVisibility();
                        },
                      ),
                    ]
                  ],
                ),
              ),
              Expanded(
                  child: status.type == StatusType.text
                      ? textMoment(context: context, ref: ref, status: status)
                      : mediaMoment(
                          context: context,
                          ref: ref,
                          status: status,
                        )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: wayaTheme.colorScheme.white.withOpacity(0.1),
                ),
                child: status.text.isNotEmpty
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: WayaButton(
                            height: 36,
                            radius: 36,
                            callback: () {
                              ref
                                  .read(momentVmProvider.notifier)
                                  .submitMoment();
                            },
                            centerWidget: Center(
                              child: SvgPicture.asset(
                                  WayaAssets.icons.aMoment.path),
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _TabButton(
                            label: 'Text',
                            isSelected: status.type == StatusType.text,
                            onTap: () {
                              ref
                                  .read(momentVmProvider.notifier)
                                  .setStatusType(StatusType.text);
                              ref
                                  .read(momentVmProvider.notifier)
                                  .setSelectedImage(null);
                            },
                          ),
                          _TabButton(
                            label: 'Media',
                            isSelected: status.type == StatusType.media,
                            onTap: () {
                              ref
                                  .read(momentVmProvider.notifier)
                                  .setStatusType(StatusType.media);
                              _pickImage(context, ref);
                            },
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textMoment(
      {required BuildContext context,
      required WidgetRef ref,
      required MomentState status}) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // keyboard
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: TextField(
          style: status.textStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
            hintText: 'Type your moment',
            hintStyle: status.textStyle.copyWith(
              color: wayaTheme.colorScheme.white.withOpacity(0.5),
            ),
          ),
          textAlign: TextAlign.center,
          maxLines: null,
          maxLength: 100,
          onChanged: (value) {
            ref.read(momentVmProvider.notifier).updateText(value);
          },
          onSubmitted: (value) {
            ref.read(momentVmProvider.notifier).submitMoment();
          },
        ),
      ),
    );
  }

  Widget mediaMoment({
    required BuildContext context,
    required WidgetRef ref,
    required MomentState status,
  }) {
    final wayaTheme = Theme.of(context);
    if (status.selectedImage == null) {
      return Center(
        child: Text(
          'Select Image',
          style: TextStyle(color: wayaTheme.colorScheme.customBlack),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        Center(
          child: SizedBox(
            height: context.height * 0.5,
            width: double.infinity,
            child: Image.file(
              status.selectedImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Caption
        if (status.showCaption)
          Positioned(
            left: 16,
            right: 16,
            top: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                style: status.textStyle.copyWith(
                    fontSize: 18, color: wayaTheme.colorScheme.customPrimary),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a caption...',
                  hintStyle: status.textStyle.copyWith(
                    fontSize: 18,
                    color: wayaTheme.colorScheme.greyColor300,
                  ),
                ),
                onChanged: (value) {
                  ref.read(momentVmProvider.notifier).updateCaption(value);
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Expanded(
      child: Material(
        color: wayaTheme.colorScheme.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? wayaTheme.colorScheme.white
                    : wayaTheme.colorScheme.white.withOpacity(0.5),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
