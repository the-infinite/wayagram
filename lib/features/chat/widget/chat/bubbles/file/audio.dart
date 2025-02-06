import 'dart:io';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class AudioFileWidget extends StatefulWidget {
  final File audio;
  final int index, totalSize;
  final String extension, filename;
  final bool interactive;
  final ChatInputController? controller;
  final MessageModel? message;

  // Construct.
  const AudioFileWidget({
    super.key,
    required this.audio,
    required this.totalSize,
    required this.index,
    required this.interactive,
    required this.extension,
    required this.filename,
    this.controller,
    this.message,
  });

  @override
  State<AudioFileWidget> createState() => _AudioFileWidgetState();
}

class _AudioFileWidgetState extends State<AudioFileWidget> {
  late final isSender = (ConversationState.self.id == widget.message?.id) || widget.interactive;
  late final waveStyle = PlayerWaveStyle(
    fixedWaveColor: (isSender ? WayaColors.white : WayaColors.primary).withAlpha(20),
    liveWaveColor: isSender ? WayaColors.white : WayaColors.primary,
    spacing: 4,
    waveThickness: 3,
  );
  final PlayerController player = PlayerController();
  final isPlaying = ValueNotifier(false);
  final canPlay = ValueNotifier(false);
  bool extracted = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final size = MediaQuery.sizeOf(context);
      final renderBox = context.findRenderObject() as RenderBox?;
      final mySize = renderBox?.size ?? Size(size.width * 0.8, 70);
      await player.preparePlayer(
          path: widget.audio.absolute.path,
          shouldExtractWaveform: true,
          noOfSamples: waveStyle.getSamplesForWidth(mySize.width - 70));
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
    canPlay.dispose();
    isPlaying.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final size = MediaQuery.sizeOf(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final mySize = renderBox?.size ?? Size(size.width * 0.8, 70);

    //? Return this here.
    return Padding(
      padding: widget.index == min(widget.totalSize - 1, 2) ? EdgeInsets.zero : const EdgeInsets.only(bottom: 10),
      child: ClipPath(
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
            child: SizedBox(
              width: size.width,
              child: Stack(
                children: [
                  //? First, the audio file itself.
                  ValueListenableBuilder(
                      valueListenable: canPlay,
                      builder: (context, canStreamPlay, _) {
                        //? Now, to check if it is playing.
                        return ValueListenableBuilder(
                            valueListenable: isPlaying,
                            builder: (context, isStreamPlaying, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //? If this cannot be played...
                                  if (!canStreamPlay)
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: CircularProgressIndicator(),
                                    )
                                  else
                                    //? First, the pause/play icon.
                                    AnimatedCrossFade(
                                      duration: const Duration(milliseconds: 200),
                                      crossFadeState:
                                          isStreamPlaying ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      firstChild: WayaButton(
                                        callback: () {
                                          player.pausePlayer();
                                          isPlaying.value = !isStreamPlaying;
                                        },
                                        shape: BoxShape.circle,
                                        height: null,
                                        color: WayaColors.primary,
                                        horizontalPadding: 10,
                                        verticalPadding: 10,
                                        centerWidget: WayaAssets.icons.cPause.svg(
                                          color: WayaColors.white,
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                      secondChild: WayaButton(
                                        callback: () async {
                                          //? This is fine.
                                          await player.startPlayer();

                                          // Then do this.
                                          isPlaying.value = !isStreamPlaying;
                                        },
                                        shape: BoxShape.circle,
                                        height: null,
                                        color: WayaColors.primary,
                                        horizontalPadding: 10,
                                        verticalPadding: 10,
                                        centerWidget: WayaAssets.icons.cPlay.svg(
                                          color: WayaColors.white,
                                          height: 18,
                                          width: 18,
                                        ),
                                      ),
                                    ),

                                  // Some space.
                                  const Gap(10),

                                  //? Second, the file's name.
                                  Expanded(
                                    child: Column(
                                      children: [
                                        //? The wave form.
                                        AudioFileWaveforms(
                                          size: Size(mySize.width - 70, 30),
                                          playerController: player,
                                          playerWaveStyle: waveStyle,
                                          waveformType: WaveformType.fitWidth,
                                        ),

                                        //? The file name.
                                        Text(
                                          widget.filename,
                                          maxLines: 1,
                                          style: WayaTextStyles.bodyMedium.copyWith(
                                            color: WayaColors.primary,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      }),

                  //* Only if this is interactive...
                  if (widget.interactive) ...[
                    //? Second, the overlay..
                    ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: ColoredBox(
                        color: Colors.black.withAlpha(120),
                      ),
                    ),

                    //? Third, the remove button.
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => widget.controller?.removeFile(widget.index),
                        constraints: BoxConstraints(
                          minHeight: 0,
                          minWidth: 0,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.all(2),
                        ),
                        icon: WayaAssets.icons.cMultiplyCircle.svg(
                          color: WayaColors.greyColor400,
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
