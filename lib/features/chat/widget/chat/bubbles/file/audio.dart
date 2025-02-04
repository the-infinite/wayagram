import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
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
  final player = FlutterSoundPlayer(logLevel: Level.error);
  final isPlaying = ValueNotifier(false);
  final canPlay = ValueNotifier(false);

  Codec _getCodec() {
    return switch (widget.extension) {
      "mp3" => Codec.mp3,
      _ => Codec.defaultCodec,
    };
  }

  @override
  void initState() {
    player.openPlayer().then((_) {
      canPlay.value = true;
    });
    player.setSubscriptionDuration(const Duration(milliseconds: 500));
    super.initState();
  }

  Future<void> _startPlayer() async {
    try {
      await player.startPlayer(
        fromURI: widget.audio.uri.path,
        codec: _getCodec(),
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
  void dispose() {
    player.closePlayer();
    canPlay.dispose();
    isPlaying.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    // final size = MediaQuery.sizeOf(context);

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
                                  child: Text(
                                    widget.filename,
                                    maxLines: 1,
                                    style: WayaTextStyles.bodyMedium.copyWith(
                                      color: WayaColors.primary,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
    );
  }
}
