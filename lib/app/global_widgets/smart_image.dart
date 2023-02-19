import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/app/global_widgets/video_player/reusable_video_list_controller.dart';


class SmartImage extends StatefulWidget {
  final String src;
  final BoxFit? fit;
  final bool isPost;
  final double? radius;
  final bool useAspectRatio;
  final bool isSlideShow;
  final ReusableVideoListController videoListController;

  const SmartImage(this.src,
      {Key? key, this.fit, this.isPost = false, this.radius, this.useAspectRatio = false, this.isSlideShow = false, required this.videoListController})
      : super(key: key);

  @override
  State<SmartImage> createState() => _SmartImageState();
}

class _SmartImageState extends State<SmartImage> {
  late BetterPlayerConfiguration betterPlayerConfiguration;
  late BetterPlayerDataSource betterPlayerDataSource;
  BetterPlayerController? controller;

  StreamController<BetterPlayerController?>
  betterPlayerControllerStreamController = StreamController.broadcast();

  bool _initialized = false;
  Timer? _timer;

  @override
  initState() {
    super.initState();
    bool networkImage() => widget.src.startsWith('https');
    //bool isVideo() => getUrlType(widget.src) == UrlType.VIDEO;
    //bool base64() => widget.src.contains('[]');

    if(networkImage()){
      betterPlayerDataSource = BetterPlayerDataSource(
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
    }
    betterPlayerConfiguration = const BetterPlayerConfiguration(
      fit: BoxFit.contain,
      handleLifecycle: false,
      autoDispose: false,
    );
  }

  void _setupController() {
    bool networkImage() => widget.src.startsWith('https');
    if (controller == null) {
      controller = widget.videoListController.getBetterPlayerController();
      if (controller != null) {
        if(networkImage()){
          betterPlayerDataSource = BetterPlayerDataSource(
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
        }else {
          betterPlayerDataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            widget.src,
            cacheConfiguration: BetterPlayerCacheConfiguration(
              useCache: true,
              preCacheSize: 10 * 1024 * 1024,
              maxCacheSize: 10 * 1024 * 1024,
              maxCacheFileSize: 10 * 1024 * 1024,
              key: widget.src,
            ),
          );
        }
        controller!.setupDataSource(betterPlayerDataSource);
        if (!betterPlayerControllerStreamController.isClosed) {
          betterPlayerControllerStreamController.add(controller);
        }
      }
    }
  }

  void _freeController() {
    if (!_initialized) {
      _initialized = true;
      return;
    }
    if (controller != null && _initialized) {
      widget.videoListController.freeBetterPlayerController(controller);
      controller!.pause();
      controller = null;
      if (!betterPlayerControllerStreamController.isClosed) {
        betterPlayerControllerStreamController.add(null);
      }
      _initialized = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool networkImage() => widget.src.startsWith('https');
    bool isVideo() => getUrlType(widget.src) == UrlType.VIDEO;
    //bool base64() => widget.src.contains('[]');

    if(isVideo()){
      return VisibilityDetector(
        key: Key(hashCode.toString() + DateTime.now().toString()),
        onVisibilityChanged: (info) {
          /*if (!widget.canBuildVideo!()) {
            _timer?.cancel();
            _timer = null;
            _timer = Timer(Duration(milliseconds: 500), () {
              if (info.visibleFraction >= 0.6) {
                _setupController();
              } else {
                _freeController();
              }
            });
            return;
          }*/
          if (info.visibleFraction >= 0.2) {
            _setupController();
          } else {
            _freeController();
          }
        },
        child: StreamBuilder<BetterPlayerController?>(
          stream: betterPlayerControllerStreamController.stream,
          builder: (context, snapshot) {
            if(controller!=null){
              return Container(
                  color: Colors.black,
                  child: BetterPlayer(
                    controller: controller!,
                  )
              );
            }
            return Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ));
            /*return AspectRatio(
              aspectRatio: 1,
              child: controller != null ? BetterPlayer(
                controller: controller!,
              ) : Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            );*/
          },
        ),
      );

      if(networkImage()){
        return BetterPlayer(
          controller: BetterPlayerController(betterPlayerConfiguration, betterPlayerDataSource: betterPlayerDataSource),
        );
      }else {
        return BetterPlayer.file(
          widget.src,
          betterPlayerConfiguration: betterPlayerConfiguration,
        );
      }
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
    betterPlayerControllerStreamController.close();
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


  if (typeString == "mp4" || typeString == "avi" || typeString == "mov" || typeString == "mkv" || typeString == "flv" || typeString == "wmv" || typeString == "3gp" || typeString == "webm") {
    return UrlType.VIDEO;
  }

  //add audio type
  if(typeString == "mp3" || typeString == "wav" || typeString == "aac" || typeString == "ogg" || typeString == "wma" || typeString == "flac" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v" || typeString == "m4a" || typeString == "m4p" || typeString == "m4b" || typeString == "m4r" || typeString == "m4v"){
    return UrlType.AUDIO;
  }

  return UrlType.UNKNOWN;
}
