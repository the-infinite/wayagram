import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/moments/data/moment_helper/moment_helper_funcs.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:wayagram/features/moments/widgets/media/image.dart';
import 'package:wayagram/features/moments/widgets/media/video.dart';
import 'package:wayagram/features/moments/widgets/moment_user_info_widget.dart';
import 'package:wayagram/features/moments/widgets/my_moment_metrics.dart';
import 'package:wayagram/features/moments/widgets/reply_moment_widget.dart';

class ViewMoment extends ConsumerStatefulWidget {
  static const route = "/view-moment";
  const ViewMoment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewMomentState();
}

class _ViewMomentState extends ConsumerState<ViewMoment> with SingleTickerProviderStateMixin {
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
    final duration = moment.contentType == 'video' ? 30 : 7;
    _animationController.duration = Duration(seconds: duration);
    _animationController.forward(from: 0.0).whenComplete(() {
      if (mounted && !isPaused) {
        _nextMoment();
      }
    });
  }

  void _nextMoment() {
    if (!mounted) return;

    if (currentIndex < moments.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      _startTimer();
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
    if (currentIndex > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _onPageChanged(int index) {
    if (!mounted) return;

    //? This is fine.
    if (index < moments.length) {
      setState(() {
        currentIndex = index;
        _animationController.reset();
        _startTimer();
      });
    }

    //? Then we can just do it like this.
    else {
      _pageController.jumpToPage(moments.length - 1);
    }
  }

  void pauseAnimation([bool hideControls = true]) {
    if (!_animationController.isAnimating) return;
    setState(() {
      isPaused = hideControls;
      _animationController.stop();
    });
  }

  void continueAnimating() {
    if (_animationController.isAnimating) return;
    setState(() {
      isPaused = false;
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
                ? MomentHelper.hexToColor(moments[currentIndex].color ?? "#1D2939")
                : wayaTheme.colorScheme.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: moments.length,
                  onPageChanged: (index) => _onPageChanged(index),
                  itemBuilder: (context, index) {
                    final moment = moments[currentIndex];
                    return moment.contentType == 'text'
                        ? textMoment(context: context, ref: ref, moment: moment)
                        : mediaPreview(
                            context: context,
                            ref: ref,
                            moment: moment,
                            pause: () => pauseAnimation(false),
                            resume: continueAnimating,
                          );
                  },
                ),

                //? Next, the layer that is used to move to the next page.
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //? First, the button to go to the previous page.
                      Expanded(
                        child: GestureDetector(
                          onDoubleTap: () {
                            //? If this is the first page, reset the timer.
                            if (_pageController.page == 0) {
                              _startTimer();
                            }

                            //? Move to the previous page.
                            else {
                              _previousMoment();
                            }
                          },
                        ),
                      ),

                      //? Second, the button to go to the previous page.
                      Expanded(
                        child: GestureDetector(
                          onDoubleTap: () {
                            //? If this is the first page, reset the timer.
                            if (_pageController.page == moments.length - 1) {
                            }

                            //? Move to the previous page.
                            else {
                              _nextMoment();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //? The title of this page.
                if (!isPaused)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: List.generate(
                        moments.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) => LinearProgressIndicator(
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(12),
                                value: index == currentIndex
                                    ? _animationController.value
                                    : (index < currentIndex ? 1.0 : 0.0),
                                backgroundColor: Colors.black.withOpacity(0.25),
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!isPaused)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 30,
                    child: MomentUserInfoWidget(
                      moment: moments[currentIndex],
                      isMine: isMine,
                      pause: pauseAnimation,
                      continues: continueAnimating,
                    ),
                  ),

                //?
                if (!isMine)
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

                //? How we see our current moment metrics.
                if (isMine && !isPaused)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: MyMomentMetrics(
                      pause: pauseAnimation,
                      continues: continueAnimating,
                      moment: moments[currentIndex],
                    ),
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
      style: moment.fontType != null ? MomentHelper.textStyleFromJson(moment.fontType!) : null,
      textAlign: TextAlign.center,
    ),
  );
}

Widget mediaPreview({
  required BuildContext context,
  required WidgetRef ref,
  required MomentData moment,
  required VoidCallback pause,
  required VoidCallback resume,
}) {
  final wayaTheme = Theme.of(context);
  return Stack(
    fit: StackFit.expand,
    children: [
      // Media Preview
      if (moment.contentType == "video")
        WayaFutureSubscriber(
          future: WayaFileHelper.getMomentDirectory(moment, moment.content),
          builder: (context, data) {
            if (data == null) {
              return const SizedBox();
            }

            //? Now, return the image moment.
            return VideoPreview(
              content: moment.content,
              file: data,
              data: moment,
              pause: pause,
              resume: resume,
            );
          },
        )
      else
        WayaFutureSubscriber(
          future: WayaFileHelper.getMomentDirectory(moment, moment.content),
          builder: (context, data) {
            if (data == null) {
              return const SizedBox();
            }

            //? Now, return the image moment.
            return ImageMomentScreen(
              media: moment.content,
              data: moment,
              file: data,
              pause: pause,
              resume: resume,
            );
          },
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
            ),
            child: moment.caption!.length < 100
                ? Text(
                    moment.caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: wayaTheme.colorScheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )
                : Text(
                    moment.caption!,
                    style: TextStyle(
                      color: wayaTheme.colorScheme.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
    ],
  );
}
