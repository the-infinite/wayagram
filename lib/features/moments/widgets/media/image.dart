import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

class ImageMomentScreen extends StatefulWidget {
  final String media;
  final File file;
  final MomentData data;
  final VoidCallback pause, resume;

  // Construct
  const ImageMomentScreen({
    super.key,
    required this.media,
    required this.file,
    required this.data,
    required this.pause,
    required this.resume,
  });

  @override
  State<ImageMomentScreen> createState() => _ImageMomentScreenState();
}

class _ImageMomentScreenState extends State<ImageMomentScreen> {
  bool downloaded = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.file.exists()) {
        try {
          widget.pause();
        } catch (_) {}
        if (mounted) {
          setState(() {
            downloaded = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //? If this file exists...
      if (!await widget.file.exists()) {
        try {
          widget.pause();
        } catch (_) {}
        if (mounted) {
          setState(() {
            downloaded = false;
          });
        }
      }
    });
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    final size = MediaQuery.sizeOf(context);

    //? Return this here.
    if (!downloaded) {
      return StreamBuilder(
        stream: WayaFileRepository.instance.downloadFile(
          widget.media,
          widget.file,
          (result) async {
            if (result) {
              await Future.delayed(const Duration(seconds: 1));
              try {
                widget.resume();
              } catch (_) {}
              setState(() {
                downloaded = true;
              });
            }
          },
        ),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final progress = data?.$1 ?? 0;

          //? This is where it is at.
          return AspectRatio(
            aspectRatio: size.aspectRatio,
            child: Container(
              color: WayaColors.primary50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      value: progress / 100,
                      color: WayaColors.primary300,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    //? Since this is already downloaded...
    else {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: IntrinsicHeight(
            child: Image.file(
              widget.file,
              width: size.width,
              fit: BoxFit.contain,
              errorBuilder: (context, e, _) => CachedNetworkImage(
                imageUrl: widget.media,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }
  }
}
