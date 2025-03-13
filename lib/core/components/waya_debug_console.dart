import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/theme/theme.dart';

class WayaDebugConsole extends StatefulWidget {
  const WayaDebugConsole({super.key});

  @override
  State<WayaDebugConsole> createState() => _WayaDebugConsoleState();
}

class _WayaDebugConsoleState extends State<WayaDebugConsole> {
  Offset position = Offset(15, 70);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If this is defined, remove it.
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size;

    // If we do  not find the renderBox
    if (size == null || renderBox == null) {
      return const SizedBox();
    }

    //? Return this component.
    return ValueListenableBuilder(
      valueListenable: WayaDebugConsoleController.instance.refreshNotifier,
      builder: (context, refreshCount, _) => Stack(
        children: [
          //? Our backdrop to show when this is visible.
          if (WayaDebugConsoleController.instance.visible)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ),
              child: Opacity(
                opacity: 0.6,
                child: SizedBox(
                  child: ModalBarrier(
                    dismissible: true,
                    color: Colors.white,
                    onDismiss: () {
                      WayaDebugConsoleController.instance.collapse();
                    },
                  ),
                ),
              ),
            ),

          //? Next, our console control button.
          Positioned(
            top: position.dy,
            left: position.dx,
            child: GestureDetector(
              onPanUpdate: (details) {
                position = details.globalPosition;
                WayaDebugConsoleController.instance.refresh();
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: WayaColors.primary,
                  shape: BoxShape.circle,
                ),
                child: WayaAssets.icons.bug.svg(
                  color: WayaColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
