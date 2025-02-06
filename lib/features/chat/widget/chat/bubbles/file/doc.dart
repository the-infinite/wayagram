import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class DocumentFileWidget extends StatelessWidget {
  final File doc;
  final int index;
  final String filename;
  final String extension;
  final int totalSize;
  final bool interactive;
  final ChatInputController? controller;
  final MessageModel? message;

  // Construct.
  const DocumentFileWidget({
    super.key,
    required this.doc,
    required this.index,
    required this.filename,
    required this.extension,
    required this.totalSize,
    required this.interactive,
    this.controller,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    // final isMine = interactive || message?.senderId == ConversationState.self.id;
    String icon = WayaAssets.icons.fileUnknown.path;
    Color highlights = WayaColors.greyColor400;
    Color background = WayaColors.greyColor100;

    //? If this is an archive
    if (WayaFileExtensions.archives.contains(extension)) {
      highlights = WayaColors.error;
      background = WayaColors.error.withAlpha(10);
      icon = WayaAssets.icons.fileArchive.path;
    }

    //? If this is a code document file.
    if (WayaFileExtensions.markup.contains(extension)) {
      highlights = WayaColors.testColor;
      background = WayaColors.testColor.withAlpha(10);
      icon = WayaAssets.icons.fileMarkup.path;
    }

    //? If this is a powerpoint presentation file...
    if (WayaFileExtensions.presentations.contains(extension)) {
      highlights = WayaColors.primary600;
      background = WayaColors.primary600.withAlpha(10);
      icon = WayaAssets.icons.filePresentation.path;
    }

    //? If this is  a
    if (WayaFileExtensions.spreadSheets.contains(extension)) {
      highlights = WayaColors.success;
      background = WayaColors.success.withAlpha(10);
      icon = WayaAssets.icons.fileSpreadsheet.path;
    }

    //? If this is a
    if (WayaFileExtensions.textDocuments.contains(extension)) {
      highlights = WayaColors.info;
      background = WayaColors.info.withAlpha(10);
      icon = WayaAssets.icons.fileDocument.path;
    }

    //? Return this here.
    return Padding(
      padding: index == min(totalSize - 1, 2) ? EdgeInsets.zero : const EdgeInsets.only(bottom: 10),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: ColoredBox(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: background,
            child: Stack(
              children: [
                //? First, the image file itself.
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //? First, the file icon.
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: highlights,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //* First, the icon.
                            SvgPicture.asset(
                              icon,
                              height: 30,
                              width: 30,
                              color: highlights,
                            ),

                            //* The text file.
                            Text(
                              extension.toUpperCase(),
                              style: WayaTextStyles.bodySemiBold.copyWith(
                                color: highlights,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Some space.
                    const Gap(5),

                    //? Second, the file's name.
                    Expanded(
                      child: Text(
                        filename,
                        maxLines: 1,
                        style: WayaTextStyles.bodyMedium.copyWith(
                          color: highlights,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),

                //* Only if this is interactive...
                if (interactive) ...[
                  //? Second, the overlay..
                  ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: ColoredBox(
                      color: Colors.black.withAlpha(120),
                    ),
                  ),

                  //? Third, the remove button.
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => controller?.removeFile(index),
                      constraints: BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(2),
                      ),
                      icon: WayaAssets.icons.cMultiplyCircle.svg(
                        color: WayaColors.greyColor400,
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
