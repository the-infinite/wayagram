library newsfeed_multiple_imageview;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayagram/app/global_widgets/smart_image.dart';

import 'multiple_image_view.dart';


class NewsfeedMultipleImageView extends StatelessWidget {

  final List<String> imageUrls;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double radius;
  final bool isFile;
  final bool useAspectRatio;
  final bool isSlideShow;

  NewsfeedMultipleImageView({
    Key? key,
    this.marginLeft = 0,
    this.marginTop = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    required this.imageUrls,
    this.radius = 10,
    this.isFile = false,
    this.useAspectRatio = false,
    this.isSlideShow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, costraints) => Container(
        width: costraints.maxWidth,
        height: costraints.maxWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey[200],
        ),
        margin: EdgeInsets.fromLTRB(
          marginLeft,
          marginTop,
          marginRight,
          marginBottom,
        ),
        child: GestureDetector(
          child: MultipleImageView(imageUrls: imageUrls,radius: radius,isSlideShow: isSlideShow,useAspectRatio: useAspectRatio),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewer(imageUrls: imageUrls),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  ImageViewer({Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light
      ),
      child: Scaffold(body: SafeArea(
        bottom: false,
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ImageSlideshow(
                    initialPage: 0,
                    indicatorColor: Colors.red,
                    indicatorBackgroundColor: Colors.grey,
                    isLoop: imageUrls.length > 1,
                    children: imageUrls
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(bottom: Get.height * 0.025),
                            child: SmartImage(
                              e,
                              fit: BoxFit.contain,
                              isPost: true,
                              useAspectRatio: false,
                              isSlideShow: true,
                            ),
                          ),
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}


