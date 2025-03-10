import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/moments/data/moment_helper/moment_helper_funcs.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:wayagram/features/moments/widgets/moment_user_info_widget.dart';
import 'package:wayagram/features/moments/widgets/my_moment_metrics.dart';
import 'package:wayagram/features/moments/widgets/reply_moment_widget.dart';

class ViewMoment extends ConsumerStatefulWidget {
  static const route = "/view-moment";
  const ViewMoment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewMomentState();
}

class _ViewMomentState extends ConsumerState<ViewMoment>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  List<MomentData> moments = [];
  int currentIndex = 0;
  bool isPaused = false;
  bool isMine = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args['index'] != null) {
        setState(() {
          currentIndex = args['index'];
        });
      }
      if (args != null && args['moments'] != null) {
        setState(() {
          isMine = args['isMine'];
          moments = args['moments'];
          _startTimer();
        });
      }
    });
  }

  void _startTimer() {
    if (moments.isEmpty) return;

    final moment = moments[currentIndex];
    print("in timer $currentIndex");
    print(moments[currentIndex].id);
    final duration = moment.contentType == 'video' ? 30 : 7;
    _animationController.duration = Duration(seconds: duration);
    _animationController.forward(from: 0.0).whenComplete(() {
      print("completed");
      if (mounted && !isPaused) {
        _nextMoment();
      }
    });
  }

  void _nextMoment() {
    if (!mounted) return;

    if (currentIndex < moments.length - 1) {
      //  print("efew $currentIndex");

      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      _startTimer();
    } else {
      if (Navigator.canPop(context)) {
        if (isMine) {
          Navigator.pushReplacementNamed(context, MyMoments.route);
        } else {
          Navigator.pop(context);
        }
      } else {
        debugPrint("No more pages, and cannot pop.");
      }
    }
  }
  // void _previousMoment() {
  //   if (currentIndex > 0) {
  //     _pageController.previousPage(
  //         duration: Duration(milliseconds: 300), curve: Curves.ease);
  //   }
  // }

  void _onPageChanged(int index) {
    if (!mounted) return;

    if (index < moments.length) {
      setState(() {
        currentIndex = index;
        _animationController.reset();
        _startTimer();
      });
    } else {
      _pageController.jumpToPage(moments.length - 1);
    }
  }

  void pauseAnimation() {
    if (!_animationController.isAnimating) return;
    setState(() {
      isPaused = true;
      _animationController.stop();
    });
  }

  void continueAnimating() {
    if (_animationController.isAnimating) return;
    setState(() {
      isPaused = false;
      print("completed ${_animationController.duration}");
      //_animationController.forward();
      _startTimer();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    if (moments.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onLongPressStart: (_) => pauseAnimation(),
          onLongPressEnd: (_) => continueAnimating(),
          child: Container(
            color: moments[currentIndex].contentType == 'text'
                ? MomentHelper.hexToColor(
                    moments[currentIndex].color ?? "#1D2939")
                : wayaTheme.colorScheme.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _onPageChanged(index);
                  },
                  itemCount: moments.length,
                  itemBuilder: (context, index) {
                    final moment = moments[currentIndex];
                    return moment.contentType == 'text'
                        ? textMoment(context: context, ref: ref, moment: moment)
                        : mediaPreview(
                            context: context, ref: ref, moment: moment);
                  },
                ),
                if (!isPaused)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: List.generate(moments.length, (index) {
                        return Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(12),
                                    value: index == currentIndex
                                        ? _animationController.value
                                        : (index < currentIndex ? 1.0 : 0.0),
                                    backgroundColor: Colors.black
                                        .withOpacity(0.5)
                                        .withOpacity(0.5),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  );
                                },
                              )),
                        );
                      }),
                    ),
                  ),
                if (!isPaused)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 30,
                    child: MomentUserInfoWidget(
                      moment: moments[currentIndex],
                      isMine: args['isMine'],
                      pause: pauseAnimation,
                      continues: continueAnimating,
                    ),
                  ),
                if (!args['isMine'])
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ReplyMomentWidget(
                      pause: pauseAnimation,
                      continues: continueAnimating,
                      uniqueKey: "$currentIndex",
                      moment: moments[currentIndex],
                    ),
                  ),
                if (args['isMine'] && !isPaused)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: MyMomentMetrics(
                        pause: pauseAnimation,
                        continues: continueAnimating,
                        moment: moments[currentIndex]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget textMoment({
  required BuildContext context,
  required WidgetRef ref,
  required MomentData moment,
}) {
  return Container(
    padding: const EdgeInsets.all(24.0),
    alignment: Alignment.center,
    child: Text(
      moment.content,
      style: moment.fontType != null
          ? MomentHelper.textStyleFromJson(moment.fontType!)
          : null,
      textAlign: TextAlign.center,
    ),
  );
}

Widget mediaPreview({
  required BuildContext context,
  required WidgetRef ref,
  required MomentData moment,
}) {
  final wayaTheme = Theme.of(context);
  return Stack(
    fit: StackFit.expand,
    children: [
      // Media Preview
      moment.contentType == "video"
          ? VideoPreview(
              content: moment.content,
            )
          : Image.network(
              moment.content,
              fit: BoxFit.cover,
            ),

      // Caption
      if (moment.caption != null && moment.caption!.isNotEmpty)
        Positioned(
          left: 0,
          right: 0,
          bottom: 50,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.customBlack.withOpacity(0.5),
                //borderRadius: BorderRadius.horizontal(left: , right: Radius.circular(12)),
              ),
              child: moment.caption!.length < 100
                  ? Text(
                      moment.caption!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    )
                  : Text(moment.caption!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13))),
        ),
    ],
  );
}

class VideoPreview extends ConsumerStatefulWidget {
  final String content;

  const VideoPreview({super.key, required this.content});

  @override
  ConsumerState<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends ConsumerState<VideoPreview> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.content))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller?.play();
        _controller?.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }
}
