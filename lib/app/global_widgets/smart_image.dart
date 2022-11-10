import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:transparent_image/transparent_image.dart';

class SmartImage extends StatelessWidget {
  final String src;
  final BoxFit? fit;
  final bool isPost;
  final double? radius;

  const SmartImage(this.src,
      {Key? key, this.fit, this.isPost = false, this.radius})
      : super(key: key);

  bool networkImage() => src.startsWith('https');
  //bool base64() => src.contains('[]');

  @override
  Widget build(BuildContext context) {

    return networkImage() ? CachedNetworkImage(
      imageUrl: src, placeholder: (context, url) => Container(
      color: Colors.transparent,
        child: Icon(Icons.image_rounded,color: Colors.grey,size: Get.height*0.05),
    ),
      errorWidget: (context, url, error) => Container(
          color: Colors.transparent,
          child: Icon(Icons.broken_image_rounded,color: Colors.grey,size: Get.height*0.05)
      ),
      fit: fit,
    ) : isPost
        ? Image.file(
                File(src),
                fit: fit,
              )
        : CircleAvatar(
                radius: radius,
                backgroundImage: MemoryImage(
                  imageDecoder(src),
                  //fit: fit,
                ),
              );
  }

  Uint8List imageDecoder(String image) {
    final List<int> list = List<int>.from(jsonDecode(image));
    return Uint8List.fromList(list);
  }
}
