import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

class ImageFileWidget extends StatefulWidget {
  final File image;
  final int index;
  final int totalSize;
  final bool interactive;
  final ChatInputController? controller;
  final MessageModel? message;

  // Construct.
  const ImageFileWidget({
    super.key,
    required this.image,
    required this.totalSize,
    required this.index,
    required this.interactive,
    required this.controller,
    this.message,
  });

  @override
  State<ImageFileWidget> createState() => _ImageFileWidgetState();
}

class _ImageFileWidgetState extends State<ImageFileWidget> {
  bool downloaded = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.image.exists()) {
        if (mounted) {
          setState(() {
            downloaded = false;
          });
        }

        //? Now, wait for the download to finish...
        return;
      }

      //? Since the file exists, then let us do the needful.
    });
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.image.exists()) {
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
  Widget build(BuildContext context) {
    //? This is fine.
    final size = MediaQuery.sizeOf(context);
    final width = !widget.interactive && widget.totalSize < 3 ? size.width / widget.totalSize : 100.0;
    final height = !widget.interactive && widget.totalSize < 3 ? size.width / widget.totalSize : 100.0;

    //? Return this here.
    return Padding(
      padding: widget.index == min(widget.totalSize - 1, 2) ? EdgeInsets.zero : const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          //? First, the image file itself.
          if (!downloaded && widget.message != null && widget.message?.dto == null && widget.message!.media!.isNotEmpty)
            //? Since this is not yet downloaded, first, a stream for this.
            StreamBuilder(
              stream: WayaFileRepository.instance.downloadFile(
                widget.message!.media!.first.mediaUrl,
                widget.image,
                (result) async {
                  if (result) {
                    //! DO NOT REMOVE THIS LINE. It is us giving the operating
                    //! system enough time to flush the file to storage. Some
                    //! times the file might be lingering in memory as opposed
                    //! to storage.
                    await Future.delayed(const Duration(seconds: 2));
                    // if (await widget.image.exists()) {
                    //   await WayaFileHelper.saveNetworkImage(widget.image.uri.toString());
                    // }
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
            GestureDetector(
              onTap: widget.message?.dto != null
                  ? null
                  : () async {
                      final result = await WayaNavigationHelper.toImageDetailsScreen(
                        [widget.image],
                        null,
                      );

                      //? Do nothing.
                      if (result == null) return;
                    },
              child: ClipPath(
                clipBehavior: Clip.antiAlias,
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height,
                    minHeight: height,
                    maxWidth: width,
                    minWidth: width,
                  ),
                  child: Image.file(
                    widget.image,
                    width: !widget.interactive && widget.totalSize < 3 ? size.width / widget.totalSize : 100,
                    height: !widget.interactive && widget.totalSize < 3 ? null : 100,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      //? If this is synchronously loaded, return the child.
                      if (wasSynchronouslyLoaded) return child;

                      //? If this has been loaded, then return the child as is.
                      if (frame != null) return child;

                      //? Otherwise, return a placeholder.
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          padding: EdgeInsets.all(70.dg),
                          decoration: BoxDecoration(
                            color: WayaColors.primary50,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, e, _) => CachedNetworkImage(
                      imageUrl: widget.message?.media?.first.mediaUrl ?? "",
                      width: !widget.interactive && widget.totalSize < 3 ? size.width / widget.totalSize : 100,
                      height: !widget.interactive && widget.totalSize < 3 ? null : 100,
                      fit: BoxFit.cover,
                    ),
                  ),
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
