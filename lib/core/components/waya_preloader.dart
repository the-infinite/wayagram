import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';

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
    return Container(
      height: size.height,
      width: size.width,
      alignment: Alignment.center,
      color: Colors.black54,
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
    );
  }
}
