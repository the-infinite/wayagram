import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

import 'helpers/size.dart';

class SmartImage extends StatefulWidget {
  final String src;
  final BoxFit? fit;
  final bool isPost;
  final double? radius;
  final bool useAspectRatio;
  final bool isSlideShow;

  const SmartImage(this.src,
      {Key? key, this.fit, this.isPost = false, this.radius, this.useAspectRatio = false, this.isSlideShow = false})
      : super(key: key);

  @override
  State<SmartImage> createState() => _SmartImageState();
}

class _SmartImageState extends State<SmartImage> {
  var aspectRatio = 1.0;
  bool videoLoaded = false;
  late VideoPlayerController controller;
  late ChewieController _chewieController;

  bool networkImage() => widget.src.startsWith('https');
  bool isVideo() => getUrlType(widget.src) == UrlType.VIDEO;
  bool base64() => widget.src.contains('[]');

  @override
  void initState() {
    if(isVideo()){
      if(networkImage()){
        controller = VideoPlayerController.network(widget.src);
        _chewieController = ChewieController(
          videoPlayerController: controller,
          autoInitialize: true,
          autoPlay: false,
          allowFullScreen: false,
          aspectRatio: aspectRatio,
          showControls: widget.isSlideShow,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.purple,
            handleColor: Colors.purple,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.purple[100]!,
          ),
          placeholder: Container(
            color: Colors.black,
          ),
        );
        videoLoaded = true;
      }else{
        controller = VideoPlayerController.file(File(widget.src));
        _chewieController = ChewieController(
          videoPlayerController: controller,
          autoInitialize: true,
          autoPlay: false,
          allowFullScreen: false,
          aspectRatio: aspectRatio,
          showControls: widget.isSlideShow,
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.purple,
            handleColor: Colors.purple,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.purple[100]!,
          ),
          placeholder: Container(
            color: Colors.black,
          ),
        );
        videoLoaded = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isVideo() && videoLoaded){
      if(widget.isSlideShow){
        return Chewie(
          controller: _chewieController,
        );
      }
      if(!widget.useAspectRatio){
        return FittedBox(
          fit: BoxFit.cover,
          child: Chewie(
            controller: _chewieController,
          ),
        );
      }
      return MeasureSize(
        onChange: (size) {
          aspectRatio = size.width / size.height;
          _chewieController = _chewieController.copyWith(
            aspectRatio: aspectRatio,
            showControls: widget.isSlideShow,
          );
          setState(() {
          });
        },
        child: Chewie(
          controller: _chewieController,
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
    controller.dispose();
    _chewieController.dispose();
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
