import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  String videoPath;
  double width;
  double height;
  VideoThumbnail(this.videoPath, this.height, this.width, {super.key});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.height,
      child: _controller.value.isInitialized
          ? SizedBox(
              height: 100,
              width: 150,
              child: VideoPlayer(_controller),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
