import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wayagram/core/components/components.dart';

class WayaImageDetailScreen extends StatefulWidget {
  final File? file;
  final String? imageUrl;
  const WayaImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.file,
  });

  @override
  State<WayaImageDetailScreen> createState() => _WayaImageDetailScreenState();
}

class _WayaImageDetailScreenState extends State<WayaImageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    //? The both parameters cannot be null.
    assert(widget.imageUrl != null || widget.file != null, "This must contain either a file or a network URL");
    assert(widget.imageUrl == null || widget.file == null, "The two properties cannot have non-null values");

    //? Show the widget.
    return WayaScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: WayaBackButton(),
      ),
      isLoading: false,
      isScrollable: false,
      body: ColoredBox(
        color: Colors.black,
        child: SafeArea(
          child: Center(
            child: widget.file != null
                ? PhotoView(
                    imageProvider: FileImage(widget.file!),
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 5,
                  )
                : PhotoView(
                    imageProvider: NetworkImage(widget.imageUrl!),
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 5,
                  ),
          ),
        ),
      ),
    );
  }
}
