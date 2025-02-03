import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_video.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class VideoFileWidget extends StatelessWidget {
  final File video;
  final int index;
  final int totalSize;
  final bool interactive;
  final ChatInputController? controller;

  // Construct.
  const VideoFileWidget({
    super.key,
    required this.video,
    required this.totalSize,
    required this.index,
    required this.interactive,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final size = MediaQuery.sizeOf(context);

    //? Return this here.
    return Padding(
      padding: (interactive && index == totalSize - 1) || (!interactive && (index == totalSize - 1 || index == 2))
          ? EdgeInsets.zero
          : const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          //? First, the image file itself.
          ClipPath(
            clipBehavior: Clip.antiAlias,
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: SizedBox(
              width: !interactive && totalSize < 3 ? size.width / totalSize : 100,
              height: !interactive && totalSize < 3 ? null : 100,
              child: WayaVideoWidget.file(
                video,
                controller: WayaVideoController(),
                controls: interactive ? WayaVideoControls.message : WayaVideoControls.content,
              ),
            ),
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
    );
  }
}
