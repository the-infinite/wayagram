library newsfeed_multiple_imageview;

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/global_widgets/smart_image.dart';
import 'package:wayagram/app/global_widgets/video_player/reusable_video_list_controller.dart';

import '../../core/theme/app_styles.dart';
import 'helpers/dark_mode_helper.dart';
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
  final ReusableVideoListController videoListController;

  const NewsfeedMultipleImageView({
    Key? key,
    this.marginLeft = 0,
    this.marginTop = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    required this.imageUrls,
    this.radius = 10,
    this.isFile = false,
    this.useAspectRatio = false,
    this.isSlideShow = false, required this.videoListController,
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
          child: MultipleImageView(imageUrls: imageUrls,radius: radius,isSlideShow: isSlideShow,useAspectRatio: useAspectRatio,videoListController: videoListController,),
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

class ImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialPage;
  const ImageViewer({Key? key,
    required this.imageUrls,
    this.initialPage = 0,
  }) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    var currentPos = 0;
    ReusableVideoListController videoListController = ReusableVideoListController();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light
      ),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              ],
            ),
            leading: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                FeatherIcons.arrowLeft,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              },
              iconSize: Get.width * 0.06,
            ),
            actions: [
              PopupMenuButton(
                color: Colors.white,
                icon: const Icon(Icons.more_vert,color: Colors.white),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                      "Download",
                      style: AppTextStyle.bodyText1.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if(value==0){
                    bool isVideo() => getUrlType(widget.imageUrls[currentPos]) == UrlType.VIDEO;
                    if(isVideo()){
                      GallerySaver.saveVideo(widget.imageUrls[currentPos]).then((val) {
                        if(val == true){
                          AppOverlay.showSuccessSnackBar(content: "Video Downloaded To Device");
                        }
                      });
                    }else{
                      GallerySaver.saveImage(widget.imageUrls[currentPos]).then((val) {
                        if(val == true){
                          AppOverlay.showSuccessSnackBar(content: "Image Downloaded To Device");
                        }
                      });
                    }
                  }
                },
              ),
            ],
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: Container(
                  color: Colors.black,
                  height: 1.0,
                )),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.black,
                systemNavigationBarIconBrightness: Brightness.light
            ),
          ),
          body: SafeArea(
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
                    initialPage: widget.initialPage,
                    indicatorColor: Colors.black,
                    indicatorBackgroundColor: Colors.black,
                    isLoop: widget.imageUrls.length > 1,
                    onPageChanged: (pos){
                       currentPos = pos;
                    },
                    children:widget.imageUrls.asMap().map((key, value){
                      return MapEntry(key, Hero(
                        tag: "photo$key",
                        child: Padding(
                          padding: EdgeInsets.only(bottom: Get.height * 0.025),
                          child: SmartImage(
                            value,
                            fit: BoxFit.contain,
                            isPost: true,
                            useAspectRatio: false,
                            isSlideShow: true,
                            videoListController: videoListController,
                          ),
                        ),
                      ));
                    }).values.toList(),
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


