import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wayagram/core/components/components.dart';

class WayaImageDetailScreen extends StatefulWidget {
  final List<File>? file;
  final List<String>? imageUrl;

  const WayaImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.file,
  });

  @override
  State<WayaImageDetailScreen> createState() => _WayaImageDetailScreenState();
}

class _WayaImageDetailScreenState extends State<WayaImageDetailScreen> {
  final pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

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
                ? PageView(
                    controller: pageController,
                    children: List.generate(
                      widget.file!.length,
                      (index) => PhotoView(
                        imageProvider: FileImage(widget.file![index]),
                        minScale: PhotoViewComputedScale.contained * 1,
                        maxScale: PhotoViewComputedScale.covered * 5,
                      ),
                    ),
                  )
                : PageView(
                    controller: pageController,
                    children: List.generate(
                      widget.imageUrl!.length,
                      (index) => PhotoView(
                        imageProvider: NetworkImage(widget.imageUrl![index]),
                        minScale: PhotoViewComputedScale.contained * 1,
                        maxScale: PhotoViewComputedScale.covered * 5,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
