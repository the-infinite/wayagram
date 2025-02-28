import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class VideoThumbnailPlayer extends StatefulWidget {
  final String imageUrl;
  final String videoUrl;

  const VideoThumbnailPlayer({
    super.key,
    required this.imageUrl,
    required this.videoUrl,
  });

  @override
  _VideoThumbnailPlayerState createState() => _VideoThumbnailPlayerState();
}

class _VideoThumbnailPlayerState extends State<VideoThumbnailPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        print("i am initialized finish");
        setState(() {
          _isInitialized = true;
        });
      })
      ..addListener(_checkVideoEnd);
  }

  void _checkVideoEnd() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {
        _isPlaying = false;
        _controller.seekTo(Duration.zero);
      });
    }
    // if (_controller.value.isBuffering != _isBuffering) {
    setState(() {
      _isBuffering = _controller.value.isBuffering;
    });
  }

  void _toggleVideo() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_checkVideoEnd);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: _toggleVideo,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_isPlaying)
            Image.file(
              File(widget.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  color: Colors.grey[300],
                  child: const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                );
              },
              width: double.infinity,
              height: MediaQuery.of(context).size.height /
                  3.5, // Half screen height
            ),
          if (_isBuffering)
            Center(
                child: SizedBox( 
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: wayaTheme.colorScheme.primary600,
              ),
            )),
          if (!_isPlaying)
            GestureDetector(
                onTap: () {
                  _isPlaying = true;
                  _controller.play();
                },
                child: Icon(Icons.play_circle_fill,
                    size: 60, color: Colors.white)),
          if (_isPlaying && _isInitialized && !_isBuffering)
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3.5,
              child: VideoPlayer(_controller),
            ),
        ],
      ),
    );
  }
}
