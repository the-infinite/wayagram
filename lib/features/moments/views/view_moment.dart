import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/moments/data/moment_helper/moment_helper_funcs.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:wayagram/features/moments/widgets/media/image.dart';
import 'package:wayagram/features/moments/widgets/media/video.dart';
import 'package:wayagram/features/moments/widgets/moment_user_info_widget.dart';
import 'package:wayagram/features/moments/widgets/my_moment_metrics.dart';
import 'package:wayagram/features/moments/widgets/reply_moment_widget.dart';

class ViewMoment extends ConsumerStatefulWidget {
  final List<MomentData> moments;
  final bool isMine;
  final int? index;

  // Construct.
  const ViewMoment({
    super.key,
    required this.moments,
    required this.isMine,
    this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewMomentState();
}

class _ViewMomentState extends ConsumerState<ViewMoment>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late final isMine = widget.isMine;
  late final moments = widget.moments;
  final textController = TextEditingController();
  final pauseController = ValueNotifier(false);
  late int currentIndex = widget.index ?? 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
    );
  }

  void _startTimer() {
    if (moments.isEmpty) return;

    _animationController.reset();

    _animationController.forward(from: 0.0).whenComplete(() {
      if (mounted && !pauseController.value) {
        _nextMoment();
      }
    });
  }

  void _nextMoment() async {
    if (!mounted) return;

    if (currentIndex < moments.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      return;
    }

    //? Since there is nowhere to go to.
    if (!WayaNav.canPop()) {
      debugPrint("No more pages, and cannot pop.");
      return;
    }

    //? If this is my own moment I am viewing...
    if (isMine) {
      WayaNav.replaceNamed(MyMoments.route);
    }

    //? Since it is not mine, I just go somewhere else.
    else {
      WayaNav.goBack();
    }
  }

  //? Fair enough, go back to the previous moment.
  void _previousMoment() {
    //? If this is actually at an index greater than 0....
    if (currentIndex > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }

    //? Since it is not mine, I just go somewhere else.
    else {
      WayaNav.goBack();
    }
  }

  void _onPageChanged(int index) {
    if (!mounted) return;

    //? This is fine.
    _animationController.reset();
    if (index < moments.length) {
      setState(() {
        currentIndex = index;
      });
      _startTimer();
    }

    //? Then we can just do it like this.
    else {
      _pageController.jumpToPage(moments.length - 1);
    }
  }

  void pauseAnimation([bool hideControls = true]) {
    if (!_animationController.isAnimating) return;

    //? Pause the controller.
    _animationController.stop();

    //? If this should hide controls.
    if (!hideControls) return;

    //? This is something.
    pauseController.value = hideControls;
  }

  void continueAnimating() {
    if (_animationController.isAnimating) return;
    pauseController.value = false;
    _startTimer();
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
          onPanUpdate: (details) {
            if ((details.delta.dy / details.delta.dx).abs() < 5) return;
            WayaNav.goBack();
          },
          child: Container(
            color: moments[currentIndex].contentType == 'text'
                ? MomentHelper.hexToColor(
                    moments[currentIndex].color ?? "#1D2939")
                : wayaTheme.colorScheme.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                //? First, the page view.
                PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: moments.length,
                  onPageChanged: (index) => _onPageChanged(index),
                  itemBuilder: (context, index) {
                    //? Get the moment.
                    final moment = moments[currentIndex];

                    //? This is fine.
                    if (moment.contentType.trim().toLowerCase() == 'text') {
                      return _TextMoment(
                        ref: ref,
                        moment: moment,
                        index: index,
                        pause: () => pauseAnimation(false),
                        resume: continueAnimating,
                        setDuration: (duration) =>
                            _animationController.duration = duration,
                      );
                    }

                    //? Do it like this.
                    return _MediaMomentWidget(
                      index: index,
                      ref: ref,
                      moment: moment,
                      pause: () => pauseAnimation(false),
                      resume: continueAnimating,
                      setDuration: (duration) =>
                          _animationController.duration = duration,
                    );
                  },
                ),

                //? Second, the layer that is used to move to the next page.
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //? First, the button to go to the previous page.
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => _previousMoment(),
                        ),
                      ),

                      // Boundary in the middle.
                      Expanded(
                        child: const SizedBox(),
                      ),

                      //? Second, the button to go to the previous page.
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => _nextMoment(),
                        ),
                      ),
                    ],
                  ),
                ),

                //? The title of this page.
                ValueListenableBuilder(
                  valueListenable: pauseController,
                  builder: (context, isPaused, _) {
                    //? This is fine too.
                    if (isPaused) {
                      return const SizedBox();
                    }

                    //? This is fine.
                    return Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: List.generate(
                          moments.length,
                          (index) => Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    double? progressValue;
                                    if (index == currentIndex) {
                                      progressValue =
                                          _animationController.isAnimating
                                              ? _animationController.value
                                              : null;
                                    } else if (index < currentIndex) {
                                      progressValue = 1.0;
                                    } else {
                                      progressValue = 0.0;
                                    }
                                    return LinearProgressIndicator(
                                      minHeight: 6,
                                      borderRadius: BorderRadius.circular(12),
                                      value: progressValue,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.25),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                //? This user id of this page.
                ValueListenableBuilder(
                  valueListenable: pauseController,
                  builder: (context, isPaused, _) {
                    //? This is fine too.
                    if (isPaused) {
                      return const SizedBox();
                    }

                    //? This is fine.
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: 30,
                      child: MomentUserInfoWidget(
                        moment: moments[currentIndex],
                        isMine: moments[currentIndex].userId ==
                            ConversationState.self.id,
                        pause: pauseAnimation,
                        continues: continueAnimating,
                      ),
                    );
                  },
                ),

                //? This is fine.
                if (!isMine)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ReplyMomentWidget(
                      textController: textController,
                      pause: pauseAnimation,
                      continues: continueAnimating,
                      uniqueKey:
                          "up-${moments[currentIndex].userId}-$currentIndex",
                      moment: moments[currentIndex],
                    ),
                  )

                //? How we see our current moment metrics.
                else
                  ValueListenableBuilder(
                    valueListenable: pauseController,
                    builder: (context, isPaused, _) {
                      //? This is fine too.
                      if (isPaused) {
                        return const SizedBox();
                      }

                      //? This is fine.
                      return Positioned(
                        left: 0,
                        right: 0,
                        bottom: 20,
                        child: MyMomentMetrics(
                          pause: pauseAnimation,
                          continues: continueAnimating,
                          moment: moments[currentIndex],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextMoment extends StatefulWidget {
  final WidgetRef ref;
  final MomentData moment;
  final VoidCallback pause;
  final VoidCallback resume;
  final int index;
  final void Function(Duration) setDuration;

  const _TextMoment({
    required this.ref,
    required this.moment,
    required this.index,
    required this.pause,
    required this.resume,
    required this.setDuration,
  });

  @override
  State<_TextMoment> createState() => __TextMomentState();
}

class __TextMomentState extends State<_TextMoment> {
  late final notifier = widget.ref.read(
      replyMomentVmProvider("up-${widget.moment.userId}-${widget.index}")
          .notifier);

  @override
  void initState() {
    widget.setDuration(const Duration(seconds: 7));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.resume();
      notifier.postSingleUserMoment(
          momentId: widget.moment.id, userId: widget.moment.userId);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.setDuration(Duration.zero);
    super.dispose();
  }

  //? Helper function to parse text and detect URLs
  List<TextSpan> _parseText(String text, TextStyle? baseStyle) {
    final urlRegExp = RegExp(
        r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)',
        caseSensitive: false);
    final matches = urlRegExp.allMatches(text);
    final List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      //? Add text before the URL
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: baseStyle,
        ));
      }

      //? Add the URL
      final url = text.substring(match.start, match.end);
      spans.add(TextSpan(
        text: url,
        style: (baseStyle ?? const TextStyle()).copyWith(
          decoration: TextDecoration.underline,
          backgroundColor: Colors.white.withOpacity(0.5),
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Handle URL tap
            final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
            if (uri != null) {
              launchUrl(uri);
            }
          },
      ));

      currentIndex = match.end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: baseStyle,
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.moment.fontType == null
        ? null
        : MomentHelper.textStyleFromJson(widget.moment.fontType!);

    return Container(
      padding: const EdgeInsets.all(24.0),
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: _parseText(widget.moment.content, baseStyle),
        ),
      ),
    );
  }
}
class _MediaMomentWidget extends StatefulWidget {
  final WidgetRef ref;
  final MomentData moment;
  final VoidCallback pause;
  final VoidCallback resume;
  final int index;
  final void Function(Duration) setDuration;

