import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';

class WayaVideoController {
  VideoPlayerController? _controller;
  final _isPlaying = ValueNotifier(false);
  final _isMuted = ValueNotifier(false);
  final bool autoplay;
  final bool startMuted;

  WayaVideoController({
    this.autoplay = false,
    this.startMuted = false,
  });

  bool get isPlaying => _isPlaying.value;

  VideoPlayerValue get value => _controller!.value;

  Future<ClosedCaptionFile>? get subtitleFile => _controller?.closedCaptionFile;

  String get dataSource => _controller!.dataSource;

  DataSourceType get dataSourceType => _controller!.dataSourceType;

  VideoPlayerOptions? get options => _controller!.videoPlayerOptions;

  VideoFormat? get formatHint => _controller!.formatHint;

  Map<String, String> get httpHeaders => _controller!.httpHeaders;

  Future<Duration?> get currentPosition => _controller!.position;

  void addListener(void Function() listener) {
    _controller?.addListener(listener);
  }

  void removeListener(void Function() listener) {
    _controller?.removeListener(listener);
  }

  Future<void> dispose() {
    _isPlaying.dispose();
    _isMuted.dispose();
    return _controller!.dispose();
  }

  Future<void> pause() {
    return _controller!.pause().then(
      (_) {
        _isPlaying.value = false;
      },
    ).catchError(
      (e) {
        debugPrint(e);
      },
    );
  }

  Future<void> play() {
    return _controller!.play().then(
      (_) {
        _isPlaying.value = true;
      },
    ).catchError(
      (e) {
        debugPrint(e);
      },
    );
  }

  Future<void> seekTo(Duration position) {
    return _controller!.seekTo(position);
  }

  Future<void> setSubtitles(Future<ClosedCaptionFile>? subtitles) {
    return _controller!.setClosedCaptionFile(subtitles);
  }

  Future<void> setLooping(bool looping) {
    return _controller!.setLooping(looping);
  }

  Future<void> setPlaybackSpeed(double speed) {
    return _controller!.setPlaybackSpeed(speed);
  }

  Future<void> setVolume(double volume) {
    if (volume < 0 || volume > 1) {
      throw "Invalid volume. Cannot use a value '$volume' because expected a float in the range 0 <= volume <= 1.";
    }

    // If this is muted.
    _isMuted.value = volume == 0;

    // Just do this.
    return _controller!.setVolume(volume);
  }

  void setCaptionOffset(Duration offset) {
    return _controller!.setCaptionOffset(offset);
  }
}

enum WayaVideoControls {
  /// This is a video in a message or something of the sort. Should have the
  /// least amount of controls possible which is none.
  message,

  /// This is a video in a post or something of the sort. Should have an average
  /// number of controls. Should allow playback controls, and volume controls.
  content,

  /// This is a video that is being played in the app's default video player
  /// screen. It should have
  full,
}

class WayaVideoWidget extends StatefulWidget {
  final WayaVideoController controller;
  final String? asset;
  final Uri? networkUrl;
  final File? file;
  final VideoPlayerOptions? options;
  final Future<ClosedCaptionFile>? subtitles;
  final WayaVideoControls controls;

  // This is fine.
  const WayaVideoWidget._({
    required this.controller,
    required this.controls,
    this.subtitles,
    this.options,
    this.asset,
    this.networkUrl,
    this.file,
  });

  @override
  State<WayaVideoWidget> createState() => _WayaVideoWidgetState();

  /// A useful constructor used to initialize this with a file. It is nice to
  /// point out that this is the one most used in social media.
  factory WayaVideoWidget.file(
    File file, {
    required WayaVideoController controller,
    required WayaVideoControls controls,
    VideoPlayerOptions? options,
    Future<ClosedCaptionFile>? subtitles,
  }) {
    return WayaVideoWidget._(
      file: file,
      controller: controller,
      controls: controls,
      options: options,
      subtitles: subtitles,
    );
  }

  /// A useful constructor used to initialize a video view using a URL that
  /// points to some resource over the network.
  factory WayaVideoWidget.networkUrl(
    Uri uri, {
    required WayaVideoController controller,
    required WayaVideoControls controls,
    VideoPlayerOptions? options,
    Future<ClosedCaptionFile>? subtitles,
  }) {
    return WayaVideoWidget._(
      networkUrl: uri,
      controller: controller,
      controls: controls,
      options: options,
      subtitles: subtitles,
    );
  }

  /// A useful constructor used to initialize a video view using an asset bundled
  /// into this application.
  factory WayaVideoWidget.asset(
    String path, {
    required WayaVideoController controller,
    required WayaVideoControls controls,
    VideoPlayerOptions? options,
    Future<ClosedCaptionFile>? subtitles,
  }) {
    return WayaVideoWidget._(
      asset: path,
      controller: controller,
      controls: controls,
      options: options,
      subtitles: subtitles,
    );
  }
}

