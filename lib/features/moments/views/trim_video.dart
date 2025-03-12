import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:wayagram/core/utils/utils.dart';

class VideoTrimmerScreen extends ConsumerStatefulWidget {
  static const route = '/video-trimmer';
  final File? videoFile;

  const VideoTrimmerScreen({super.key,  this.videoFile});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoTrimmerScreenState();
}

class _VideoTrimmerScreenState extends ConsumerState<VideoTrimmerScreen> {
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() async {
    await _trimmer.loadVideo(videoFile: widget.videoFile!);
    final controller = _trimmer.videoPlayerController;
    if (controller != null) {
      setState(() {
        _endValue = controller.value.duration.inSeconds.toDouble();
      });
    }
  }

  void _playPauseVideo() async {
    bool playbackState = await _trimmer.videoPlaybackControl(
      startValue: _startValue,
      endValue: _endValue,
    );
    setState(() {
      _isPlaying = playbackState;
    });
  }

  void _trimVideo() async {
    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        if (outputPath != null) {
          File trimmedFile = File(outputPath);
          WayaNav.goBack(result: trimmedFile);
        } else {}
      },
    );
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trim Video'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _trimVideo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: VideoViewer(trimmer: _trimmer),
          ),
          TrimViewer(
            trimmer: _trimmer,
            viewerHeight: 50.0,
            viewerWidth: MediaQuery.of(context).size.width,
            maxVideoLength: const Duration(seconds: 15),
            onChangeStart: (value) => _startValue = value,
            onChangeEnd: (value) => _endValue = value,
            onChangePlaybackState: (value) =>
                setState(() => _isPlaying = value),
          ),
          TextButton(
            onPressed: _playPauseVideo,
            child: _isPlaying
                ? const Icon(Icons.pause, size: 50.0)
                : const Icon(Icons.play_arrow, size: 50.0),
          ),
        ],
      ),
    );
  }
}
