import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class UploadImage extends StatelessWidget {
  final VoidCallback onUpload;
  final VoidCallback onRemove;
  final File? imagePath;

  //? Fair enough.
  const UploadImage({
    super.key,
    required this.onUpload,
    required this.onRemove,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? The component.
    return DottedBorder(
      borderType: BorderType.RRect,
      color: wayaTheme.colorScheme.greyColor300,
      radius: Radius.circular(12),
      padding: EdgeInsets.all(18.dg),
      dashPattern: [5, 5],
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? If there is an image selected.
            if (imagePath != null) ...[
              //* First, the image itself.
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Image.file(
                    imagePath!,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    scale: 1,
                  ),
                ),
              ),

              // Some space.
              const Gap(10),

              //? Our button to upload an image.
              InkWell(
                onTap: onRemove,
                child: Text(
                  "Remove image",
                  textAlign: TextAlign.center,
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]

            //? Since there no image selected.
            else ...[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: wayaTheme.colorScheme.secondaryColor2,
                ),
                child: Center(
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    size: 30,
                    color: wayaTheme.colorScheme.greyColor500,
                  ),
                ),
              ),

              // Some space.
              const Gap(10),

              //? Our button to upload an image.
              InkWell(
                onTap: onUpload,
                child: Text(
                  "Click to upload",
                  textAlign: TextAlign.center,
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    color: wayaTheme.colorScheme.customPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Some space.
              const Gap(8),

              //? Context on supported formats.
              Text(
                "PNG, JPG (max. 800px x 400px)",
                style: wayaTheme.textTheme.hintStyle,
              ),

              // Some space.
              const Gap(20),

              //? Where we draw the line.
              WayaTextStrip("OR"),

              // Some space.
              const Gap(25),

              //? How we handle file uploads.
              SizedBox(
                width: 130,
                child: WayaButton(
                  height: 35,
                  callback: onUpload,
                  text: "Browse Files",
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class UploadLogo extends StatelessWidget {
  final VoidCallback onUpload;
  final File? imagePath;
  final String? url;
  final bool? isEditingMode;
  const UploadLogo({super.key, required this.onUpload, this.imagePath, this.isEditingMode, this.url});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Stack(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor),
                child: imagePath != null
                    ? Image.file(
                        imagePath!,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        scale: 1,
                      )
                    : url != null
                        ? Image.network(
                            url!,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            scale: 1,
                          )
                        : SizedBox.shrink(),
              ),
              Positioned.fill(
                child: Material(
                  color: wayaTheme.colorScheme.customPrimary.withOpacity(0.3),
                  child: InkWell(
                    onTap: onUpload,
                    child: Center(
                        child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(width: 1, color: wayaTheme.colorScheme.white)),
                      child: Text(
                        "Upload Logo",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.white, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class UploadProductImage extends StatelessWidget {
  final VoidCallback onUpload;
  final File? imagePath;
  const UploadProductImage({super.key, required this.onUpload, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return DottedBorder(
        borderType: BorderType.RRect,
        color: wayaTheme.colorScheme.greyColor300,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(12),
        dashPattern: [5, 5],
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: SizedBox(
              width: context.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: wayaTheme.colorScheme.secondaryColor2,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 30,
                        color: wayaTheme.colorScheme.greyColor500,
                      ),
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: onUpload,
                    child: Text(
                      "Click to upload",
                      textAlign: TextAlign.center,
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    textAlign: TextAlign.center,
                    "PNG, JPG (max. 800px x 400px)",
                    style: wayaTheme.textTheme.hintStyle,
                  ),
                  const Gap(20),
                ],
              ),
            )));
  }
}