class _WayaVideoWidgetState extends State<WayaVideoWidget> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  bool _controlsHidden = false;

  void _initializeController() {
    widget.controller._controller ??= (widget.networkUrl != null
        ? VideoPlayerController.networkUrl(
            widget.networkUrl!,
            videoPlayerOptions: widget.options,
            closedCaptionFile: widget.subtitles,
          )
        : widget.file != null
            ? VideoPlayerController.file(
                widget.file!,
                videoPlayerOptions: widget.options,
                closedCaptionFile: widget.subtitles,
              )
            : VideoPlayerController.asset(
                widget.asset!,
                videoPlayerOptions: widget.options,
                closedCaptionFile: widget.subtitles,
              ))
      ..initialize().then(
        (_) {
          //? Ensure the first frame is shown after the video is initialized,
          //? even before the play button has been pressed.
          setState(() {});

          //? If this has autoplay enabled...
          if (widget.controller.autoplay) {
            widget.controller.play();
          }
        },
      );
  }

  @override
  void initState() {
    super.initState();

    // This is fine.
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 450),
      );
    } catch (_) {}

    //? Initialize controllers as the case may be.
    _initializeController();

    // Call the super one.
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the theme here.
    final theme = Theme.of(context);

    //? If these are not initialized, initialize them.
    _initializeController();

    //? The widget that is used to compose the contents of this widget.
    final composition = widget.controller._controller!.value.isInitialized
        ? ColoredBox(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: widget.controller._controller!.value.aspectRatio,
                child: VideoPlayer(
                  widget.controller._controller!,
                ),
              ),
            ),
          )
        : const SizedBox();

    //? If this is for content...
    if (widget.controls == WayaVideoControls.content) {
      //? Every time this changes, leave the controls on screen for
      //? a while then leave.
      () async {
        //? First, wait for 5 seconds.
        await Future.delayed(const Duration(seconds: 6));

        //? Second, hide the controls on the screen.
        try {
          animationController!.forward().then(
            (_) {
              setState(() {
                _controlsHidden = true;
              });
            },
          );
        } catch (_) {}
      }();

      //? Then return the widget.
      return Stack(
        children: [
          //? First, the video view in the background.
          composition,

          //? Second, the clickable area of the screen that is used to switch
          //? hide or unhide the buttons.
          GestureDetector(
            onTap: () {
              //? First, unhide the controls
              animationController!.reverse().then(
                (_) {
                  //? Now, reset the entire page.
                  setState(() {
                    _controlsHidden = false;
                  });
                },
              );
            },
            onDoubleTap: () {
              //? On double tap this thing, pause if this is playing.
              if (widget.controller.isPlaying) {
                widget.controller.pause();
              }

              //? Play if this is paused.
              else {
                widget.controller.play();
              }
            },
          ),

          //? Third, the play button.
          Center(
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 1,
                end: 0,
              ).animate(
                CurvedAnimation(
                  curve: Curves.decelerate,
                  parent: animationController!,
                ),
              ),
              child: ValueListenableBuilder(
                valueListenable: widget.controller._isPlaying,
                builder: (context, isPlaying, _) {
                  //? Build the button.
                  return _controlsHidden
                      ? const SizedBox()
                      : IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: isPlaying
                              ? () {
                                  widget.controller.pause();
                                }
                              : () {
                                  widget.controller.play();
                                },
                          constraints: BoxConstraints(
                            minHeight: 0,
                            minWidth: 0,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.all(10),
                          ),
                          icon: SvgPicture.asset(
                            isPlaying ? WayaAssets.icons.cPause.path : WayaAssets.icons.cPlay.path,
                            height: 26,
                            width: 26,
                            color: theme.colorScheme.primary,
                          ),
                        );
                },
              ),
            ),
          ),

          //? Finally, the mute button.
          Positioned(
            right: 10,
            bottom: 10,
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 1,
                end: 0,
              ).animate(
                CurvedAnimation(
                  curve: Curves.decelerate,
                  parent: animationController!,
                ),
              ),
              child: ValueListenableBuilder(
                valueListenable: widget.controller._isMuted,
                builder: (context, isMuted, _) {
                  return _controlsHidden
                      ? const SizedBox()
                      : IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: isMuted
                              ? () {
                                  widget.controller.setVolume(1);
                                }
                              : () {
                                  widget.controller.setVolume(0);
                                },
                          constraints: BoxConstraints(
                            minHeight: 0,
                            minWidth: 0,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.all(2),
                          ),
                          icon: SvgPicture.asset(
                            isMuted ? WayaAssets.icons.actionVolumeMute.path : WayaAssets.icons.actionVolumeUnmute.path,
                            height: 20,
                            width: 20,
                            color: theme.colorScheme.primary,
                          ),
                        );
                },
              ),
            ),
          )
        ],
      );
    }

    //? Since this has no complex controls, just return the composition widget.
    return composition;
  }
}