  const _MediaMomentWidget({
    required this.ref,
    required this.moment,
    required this.pause,
    required this.resume,
    required this.index,
    required this.setDuration,
  });

  @override
  State<_MediaMomentWidget> createState() => __MediaMomentWidgetState();
}

class __MediaMomentWidgetState extends State<_MediaMomentWidget> {
  late final notifier = widget.ref.read(
      replyMomentVmProvider("up-${widget.moment.userId}-${widget.index}")
          .notifier);

  @override
  void initState() {
    widget.setDuration(const Duration(seconds: 7));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? Continue animating if this is a photo.
      if (widget.moment.contentType != "video") {
        widget.resume();
      }

      //? Next, We view it.
      notifier.postSingleUserMoment(
          momentId: widget.moment.id, userId: widget.moment.userId);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.setDuration(Duration.zero);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        // Media Preview
        if (widget.moment.contentType == "video")
          WayaFutureSubscriber(
            future: WayaFileHelper.getMomentDirectory(
                widget.moment, widget.moment.content),
            builder: (context, data) {
              if (data == null) {
                return const SizedBox();
              }

              //? Now, return the image moment.
              return VideoPreview(
                content: widget.moment.content,
                file: data,
                data: widget.moment,
                pause: widget.pause,
                resume: widget.resume,
                notifyDuration: widget.setDuration,
              );
            },
          )
        else
          WayaFutureSubscriber(
            future: WayaFileHelper.getMomentDirectory(
                widget.moment, widget.moment.content),
            builder: (context, data) {
              if (data == null) {
                return const SizedBox();
              }

              //? Now, return the image moment.
              return ImageMomentScreen(
                media: widget.moment.content,
                data: widget.moment,
                file: data,
                pause: widget.pause,
                resume: widget.resume,
              );
            },
          ),

        // Caption
        if (widget.moment.caption != null && widget.moment.caption!.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.customBlack.withOpacity(0.5),
              ),
              child: widget.moment.caption!.length < 100
                  ? Text(
                      widget.moment.caption!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: wayaTheme.colorScheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    )
                  : Text(
                      widget.moment.caption!,
                      style: TextStyle(
                        color: wayaTheme.colorScheme.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}
