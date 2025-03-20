import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';

class WayaImageDetailScreen extends StatefulWidget {
  final File? file;
  final String? imageUrl;
  const WayaImageDetailScreen(
      {super.key, required this.imageUrl, required this.file});

  @override
  State<WayaImageDetailScreen> createState() => _WayaImageDetailScreenState();
}

class _WayaImageDetailScreenState extends State<WayaImageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
        child: Center(
          child: widget.file != null
              ? IntrinsicHeight(
                child: Image.file(
                    widget.file!,
                    width: size.width,
                    fit: BoxFit.contain,
                  ),
              )
              : IntrinsicHeight(
                child: Image.network(
                    '${widget.imageUrl}',
                    width: size.width,
                    fit: BoxFit.contain,
                  ),
              ),
        ),
      ),
    );
  }
}
