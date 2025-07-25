import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:open_file/open_file.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

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

  void _openFile() async {
    //? If this does not exist, leave.
    if (!await widget.doc.exists()) return;

    //? This is the end.
    try {
      final result = await OpenFile.open(widget.doc.path);

      //? If this failed, then panic.
      if (result.type != ResultType.done) {
        WayaSnackBar.showToast("Unable to open document");
      }
    } catch (e) {
      WayaSnackBar.showToast("Unable to open document");
    }
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

    return GestureDetector(
      onTap: downloaded ? _openFile : null,
      child: Padding(
        padding: widget.index == min(widget.totalSize - 1, 2)
            ? EdgeInsets.zero
            : const EdgeInsets.only(bottom: 10),
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
                  if (!downloaded &&
                      widget.message != null &&
                      widget.message?.dto == null &&
                      widget.message!.media!.isNotEmpty)
                    //? Since this is not yet downloaded, first, a stream for this.
                    StreamBuilder(
                      stream: WayaFileRepository.instance.downloadFile(
                        widget.message!.media!.first.mediaUrl,
                        widget.doc,
                        (result) {
                          if (result) {
                            setState(() {
                              downloaded = true;
                            });
                          }
                        },
                      ),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        final progress = data?.$1 ?? 0;
                        final total = data?.$2 ?? 0;

                        //? This is where it is at.
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                                child: Stack(
                                  children: [
                                    CircularProgressIndicator(
                                      value: progress / 100,
                                      color: highlights,
                                    ),

                                    //* First, the icon.
                                    SvgPicture.asset(
                                      icon,
                                      height: 30,
                                      width: 30,
                                      colorFilter: ColorFilter.mode(
                                        highlights,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //? The download bar.
                                  Text(
                                    "${progress > 0 ? progress.toStringAsFixed(0) : 0}% downloaded",
                                    style: WayaTextStyles.bodyMedium.copyWith(
                                      color: highlights,
                                    ),
                                  ),

                                  //? The file name.
                                  Text(
                                    widget.filename,
                                    maxLines: 1,
                                    style: WayaTextStyles.bodyMedium.copyWith(
                                      color: highlights,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                WayaFileHelper.getFileSize(total),
                                style: WayaTextStyles.bodySmall.copyWith(
                                  color: WayaColors.primary,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )

                  //? Since it is real, first, the document file itself.
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 60,
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
                                  colorFilter: ColorFilter.mode(
                                    highlights,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Text(
                                  widget.extension.toUpperCase(),
                                  style: WayaTextStyles.bodySemiBold.copyWith(
                                    color: highlights,
                                    fontSize: 14.sp,
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
                        onPressed: () =>
                            widget.controller?.removeFile(widget.index),
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
                          colorFilter: ColorFilter.mode(
                            WayaColors.greyColor400,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
