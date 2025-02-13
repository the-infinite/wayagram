import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/logic/files.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/file/audio.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/file/doc.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/file/image.dart';
import 'package:wayagram/features/chat/widget/chat/bubbles/file/video.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class ChatFileListWidget extends StatefulWidget {
  final ChatInputController? controller;
  final MessageModel? message;
  final bool interactive;

  const ChatFileListWidget({
    super.key,
    this.interactive = true,
    this.controller,
    this.message,
  });

  @override
  State<ChatFileListWidget> createState() => _ChatFileListWidgetState();
}

class _ChatFileListWidgetState extends State<ChatFileListWidget> with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    // This is fine.
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? First, the data needed to render this widget.
    final size = MediaQuery.sizeOf(context);
    final filesFuture = widget.interactive || widget.message?.dto != null
        ? Future.value(widget.message?.dto?.asFilesList ?? widget.controller!.selectedFiles)
        : getMessageFileAttachments(widget.message!);

    //? Second
    final composition = FutureBuilder(
        future: filesFuture,
        builder: (context, snapshot) {
          final files = snapshot.data ?? [];

          //? This is fine.
          if (snapshot.connectionState != ConnectionState.done || files.isEmpty) {
            return const SizedBox();
          }

          //? This is fine.
          final inferenceFile = files.first;
          final inferenceExtensionIndex = inferenceFile.path.lastIndexOf(".");
          final inferredExtension = inferenceFile.path.substring(inferenceExtensionIndex + 1);
          final isMediaFiles = widget.interactive
              ? widget.controller!.isMedia
              : [...WayaFileExtensions.images, ...WayaFileExtensions.videos].contains(inferredExtension);
          return Container(
            width: widget.interactive ? size.width : null,
            height: widget.interactive ? 100 : null,
            constraints: widget.interactive
                ? null
                : BoxConstraints(
                    maxHeight: size.height * 0.35,
                  ),
            child: Stack(
              children: [
                //? First, the items that can be shown themselves.
                if (widget.interactive)
                  ListView.builder(
                    itemCount: files.length,
                    scrollDirection: isMediaFiles ? Axis.horizontal : Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // First, the file.
                      final file = files[index];
                      final filename = file.uri.pathSegments.last;
                      final extensionIndex = filename.lastIndexOf(".");
                      final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';

                      //? If this is an image...
                      if (WayaFileExtensions.images.contains(extension)) {
                        return ImageFileWidget(
                          image: file,
                          totalSize: files.length,
                          index: index,
                          interactive: widget.interactive,
                          controller: widget.controller,
                        );
                      }

                      //? If this is a video file.
                      if (WayaFileExtensions.videos.contains(extension)) {
                        return VideoFileWidget(
                          video: file,
                          totalSize: files.length,
                          index: index,
                          interactive: widget.interactive,
                          controller: widget.controller,
                        );
                      }

                      //? If this is an audio file...
                      if (WayaFileExtensions.audio.contains(extension)) {
                        return AudioFileWidget(
                          audio: file,
                          totalSize: files.length,
                          index: index,
                          filename: filename,
                          extension: extension,
                          interactive: widget.interactive,
                          controller: widget.controller,
                          message: widget.message,
                        );
                      }

                      //? Else, treat this like a document.
                      return DocumentFileWidget(
                        doc: file,
                        index: index,
                        filename: filename,
                        extension: extension,
                        totalSize: files.length,
                        interactive: widget.interactive,
                        controller: widget.controller,
                        message: widget.message,
                      );
                    },
                  )
                else
                  Flex(
                    direction: isMediaFiles ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      min(files.length, 3), // Can only show at most 3 items at a time.
                      (index) {
                        // First, the file.
                        final file = files[index];
                        final filename = file.uri.pathSegments.last;
                        final extensionIndex = filename.lastIndexOf(".");
                        final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';

                        return
                            //? When this is an image file.
                            WayaFileExtensions.images.contains(extension)
                                ? Expanded(
                                    child: ImageFileWidget(
                                      image: file,
                                      totalSize: files.length,
                                      index: index,
                                      interactive: widget.interactive,
                                      controller: widget.controller,
                                      message: widget.message,
                                    ),
                                  )
                                :

                                //? If this is a video file.
                                WayaFileExtensions.videos.contains(extension)
                                    ? Expanded(
                                        child: VideoFileWidget(
                                          video: file,
                                          totalSize: files.length,
                                          index: index,
                                          interactive: widget.interactive,
                                          controller: widget.controller,
                                          message: widget.message,
                                        ),
                                      )

                                    //? If this is for audio files...
                                    : WayaFileExtensions.audio.contains(extension)
                                        ? AudioFileWidget(
                                            audio: file,
                                            totalSize: files.length,
                                            index: index,
                                            filename: filename,
                                            extension: extension,
                                            message: widget.message,
                                            interactive: widget.interactive,
                                            controller: widget.controller,
                                          )

                                        //? If this is something else...
                                        : DocumentFileWidget(
                                            doc: file,
                                            index: index,
                                            filename: filename,
                                            extension: extension,
                                            totalSize: files.length,
                                            interactive: widget.interactive,
                                            controller: widget.controller,
                                            message: widget.message,
                                          );
                      },
                    ),
                  ),

                //? If this is not interactive...
                if (!widget.interactive && files.length > 3)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: WayaColors.white,
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: Text(
                        "+${files.length - 3} more",
                        style: WayaTextStyles.bodyMedium.copyWith(
                          color: WayaColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          );
        });

    //? If this is the interactive variant...
    if (widget.interactive) {
      // Play the animation.
      try {
        animationController?.forward();
      } catch (_) {}

      // Now, build the widget itself.
      return SizeTransition(
        axis: Axis.vertical,
        sizeFactor: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            curve: Curves.decelerate,
            parent: animationController!,
          ),
        ),
        child: composition,
      );
    }

    //? Since this is not out cup of tea...
    return composition;
  }
}
