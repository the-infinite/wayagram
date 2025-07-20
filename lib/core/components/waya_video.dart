import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/media/video.dart';

import 'waya_error_widget.dart';

class WayaVideoController {
  VideoPlayerController? _controller;
  void Function(bool)? _onPlaybackChanged;
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

  Future<void> dispose() async {
    _isPlaying.dispose();
    _isMuted.dispose();
    _controller?.dispose();
  }

  Future<void> pause() {
    return _controller!.pause().then(
      (_) {
        _isPlaying.value = false;
        _onPlaybackChanged?.call(false);
      },
    ).catchError(
      (e) {
        debugPrint(e.toString());
      },
    );
  }

  Future<void> play() {
    return _controller!.play().then(
      (_) {
        _isPlaying.value = true;
        _onPlaybackChanged?.call(true);
      },
    ).catchError(
      (e) {
        debugPrint(e.toString());
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

  /// This is a video that should have zero controls. This allows you to override
  /// the controls by making yours, or to just control video playback with code.
  none,
}

class WayaVideoWidget extends StatefulWidget {
  final WayaVideoController controller;
  final String? asset;
  final Uri? networkUrl;
  final File? file;
  final bool canFocus;
  final VideoPlayerOptions? options;
  final Future<ClosedCaptionFile>? subtitles;
  final void Function()? onInitialized;
  final WayaVideoControls controls;

  // This is fine.
  const WayaVideoWidget._({
    required this.controller,
    required this.controls,
    required this.canFocus,
    required this.onInitialized,
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
    bool canFocus = true,
    VideoPlayerOptions? options,
    Future<ClosedCaptionFile>? subtitles,
    void Function(bool)? onPlaybackChanged,
    void Function()? onInitialized,
  }) {
    //? Handle the change of playback state.
    controller._onPlaybackChanged = onPlaybackChanged;

    //? Return a video widget that is meant for device files.
    return WayaVideoWidget._(
      file: file,
      controller: controller,
      controls: controls,
      options: options,
      subtitles: subtitles,
      canFocus: canFocus,
      onInitialized: onInitialized,
    );
  }

  /// A useful constructor used to initialize a video view using a URL that
  /// points to some resource over the network.
  factory WayaVideoWidget.networkUrl(
    Uri uri, {
    required WayaVideoController controller,
    required WayaVideoControls controls,
    bool canFocus = true,
    VideoPlayerOptions? options,
    Future<ClosedCaptionFile>? subtitles,
    void Function(bool)? onPlaybackChanged,
    void Function()? onInitialized,
  }) {
    //? Handle the change of playback state.
    controller._onPlaybackChanged = onPlaybackChanged;

    //? Return a video widget that is meant for network videos.
    return WayaVideoWidget._(
      networkUrl: uri,
      controller: controller,
      controls: controls,
      options: options,
      subtitles: subtitles,
      canFocus: canFocus,
      onInitialized: onInitialized,
    );
  }

  /// A useful constructor used to initialize a video view using an asset bundled
  /// into this application.
  factory WayaVideoWidget.asset(
    String path, {
    required WayaVideoController controller,
    required WayaVideoControls controls,
    bool canFocus = true,
    VideoPlayerOptions? options,
    Future<ClosedCaptionFile>? subtitles,
    void Function(bool)? onPlaybackChanged,
    void Function()? onInitialized,
  }) {
    //? Handle the change of playback state.
    controller._onPlaybackChanged = onPlaybackChanged;

    //? Return a video widget that is meant for assets.
    return WayaVideoWidget._(
      asset: path,
      controller: controller,
      controls: controls,
      options: options,
      subtitles: subtitles,
      canFocus: canFocus,
      onInitialized: onInitialized,
    );
  }
}

class _WayaVideoWidgetState extends State<WayaVideoWidget>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  bool _controlsHidden = false;
  Timer? _timer;

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
          if (mounted) setState(() {});

          //? Notify the parent that this has been initialized.
          widget.onInitialized?.call();

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

  void _startAnimationRecomputation() async {
    //? Cancel the previous timer.
    _timer?.cancel();

    //? First, wait for 5 seconds.
    _timer = Timer(
      const Duration(seconds: 6),
      () async {
        //? Second, hide the controls on the screen.
        _hideControls();
      },
    );
  }

  void _unhideControls() async {
    if (!_controlsHidden) return;
    try {
      //? First, unhide the controls
      if (mounted) {
        setState(() {
          _controlsHidden = false;
        });
      }

      //? Then, make this visible.
      animationController!.reverse();
    } catch (_) {}
  }

  void _hideControls() async {
    if (_controlsHidden) return;
    try {
      //? First, play the animation to hide the controls.
      await animationController!.forward();

      //? Now, ensure they stay hidden.
      if (mounted) {
        setState(() {
          _controlsHidden = true;
        });
      }
    } catch (_) {}
  }

  void _viewVideo() async {
    final result = await WayaNav.to(
      transition: Transition.circularReveal,
      WayaVideoDetailScreen(
        file: widget.file,
        videoUrl: widget.networkUrl?.toString(),
      ),
    );

    //? Do nothing.
    if (result == null) return;
  }

  @override
  Widget build(BuildContext context) {
    //? If these are not initialized, initialize them.
    _initializeController();

    //? The widget that is used to compose the contents of this widget.
    final composition = widget.controller._controller!.value.isInitialized
        ? WayaErrorWidget(
            onError: (context, _) => ColoredBox(color: Colors.black),
            builder: (context) => ColoredBox(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: widget.controller._controller!.value.aspectRatio,
                  child: VideoPlayer(
                    widget.controller._controller!,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();

    //? The widget that is used to control the contents of this widget.
    final controlsView = switch (widget.controls) {
      WayaVideoControls.content => contentVideoControls(),
      WayaVideoControls.message => messageVideoControls(),
      WayaVideoControls.full => fullScreenVideoControls(),
      WayaVideoControls.none => const SizedBox(),
    };

    //? If this is for content...
    if (widget.controls != WayaVideoControls.none) {
      //? Every time this changes, leave the controls on screen for
      //? a while then leave.
      _startAnimationRecomputation();

      //? Then return the widget.
      return Stack(
        children: [
          //? First, the video view in the background.
          composition,

          //? Second, the very thin overlay that goes on top of our video
          //? controls such that it makes the controls more visible.
          if (!_controlsHidden)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black12,
              ),
            ),

          //? Third, the clickable area of the screen that is used to switch
          //? hide or unhide the buttons.
          GestureDetector(
            onTap: widget.canFocus
                ? _viewVideo
                : _controlsHidden
                    ? _unhideControls
                    : _hideControls,
            behavior: HitTestBehavior.translucent,
            onDoubleTap: () {
              //? On double tap this thing, pause if this is playing.
              if (widget.controller.isPlaying) {
                widget.controller.pause();
                _hideControls();
              }

              //? Play if this is paused.
              else {
                widget.controller.play();
                _hideControls();
              }
            },
          ),

          //? Finally, the controls.
          if (!_controlsHidden)
            Positioned.fill(
              child: controlsView,
            ),
        ],
      );
    }

    //? Since this has no complex controls, just return the composition widget.
    return GestureDetector(
      onTap: !widget.canFocus ? null : _viewVideo,
      child: composition,
    );
  }

  /// The video controls used primarily in message views. Kind of handy for that
  /// particular application since it has minimal controls while featuring
  /// basically all abilities you might need.
  Widget messageVideoControls() {
    // Get the theme here.
    final theme = Theme.of(context);

    //? Now, return this.
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //? First,  dummy child to just center the play button.
        const SizedBox(),

        //? For the button here.
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
                                animationController?.reset();
                                _startAnimationRecomputation();
                                widget.controller.pause();
                              }
                            : () {
                                animationController?.reset();
                                _startAnimationRecomputation();
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
                          isPlaying
                              ? WayaAssets.icons.cPause.path
                              : WayaAssets.icons.cPlay.path,
                          height: 26,
                          width: 26,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
              },
            ),
          ),
        ),

