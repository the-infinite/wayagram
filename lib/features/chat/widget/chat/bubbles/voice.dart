import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/logic/files.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';

enum _PlaybackSpeed {
  normal(1),
  slightlyFast(1.25),
  faster(1.5),
  evenFaster(1.75),
  twiceAsFast(2);

  const _PlaybackSpeed(this.value);
  final double value;
}

_PlaybackSpeed _getNext(_PlaybackSpeed value) {
  return switch (value) {
    _PlaybackSpeed.normal => _PlaybackSpeed.slightlyFast,
    _PlaybackSpeed.slightlyFast => _PlaybackSpeed.faster,
    _PlaybackSpeed.faster => _PlaybackSpeed.evenFaster,
    _PlaybackSpeed.evenFaster => _PlaybackSpeed.twiceAsFast,
    _PlaybackSpeed.twiceAsFast => _PlaybackSpeed.normal,
  };
}

class VoiceMessageWidget extends StatefulWidget {
  final MessageModel data;
  final bool isSender;

  // Construct.
  const VoiceMessageWidget({
    super.key,
    required this.data,
    required this.isSender,
  });

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  late final PlayerController player = PlayerController();
  late final isSender = ConversationState.self.id == widget.data.senderId;
  final isPlaying = ValueNotifier(false);
  final canPlay = ValueNotifier(true);
  final playbackSpeed = ValueNotifier(_PlaybackSpeed.normal);
  late final waveStyle = PlayerWaveStyle(
    fixedWaveColor: (isSender ? WayaColors.white : WayaColors.primary).withAlpha(120),
    liveWaveColor: isSender ? WayaColors.white : WayaColors.primary,
    spacing: 4,
    waveThickness: 3,
  );

  //? How many times we have extracted wave form data.
  bool extracted = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final file = getVoiceMessageFile(widget.data);
      final size = MediaQuery.sizeOf(context);
      final renderBox = context.findRenderObject() as RenderBox?;
      final mySize = renderBox?.size ?? Size(size.width * 0.8, 70);
      await player.preparePlayer(
        path: file.absolute.path,
        shouldExtractWaveform: true,
        noOfSamples: waveStyle.getSamplesForWidth(mySize.width - 130),
      );
      canPlay.value = true;
      player.onCompletion.listen((state) {
        player.seekTo(0);
        isPlaying.value = false;
      });
      player.setFinishMode(finishMode: FinishMode.pause);
    });
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Our screen size.
    final size = MediaQuery.sizeOf(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final mySize = renderBox?.size ?? Size(size.width * 0.8, 70);

    //? Our color scheme.
    final buttonColor = widget.isSender ? WayaColors.primary : WayaColors.white;
    final buttonBackground = widget.isSender ? WayaColors.white : WayaColors.primary;
    // final trackColor = widget.isSender ? null : WayaColors.primary.withAlpha(10);
    final durationColor = widget.isSender ? WayaColors.white : WayaColors.primary600;

    //? Return this here.
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: canPlay,
        builder: (context, canStreamPlay, _) {
          //? Now, to check if it is playing.
          return ValueListenableBuilder(
            valueListenable: isPlaying,
            builder: (context, isStreamPlaying, _) {
              //? Now, we stream the playback for actual progress feed.
              return StreamBuilder(
                stream: player.onCurrentDurationChanged,
                builder: (context, data) {
                  final currentPosition = Duration(milliseconds: data.data ?? 0);
                  final totalDuration = Duration(milliseconds: player.maxDuration);

                  //? Return the component.
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //? First, the stream pause/play button.
                      if (!canStreamPlay)
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                            color: buttonBackground,
                          ),
                        )
                      else
                        //? First, the pause/play icon.
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: isStreamPlaying ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          firstChild: WayaButton(
                            callback: () {
                              player.pausePlayer();
                              isPlaying.value = !isStreamPlaying;
                            },
                            shape: BoxShape.circle,
                            height: null,
                            color: buttonBackground,
                            horizontalPadding: 10,
                            verticalPadding: 10,
                            centerWidget: WayaAssets.icons.cPause.svg(
                              color: buttonColor,
                              height: 18,
                              width: 18,
                            ),
                          ),
                          secondChild: WayaButton(
                            callback: () async {
                              await player.startPlayer();

                              // Then do this.
                              isPlaying.value = !isStreamPlaying;
                            },
                            shape: BoxShape.circle,
                            height: null,
                            color: buttonBackground,
                            horizontalPadding: 10,
                            verticalPadding: 10,
                            centerWidget: WayaAssets.icons.cPlay.svg(
                              color: buttonColor,
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),

                      // Some space.
                      const Gap(10),

                      //? Second, the slider used to navigate inside of a stream.
                      Expanded(
                        child: AudioFileWaveforms(
                          size: Size(mySize.width - 130, 30),
                          playerController: player,
                          playerWaveStyle: waveStyle,
                          waveformType: WaveformType.fitWidth,
                        ),
                      ),

                      // Some space.
                      const Gap(10),

                      //? Third the playback speed button.
                      ValueListenableBuilder(
                        valueListenable: playbackSpeed,
                        builder: (context, currentSpeed, _) {
                          return WayaButton(
                            callback: () async {
                              final next = _getNext(currentSpeed);

                              //? This is fine.
                              if (await player.setRate(next.value)) {
                                playbackSpeed.value = next;
                              }
                            },
                            radius: 20,
                            height: null,
                            text: "${currentSpeed.value.toStringAsFixed(2)}x",
                            textColor: buttonColor,
                            color: buttonBackground,
                            textStyle: WayaTextStyles.bodySmall.copyWith(
                              fontSize: 14,
                              color: buttonColor,
                            ),
                          );
                        },
                      ),

                      //? Finally, the playback duration button.
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          WayaDateHelper.convertDurationToTimestamp((totalDuration - currentPosition)),
                          style: WayaTextStyles.bodySmall.copyWith(
                            color: durationColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
