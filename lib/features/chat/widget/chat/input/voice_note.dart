import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class ChatVoiceMessageInput extends StatefulWidget {
  final ChatInputController controller;

  /// This is fine.
  const ChatVoiceMessageInput({
    super.key,
    required this.controller,
  });

  @override
  State<ChatVoiceMessageInput> createState() => _ChatVoiceMessageInputState();
}

class _ChatVoiceMessageInputState extends State<ChatVoiceMessageInput> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  final isPlaying = ValueNotifier(false);
  final canPlay = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    // This is fine.
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Fine.
    final size = MediaQuery.sizeOf(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final mySize = renderBox?.size ?? Size(size.width * 0.8, 70);

    //? Fetch
    return IntrinsicHeight(
      child: SizedBox(
        width: size.width,
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: ColoredBox(
            color: WayaColors.primary.withAlpha(40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //? First, the pause and record button.
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: widget.controller.recorderState == RecorderState.recording
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: WayaButton(
                        callback: () async {
                          await widget.controller.pauseRecording();
                        },
                        shape: BoxShape.circle,
                        height: null,
                        color: WayaColors.primary,
                        horizontalPadding: 7,
                        verticalPadding: 7,
                        centerWidget: WayaAssets.icons.cPause.svg(
                          color: WayaColors.white,
                          height: 18,
                          width: 18,
                        ),
                      ),
                      secondChild: WayaButton(
                        callback: () async {
                          widget.controller.resumeRecording();
                        },
                        shape: BoxShape.circle,
                        height: null,
                        color: WayaColors.primary,
                        horizontalPadding: 7,
                        verticalPadding: 7,
                        centerWidget: WayaAssets.icons.cButtonVoicenote.svg(
                          color: WayaColors.white,
                          height: 18,
                          width: 18,
                        ),
                      ),
                    ),

                    // Some space.
                    const Gap(5),

                    //? Second, if this is not currently recording...
                    Expanded(
                      child: AudioWaveforms(
                        size: Size(mySize.width - 130, 30),
                        recorderController: widget.controller.soundRecorder,
                        waveStyle: WaveStyle(
                          spacing: 4,
                          waveThickness: 3,
                          waveColor: WayaColors.primary,
                          durationStyle: WayaTextStyles.bodySmall.copyWith(
                            color: WayaColors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