        //? Finally, the mute button.
        FadeTransition(
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
                        isMuted
                            ? WayaAssets.icons.actionVolumeMute.path
                            : WayaAssets.icons.actionVolumeUnmute.path,
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
            },
          ),
        )
      ],
    );
  }

  /// The video controls used primarily in content. So is used in moments, posts,
  /// and so on. Useful because it should contain volume, playback, speed, and
  /// seek controls.
  Widget contentVideoControls() {
    // Get the theme here.
    final theme = Theme.of(context);

    //? Now, return this.
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //? First,  dummy child to just center the play button.
        const SizedBox(),

        //? For the button here.
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
                                animationController?.reset();
                                _startAnimationRecomputation();
                                widget.controller.pause();
                              }
                            : () {
                                animationController?.reset();
                                _startAnimationRecomputation();
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
                          isPlaying
                              ? WayaAssets.icons.cPause.path
                              : WayaAssets.icons.cPlay.path,
                          height: 26,
                          width: 26,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
              },
            ),
          ),
        ),

        //? Finally, the mute button.
        Padding(
          padding: EdgeInsets.only(right: 15.w, bottom: 65.h),
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
                          isMuted
                              ? WayaAssets.icons.actionVolumeMute.path
                              : WayaAssets.icons.actionVolumeUnmute.path,
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
              },
            ),
          ),
        )
      ],
    );
  }

  /// The video controls used when a user is interacting with the FULL view of a
  /// video. Should contain as much playback controls as is allowed, and possible.
  /// Expects that the height of the video is full screen so you would immediately
  /// notice its layout is optimized for such.
  Widget fullScreenVideoControls() {
    return contentVideoControls();
  }
}
