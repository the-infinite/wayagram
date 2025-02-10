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

class DocumentFileWidget extends StatefulWidget {
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
  State<DocumentFileWidget> createState() => _DocumentFileWidgetState();
}

class _DocumentFileWidgetState extends State<DocumentFileWidget> {
  // Has this been downloaded yet?
  bool downloaded = true;

  //? If this file is downloaded.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? If this file exists...
        if (!await widget.doc.exists()) {
          if (mounted) {
            setState(() {
              downloaded = false;
            });
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    // final isMine = interactive || message?.senderId == ConversationState.self.id;
    String icon = WayaAssets.icons.fileUnknown.path;
    Color highlights = WayaColors.greyColor400;
    Color background = WayaColors.greyColor100;

    //? If this is an archive
    if (WayaFileExtensions.archives.contains(widget.extension)) {
      highlights = WayaColors.error;
      background = WayaColors.error.withAlpha(10);
      icon = WayaAssets.icons.fileArchive.path;
    }

    //? If this is a code document file.
    if (WayaFileExtensions.markup.contains(widget.extension)) {
      highlights = WayaColors.testColor;
      background = WayaColors.testColor.withAlpha(10);
      icon = WayaAssets.icons.fileMarkup.path;
    }

    //? If this is a powerpoint presentation file...
    if (WayaFileExtensions.presentations.contains(widget.extension)) {
      highlights = WayaColors.primary600;
      background = WayaColors.primary600.withAlpha(10);
      icon = WayaAssets.icons.filePresentation.path;
    }

    //? If this is  a spreadsheet file.
    if (WayaFileExtensions.spreadSheets.contains(widget.extension)) {
      highlights = WayaColors.success;
      background = WayaColors.success.withAlpha(10);
      icon = WayaAssets.icons.fileSpreadsheet.path;
    }

    //? If this is a text document file.
    if (WayaFileExtensions.textDocuments.contains(widget.extension)) {
      highlights = WayaColors.info;
      background = WayaColors.info.withAlpha(10);
      icon = WayaAssets.icons.fileDocument.path;
    }

    //? Return this here.
    return Padding(
      padding: widget.index == min(widget.totalSize - 1, 2) ? EdgeInsets.zero : const EdgeInsets.only(bottom: 10),
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
                if (!downloaded && widget.message != null && widget.message?.dto == null)
                  //? Since this is not yet downloaded, first, a stream for this.
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
                                widget.extension.toUpperCase(),
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
                          widget.filename,
                          maxLines: 1,
                          style: WayaTextStyles.bodyMedium.copyWith(
                            color: highlights,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  )

                //? Since it is real, first, the document file itself.
                else
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
                                widget.extension.toUpperCase(),
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
                          widget.filename,
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
                if (widget.interactive) ...[
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
                      onPressed: () => widget.controller?.removeFile(widget.index),
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
