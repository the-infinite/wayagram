import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/controller/preloader.dart';

class WayaPreloaderOverlay extends StatefulWidget {
  const WayaPreloaderOverlay({super.key});

  @override
  State<WayaPreloaderOverlay> createState() => _WayaPreloaderOverlayState();
}

class _WayaPreloaderOverlayState extends State<WayaPreloaderOverlay> {
  final showTwo = ValueNotifier(CrossFadeState.showFirst);
  final showThree = ValueNotifier(CrossFadeState.showFirst);
  Timer? _timer;
  int step = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _timer = Timer.periodic(
          const Duration(milliseconds: 500),
          (timer) async {
            //? If this is showing only the first icon
            if (step == 1) {
              step = 2;
              showTwo.value = CrossFadeState.showSecond;
              return;
            }

            //? If this is showing the second one too.
            if (step == 2) {
              step = 3;
              showThree.value = CrossFadeState.showSecond;

              //? Then this is dismissed.
              if (WayaPreloaderController.instance.hideOnEnd) {
                await Future.delayed(const Duration(milliseconds: 250));
                WayaPreloaderController.instance.dismiss();
              }

              //? Moving forward.
              return;
            }

            //? Since this is showing both, reset everything.
            step = 1;
            showTwo.value = showThree.value = CrossFadeState.showFirst;
          },
        );
      },
    );
    super.initState();
  }

  @override
  void reassemble() {
    _timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _timer = Timer.periodic(
          const Duration(milliseconds: 500),
          (timer) {
            //? If this is showing only the first icon
            if (step == 1) {
              step = 2;
              showTwo.value = CrossFadeState.showSecond;
              return;
            }

            //? If this is showing the second one too.
            if (step == 2) {
              step = 3;
              showThree.value = CrossFadeState.showSecond;
              return;
            }

            //? Since this is showing both, reset everything.
            step = 1;
            showTwo.value = showThree.value = CrossFadeState.showFirst;
          },
        );
      },
    );
    super.reassemble();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // This is fine.
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          //? Our background.
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: Opacity(
              opacity: 0.6,
              child: SizedBox(
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          //? Now the actual component.
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //? The first preloader icon.
                WayaAssets.icons.preloader1.svg(
                  height: 50,
                ),

                //? The second preloader icon.
                Transform.translate(
                  offset: Offset(-5.w, 0),
                  child: ValueListenableBuilder(
                    valueListenable: showTwo,
                    builder: (context, state, _) {
                      return AnimatedCrossFade(
                        firstChild: const SizedBox(height: 50),
                        secondChild: WayaAssets.icons.preloader2.svg(
                          height: 50,
                        ),
                        crossFadeState: state,
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                      );
                    },
                  ),
                ),

                //? The third preloader icon.
                Transform.translate(
                  offset: Offset(-10.w, 0),
                  child: ValueListenableBuilder(
                    valueListenable: showThree,
                    builder: (context, state, _) {
                      return AnimatedCrossFade(
                        firstChild: const SizedBox(height: 50),
                        secondChild: WayaAssets.icons.preloader3.svg(
                          height: 50,
                        ),
                        crossFadeState: state,
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WayaPreloaderProgressBar extends StatefulWidget {
  final double height;
  final double width;

  // Construct.
  const WayaPreloaderProgressBar({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  State<WayaPreloaderProgressBar> createState() => _WayaPreloaderProgressBarState();
}

class _WayaPreloaderProgressBarState extends State<WayaPreloaderProgressBar> {
  final showTwo = ValueNotifier(CrossFadeState.showFirst);
  final showThree = ValueNotifier(CrossFadeState.showFirst);
  Timer? _timer;
  int step = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _timer = Timer.periodic(
          const Duration(milliseconds: 500),
          (timer) async {
            //? If this is showing only the first icon
            if (step == 1) {
              step = 2;
              showTwo.value = CrossFadeState.showSecond;
              return;
            }

            //? If this is showing the second one too.
            if (step == 2) {
              step = 3;
              showThree.value = CrossFadeState.showSecond;
              return;
            }

            //? Since this is showing both, reset everything.
            step = 1;
            showTwo.value = showThree.value = CrossFadeState.showFirst;
          },
        );
      },
    );
    super.initState();
  }

  @override
  void reassemble() {
    _timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        _timer = Timer.periodic(
          const Duration(milliseconds: 500),
          (timer) {
            //? If this is showing only the first icon
            if (step == 1) {
              step = 2;
              showTwo.value = CrossFadeState.showSecond;
              return;
            }

            //? If this is showing the second one too.
            if (step == 2) {
              step = 3;
              showThree.value = CrossFadeState.showSecond;
              return;
            }

            //? Since this is showing both, reset everything.
            step = 1;
            showTwo.value = showThree.value = CrossFadeState.showFirst;
          },
        );
      },
    );
    super.reassemble();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //? The first preloader icon.
          WayaAssets.icons.preloader1.svg(
            height: widget.height,
          ),

          //? The second preloader icon.
          Transform.translate(
            offset: Offset((-widget.height / 10).w, 0),
            child: ValueListenableBuilder(
              valueListenable: showTwo,
              builder: (context, state, _) {
                return AnimatedCrossFade(
                  firstChild: SizedBox(height: widget.height),
                  secondChild: WayaAssets.icons.preloader2.svg(
                    height: widget.height,
                  ),
                  crossFadeState: state,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                );
              },
            ),
          ),

          //? The third preloader icon.
          Transform.translate(
            offset: Offset((-widget.height / 5).w, 0),
            child: ValueListenableBuilder(
              valueListenable: showThree,
              builder: (context, state, _) {
                return AnimatedCrossFade(
                  firstChild: SizedBox(height: widget.height),
                  secondChild: WayaAssets.icons.preloader3.svg(
                    height: widget.height,
                  ),
                  crossFadeState: state,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
