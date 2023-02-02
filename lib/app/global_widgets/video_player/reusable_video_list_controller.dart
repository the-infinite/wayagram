import 'package:better_player/better_player.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableVideoListController {
  final List<BetterPlayerController> _betterPlayerControllerRegistry = [];
  final List<BetterPlayerController> _usedBetterPlayerControllerRegistry = [];

  ReusableVideoListController() {
    for (int index = 0; index < 3; index++) {
      _betterPlayerControllerRegistry.add(
        BetterPlayerController(
          const BetterPlayerConfiguration(
              handleLifecycle: false,
              autoDispose: false,
              fit: BoxFit.contain,
              expandToFill: false,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                  enableOverflowMenu: false,
                  enablePlayPause: false,
                  enableSkips: false,
                  playIcon: Icons.play_arrow_rounded,
                  pauseIcon: Icons.pause_rounded,
                  fullscreenEnableIcon: Icons.fullscreen_rounded,
                  fullscreenDisableIcon: Icons.fullscreen_exit_rounded,
                  skipBackIcon: Icons.replay_10_rounded,
                  skipForwardIcon: Icons.forward_10_rounded,
                  muteIcon: Icons.volume_up_rounded,
                  unMuteIcon: Icons.volume_off_rounded,
                  enableFullscreen: false,
                controlBarColor: Colors.black26
              )
          ),
        ),
      );
    }
  }

  BetterPlayerController? getBetterPlayerController() {
    final freeController = _betterPlayerControllerRegistry.firstWhereOrNull((controller) => !_usedBetterPlayerControllerRegistry.contains(controller));

    if (freeController != null) {
      _usedBetterPlayerControllerRegistry.add(freeController);
    }

    return freeController;
  }

  void freeBetterPlayerController(BetterPlayerController? betterPlayerController) {
    _usedBetterPlayerControllerRegistry.remove(betterPlayerController);
  }

  void dispose() {
    for (var controller in _betterPlayerControllerRegistry) {
      controller.dispose();
    }
  }
}