import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';

class WayaVideoDetailScreen extends StatefulWidget {
  final File? file;
  final String? videoUrl;

  // This is fine too.
  const WayaVideoDetailScreen({
    super.key,
    required this.videoUrl,
    required this.file,
  });

  @override
  State<WayaVideoDetailScreen> createState() => _WayaVideoDetailScreenState();
}

class _WayaVideoDetailScreenState extends State<WayaVideoDetailScreen> {
  final controller = WayaVideoController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The both parameters cannot be null.
    assert(widget.videoUrl != null || widget.file != null);

    //? This is the view in question.
    return WayaScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: WayaBackButton(),
      ),
      isLoading: false,
      isScrollable: false,
      body: SafeArea(
        child: widget.file != null
            ? WayaVideoWidget.file(
                widget.file!,
                controller: controller,
                controls: WayaVideoControls.full,
              )
            : WayaVideoWidget.networkUrl(
                Uri.parse(widget.videoUrl!),
                controller: controller,
                controls: WayaVideoControls.full,
              ),
      ),
    );
  }
}
