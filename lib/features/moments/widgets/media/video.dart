import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

class VideoPreview extends ConsumerStatefulWidget {
  final String content;
  final MomentData data;
  final File file;
  final VoidCallback pause, resume;

  const VideoPreview({
    super.key,
    required this.content,
    required this.file,
    required this.data,
    required this.pause,
    required this.resume,
  });

  @override
  ConsumerState<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends ConsumerState<VideoPreview> {
  final _controller = WayaVideoController();
  bool downloaded = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.file.exists()) {
        try {
          widget.pause();
        } catch (_) {}
        if (mounted) {
          setState(() {
            downloaded = false;
          });
        }
      }

      //? Since this exists..
      else {
        _controller.setLooping(true);
        _controller.play();
      }
    });
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.file.exists()) {
        try {
          widget.pause();
        } catch (_) {}
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final size = MediaQuery.sizeOf(context);

    //? Return this here.
    if (!downloaded) {
      return StreamBuilder(
        stream: WayaFileRepository.instance.downloadFile(
          widget.content,
          widget.file,
          (result) async {
            if (result) {
              await Future.delayed(const Duration(seconds: 1, milliseconds: 800));
              try {
                _controller.setLooping(true);
                _controller.play();
              } catch (_) {}
              setState(() {
                downloaded = true;
              });
            }
          },
        ),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final progress = data?.$1 ?? 0;

          //? This is where it is at.
          return AspectRatio(
            aspectRatio: size.aspectRatio,
            child: Container(
              color: WayaColors.primary50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      value: progress / 100,
                      color: WayaColors.primary300,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    //? Since this is already downloaded...
    else {
      return WayaVideoWidget.file(
        widget.file,
        controller: _controller,
        controls: WayaVideoControls.none,
        onPlaybackChanged: (isPlaying) {
          //? When the video is resumed, continue the animation timer.
          if (isPlaying) {
            widget.resume();
          }

          //? When the video is paused, pause the animation timer.
          else {
            widget.pause();
          }
        },
      );
    }
  }
}
