import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/logic/files.dart';
import 'package:wayagram/features/chat/model/message.dart';

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
  final player = FlutterSoundPlayer(logLevel: Level.error);
  final isPlaying = ValueNotifier(false);
  final canPlay = ValueNotifier(false);

  @override
  void initState() {
    player.openPlayer().then((_) {
      canPlay.value = true;
    });
    player.setSubscriptionDuration(const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    player.closePlayer();
    super.dispose();
  }

  Future<void> _startPlayer() async {
    try {
      final file = getVoiceMessageFile(widget.data);

      // Play the file that has been found.
      await player.startPlayer(
        fromURI: file.uri.path,
        codec: Codec.defaultCodec,
        whenFinished: () {
          player.stopPlayer();
          isPlaying.value = false;
        },
      );

      // This is fine.
      canPlay.value = true;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    //? Our color scheme.
    final buttonColor = widget.isSender ? WayaColors.primary : WayaColors.white;
    final buttonBackground = widget.isSender ? WayaColors.white : WayaColors.primary;
    final trackColor = widget.isSender ? null : WayaColors.primary.withAlpha(10);
    final durationColor = widget.isSender ? WayaColors.white : WayaColors.primary600;

    //? Return this here.
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: ColoredBox(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(5),
          color: WayaColors.primary.withAlpha(10),
          child: ValueListenableBuilder(
            valueListenable: canPlay,
            builder: (context, canStreamPlay, _) {
              //? Now, to check if it is playing.
              return ValueListenableBuilder(
                valueListenable: isPlaying,
                builder: (context, isStreamPlaying, _) {
                  //? Now, we stream the playback for actual progress feed.
                  return StreamBuilder(
                    stream: player.onProgress,
                    builder: (context, data) {
                      final currentPosition = data.data?.position ?? Duration.zero;
                      final totalDuration = data.data?.duration ?? Duration.zero;

                      //? Return the component.
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //? First, the stream pause/play button.
                          if (!canStreamPlay)
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: CircularProgressIndicator(),
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
                                  if (player.isStopped) {
                                    await _startPlayer();
                                  }

                                  // This is fine.
                                  else {
                                    await player.resumePlayer();
                                  }

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
                            child: Slider(
                              min: 0,
                              max: totalDuration.inSeconds.toDouble(),
                              value: player.isStopped ? 0 : currentPosition.inSeconds.toDouble(),
                              allowedInteraction: SliderInteraction.tapAndSlide,
                              onChanged: (value) async {
                                if (player.isStopped) {
                                  await _startPlayer();
                                  isPlaying.value = true;
                                }

                                // Now seek
                                player.seekToPlayer(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),

                          //? Third the playback speed button.

                          //? Finally, the playback duration button.
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              WayaDateHelper.convertDurationToTimestamp(
                                totalDuration - currentPosition,
                              ),
                              style: WayaTextStyles.bodySmall.copyWith(),
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
        ),
      ),
    );
  }
}
