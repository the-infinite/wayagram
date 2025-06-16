import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_video.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

class VideoFileWidget extends StatefulWidget {
  final File video;
  final int index;
  final int totalSize;
  final bool interactive;
  final ChatInputController? controller;
  final MessageModel? message;

  // Construct.
  const VideoFileWidget({
    super.key,
    required this.video,
    required this.totalSize,
    required this.index,
    required this.interactive,
    required this.controller,
    this.message,
  });

  @override
  State<VideoFileWidget> createState() => _VideoFileWidgetState();
}

class _VideoFileWidgetState extends State<VideoFileWidget> {
  bool downloaded = true;
  final controller = WayaVideoController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.video.exists()) {
        if (mounted) {
          setState(() {
            downloaded = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.video.exists()) {
        if (mounted) {
          setState(() {
            downloaded = false;
          });
        }
      }
    });
    super.reassemble();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final size = MediaQuery.sizeOf(context);

    //? Return this here.
    return Padding(
      padding: widget.index == min(widget.totalSize - 1, 2) ? EdgeInsets.zero : const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          //? First, the video file itself.
          if (!downloaded && widget.message != null && widget.message?.dto == null && widget.message!.media!.isNotEmpty)
            //? Since this is not yet downloaded, first, a stream for this.
            StreamBuilder(
              stream: WayaFileRepository.instance.downloadFile(
                widget.message!.media!.first.mediaUrl,
                widget.video,
                (result) async {
                  if (result) {
                    //! DO NOT REMOVE THIS LINE. It is us giving the operating 
                    //! system enough time to flush the file to storage. Some
                    //! times the file might be lingering in memory as opposed
                    //! to storage.
                    await Future.delayed(const Duration(seconds: 4));
                    if (!mounted) return;
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
                return ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: WayaColors.primary50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //? The progress things.
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              value: progress / 100,
                              color: WayaColors.primary,
                            ),
                          ),

                          // Some space.
                          const Gap(10),

                          //? The download bar.
                          Text(
                            "${progress > 0 ? progress.toStringAsFixed(0) : 0}% downloaded",
                            textAlign: TextAlign.center,
                            style: WayaTextStyles.bodyMedium.copyWith(
                              color: WayaColors.primary,
                            ),
                          ),

                          // Some space.
                          const Gap(5),

                          //? The file name.
                          Text(
                            WayaFileHelper.getFileSize(total),
                            textAlign: TextAlign.center,
                            style: WayaTextStyles.bodySmall.copyWith(
                              color: WayaColors.primary,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )

          //? Since it is real, first, the document file itself.
          else
            ClipPath(
              clipBehavior: Clip.antiAlias,
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                width: !widget.interactive && widget.totalSize < 3 ? size.width / widget.totalSize : 100,
                height: !widget.interactive && widget.totalSize < 3 ? null : 100,
                child: WayaVideoWidget.file(
                  widget.video,
                  controller: controller,
                  controls: widget.interactive ? WayaVideoControls.message : WayaVideoControls.content,
                  canFocus: widget.message?.dto == null,
                ),
              ),
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
    );
  }
}
