import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

import 'waya_buttons.dart';
import 'waya_snackbar.dart';

class MultiImageController extends ValueNotifier<int> {
  final _images = <File>[];

  /// An iterable helper used to return an absolute list of all images inside of
  /// this controller.
  Iterable<File> get rawImages => _images;

  // Construct.
  MultiImageController([List<File>? defaultValues, super.value = 0]) {
    if (defaultValues?.isNotEmpty ?? false) {
      _images.addAll(defaultValues!);
    }
  }

  /// Utility function used to add an image to the list of images
  void _addImage(File image) {
    _images.add(image);
    value = value + 1;
  }

  /// Utility function used to clear all the images inside the controller.
  void _clearImages() {
    _images.clear();
    value = value + 1;
  }

  /// Utility function used to check if this is a duplicated image.
  bool _isDuplicateImage(File compare) {
    return _images.any((image) => image.absolute.path == compare.absolute.path);
  }

  /// Utility function used to remove an image from the list of images.
  void _removeImage(int index) {
    assert(index < _images.length, "Index is out of bounds");
    _images.removeAt(index);
    value = value + 1;
  }
}

class _SingleImagePicker extends StatelessWidget {
  final MultiImageController controller;
  final File file;
  final double height, width;
  final int index;
  final Color hintColor;
  final FormFieldState<List<File>> formState;

  // Construct.
  const _SingleImagePicker({
    required this.controller,
    required this.file,
    required this.height,
    required this.width,
    required this.index,
    required this.hintColor,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
    //? Get our theme.
    final wayaTheme = Theme.of(context);
    final insets = 45.w;

    //? The widget.
    return Container(
      width: max((width - insets) / controller._images.length, (width - insets) / 3),
      height: height,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(file),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        borderRadius: BorderRadius.circular(13.r),
        color: wayaTheme.colorScheme.greyColor100,
        border: Border.all(
          color: hintColor,
          width: 2.sp,
        ),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            controller._removeImage(index);
            formState.didChange(controller._images);
          },
          borderRadius: BorderRadius.circular(13.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.r),
            child: ColoredBox(
              color: wayaTheme.colorScheme.error,
              child: Padding(
                padding: EdgeInsets.all(10.dg),
                child: WayaAssets.icons.actonDismiss.svg(
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WayaMultiImagePicker extends StatelessWidget {
  final MultiImageController controller;
  final double width;
  final double imageHeight;
  final int maxImages, minImages;
  final String? helperText;
  final String? label;
  final String? Function(List<File>?)? validator;

  // Construct.
  const WayaMultiImagePicker({
    super.key,
    required this.controller,
    required this.imageHeight,
    required this.width,
    this.maxImages = 5,
    this.minImages = 1,
    this.label,
    this.helperText,
    this.validator,
  });

  /// Helper function used to choose the current picture.
  void _choosePhoto(BuildContext context, FormFieldState<List<File>> state) async {
    final picked = await WayaUtils.pickAndCropImage(16, 9);

    //? If this is null, leave.
    if (picked == null) {
      state.didChange(controller._images);
      WayaSnackBar.showToast("No image was selected");
      return;
    }

    //? If we found a duplicate image.
    if (controller._isDuplicateImage(picked)) {
      state.didChange(controller._images);
      WayaSnackBar.showToast("This image has already been selected");
      return;
    }

    //? If this changed, update value.
    controller._addImage(picked);
    state.didChange(controller._images);
  }

  @override
  Widget build(BuildContext context) {
    //? Our theme.
    final wayaTheme = Theme.of(context);
    final hintColor = wayaTheme.colorScheme.greyColor400;

    //? Paint this image.
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, redraws, _) => FormField<List<File>>(
        validator: (value) {
          final hasContents = value?.isNotEmpty ?? false;

          //? If this has too many images...
          if (hasContents && value!.length > maxImages) {
            return "At most $maxImages images are required";
          }

          //? If this has too little images.
          if (hasContents && value!.length < minImages) {
            return "At least $minImages images are required";
          }

          //? Then you can return the validator or a lack thereof.
          return validator?.call(value);
        },
        builder: (state) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //? For the label.
            if (label?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  label!,
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
                ),
              ),

            Center(
              child: DottedBorder(
                strokeWidth: 2.sp,
                dashPattern: [5.sp, 3.sp],
                padding: EdgeInsets.all(6.dg),
                radius: Radius.circular(13.r),
                borderType: BorderType.RRect,
                color: hintColor,
                child: Builder(builder: (context) {
                  //? If there are any images to show...
                  if (controller._images.isNotEmpty) {
                    return SizedBox(
                      height: imageHeight,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller._images.length,
                        separatorBuilder: (context, index) => SizedBox(
                          width: 5.w,
                        ),
                        itemBuilder: (context, index) => _SingleImagePicker(
                          controller: controller,
                          hintColor: hintColor,
                          file: controller._images[index],
                          height: imageHeight,
                          formState: state,
                          width: width,
                          index: index,
                        ),
                      ),
                    );
                  }

                  //? This is fine.
                  return Center(
                    child: InkWell(
                      onTap: () => _choosePhoto(context, state),
                      borderRadius: BorderRadius.circular(13.r),
                      child: SizedBox(
                        height: imageHeight,
                        width: width,
                        child: Padding(
                          padding: EdgeInsets.all(10.dg),
                          child: Center(
                            child: WayaAssets.icons.cPlus.svg(
                              height: 40.h,
                              width: 40.h,
                              colorFilter: ColorFilter.mode(hintColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            //? Buttons to add more images or remove images.
            if (controller._images.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  spacing: 10.w,
                  children: [
                    //? Button to remove all images here.
                    WayaButton(
                      text: "Clear",
                      callback: () {
                        controller._clearImages();
                        state.didChange(controller._images);
                      },
                      verticalPadding: 10.h,
                      horizontalPadding: 10.w,
                      height: null,
                      color: wayaTheme.colorScheme.error,
                      leadingIcon: WayaAssets.icons.cBin.svg(
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),

                    //? Button to add a new image to this place.
                    WayaButton(
                      text: "Add Image",
                      callback: () => _choosePhoto(context, state),
                      verticalPadding: 10.h,
                      horizontalPadding: 10.w,
                      height: null,
                      color: wayaTheme.colorScheme.customBlack,
                      leadingIcon: WayaAssets.icons.cPlus.svg(
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),

            //? For the helper text.
            if (state.hasError || (helperText?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  state.errorText ?? helperText!,
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: state.hasError ? wayaTheme.colorScheme.error : hintColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
