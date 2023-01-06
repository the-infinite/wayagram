import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'helpers/size.dart';

class SmartImage extends StatefulWidget {
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
  State<SmartImage> createState() => _SmartImageState();
}

class _SmartImageState extends State<SmartImage> {
  double aspectRatio = 16 / 9;
  late BetterPlayerController _betterPlayerController;
  bool networkImage() => widget.src.startsWith('https');
  bool isVideo() => getUrlType(widget.src) == UrlType.VIDEO;
  bool base64() => widget.src.contains('[]');

  @override
  void initState() {
    super.initState();
    if(isVideo()){
      if(networkImage()){
        BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.src,
          cacheConfiguration: BetterPlayerCacheConfiguration(
            useCache: true,
            preCacheSize: 10 * 1024 * 1024,
            maxCacheSize: 10 * 1024 * 1024,
            maxCacheFileSize: 10 * 1024 * 1024,
            key: widget.src,
          ),
        );
        _betterPlayerController = BetterPlayerController(BetterPlayerConfiguration(), betterPlayerDataSource: betterPlayerDataSource);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isVideo()){
      if(widget.isSlideShow){
        if(networkImage()){
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _betterPlayerController,
            ),
          );
        }else {
          return BetterPlayer.file(
            widget.src,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              aspectRatio: 16 / 9,
            ),
          );
        }
      }

      return MeasureSize(
        onChange: (size) {
          aspectRatio = size.width / size.height;
          setState(() {
          });
        },
        child: networkImage() ? AspectRatio(
          aspectRatio: aspectRatio,
          child: BetterPlayer(
            controller: _betterPlayerController,
          ),
        ) : BetterPlayer.file(
          widget.src,
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: aspectRatio,
          ),
        ),
      );
    }

    return networkImage() ? CachedNetworkImage(
      imageUrl: widget.src, placeholder: (context, url) => Container(
      color: Colors.transparent,
      child: Icon(Icons.image_rounded,color: Colors.grey,size: Get.height*0.05),
    ),
      errorWidget: (context, url, error) => Container(
          color: Colors.transparent,
          child: Icon(Icons.broken_image_rounded,color: Colors.grey,size: Get.height*0.05)
      ),
      fit: widget.fit,
    ) : widget.isPost
        ? Image.file(
                File(widget.src),
                fit: widget.fit,
              )
        : CircleAvatar(
                radius: widget.radius,
                backgroundImage: MemoryImage(
                  imageDecoder(widget.src),
                  //fit: fit,
                ),
              );
  }

  @override
  void dispose() {
    super.dispose();
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
