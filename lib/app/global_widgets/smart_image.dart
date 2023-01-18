import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'helpers/size.dart';

class SmartImage extends StatelessWidget {
  final String src;
  final BoxFit? fit;
  final bool isPost;
  final double? radius;
  final bool useAspectRatio;
  final bool isSlideShow;

  SmartImage(this.src,
      {Key? key, this.fit, this.isPost = false, this.radius, this.useAspectRatio = false, this.isSlideShow = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool networkImage() => src.startsWith('https');
    bool isVideo() => getUrlType(src) == UrlType.VIDEO;
    bool base64() => src.contains('[]');

    if(isVideo()){
      if(networkImage()){
        BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          src,
          cacheConfiguration: BetterPlayerCacheConfiguration(
            useCache: true,
            preCacheSize: 10 * 1024 * 1024,
            maxCacheSize: 10 * 1024 * 1024,
            maxCacheFileSize: 10 * 1024 * 1024,
            key: src,
          ),
        );
        return BetterPlayer(
          controller: BetterPlayerController(const BetterPlayerConfiguration(
            fit: BoxFit.contain,
          ), betterPlayerDataSource: betterPlayerDataSource),
        );
      }else {
        return BetterPlayer.file(
          src,
          betterPlayerConfiguration: const BetterPlayerConfiguration(
            fit: BoxFit.contain,
          ),
        );
      }
    }

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

enum UrlType { IMAGE, VIDEO, AUDIO,UNKNOWN }
UrlType getUrlType(String url) {
  Uri uri = Uri.parse(url);
  String typeString = uri.pathSegments.last.split('.').last;
  if (typeString == "jpg" || typeString == "png" || typeString == "gif" || typeString == "bmp" || typeString == "jpeg" || typeString == "webp" ) {
    return UrlType.IMAGE;
  }


  if (typeString == "mp4" || typeString == "avi" || typeString == "mov" || typeString == "mkv" || typeString == "flv" || typeString == "wmv" || typeString == "3gp") {
    return UrlType.VIDEO;
  }

  //add audio type
  if(typeString == "webm" || typeString == "mp3" || typeString == "wav" || typeString == "aac" || typeString == "ogg" || typeString == "wma" || typeString == "flac" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v"){
    return UrlType.AUDIO;
  }

  return UrlType.UNKNOWN;
}
