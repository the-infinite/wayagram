import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/ugt/my_contest_details/full_media_view.dart';

class MediaCard extends StatefulWidget {
  final List<CardMediaContent> mediaUrls;
  final Function(String, MyFullMediaType)?
      ontap; // List of image and video URLs

  const MediaCard({super.key, required this.mediaUrls, this.ontap});

  @override
  _MediaCardState createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> {
  final PageController _pageController = PageController();
  //int _currentPage = 0;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoIfNeeded(0);
  }

  void _initializeVideoIfNeeded(int index) {
    String url = widget.mediaUrls[index].url ?? "";
    // String type = ??"";
    if (widget.mediaUrls[index].type?.toLowerCase() == "video") {
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          setState(() {});
          // _videoController?.play();
          // _videoController?.setLooping(true);
        });
    }
  }

  void _pauseVideo() {
    if (_videoController != null && _videoController!.value.isPlaying) {
      _videoController!.pause();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaUrls.length,
              onPageChanged: (index) {
                //setState(() => _currentPage = index);
                _initializeVideoIfNeeded(index);
              },
              itemBuilder: (context, index) {
                String url = widget.mediaUrls[index].url ?? "";
                // String type = ??"";
                if (widget.mediaUrls[index].type?.toLowerCase() == "video") {
                  return _videoController != null &&
                          _videoController!.value.isInitialized
                      ? VisibilityDetector(
                          key: UniqueKey(),
                          onVisibilityChanged: (visibilityInfo) {
                            //on scrolling pass the card
                            if (visibilityInfo.visibleFraction == 0) {
                              _pauseVideo(); // Pause video when the card is out of view
                            } else {
                              // Play video when the card is in view
                              // Check if the video is not playing and the page is not the first page
                              if (_videoController != null &&
                                  !_videoController!.value.isPlaying) {
                                _videoController!.play();
                              //  _videoController?.setLooping(true);
                              } else {
                                // Check if the video is playing and the page is not the first page
                                // Pause the video
                                if (_videoController != null &&
                                    !_videoController!.value.isPlaying) {
                                  _pageController.animateToPage(0,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                }
                              }
                            }
                          },
                          child: GestureDetector(
                              onTap: () {
                                //play or pause video on tap
                                if (_videoController != null &&
                                    _videoController!.value.isPlaying) {
                                  _videoController!.pause();
                                } else {
                                  _videoController!.play();
                                }
                              },
                              child: Stack(
                                children: [
                                  VideoPlayer(_videoController!),
                                  Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.ontap!(
                                                  url, MyFullMediaType.video) ??
                                              () {};
                                        },
                                        child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.fullscreen,
                                              color: Colors.white,
                                            )),
                                      )),
                                ],
                              )))
                      : Center(child: CircularProgressIndicator());
                } else if (widget.mediaUrls[index].type?.toLowerCase() ==
                    "image") {
                  _videoController?.pause();
                  return GestureDetector(
                    onTap: () {
                      widget.ontap!(url, MyFullMediaType.image) ?? () {};
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          16), // Adjust the radius as needed
                      child: WayaImage(
                        imageUrl: url,
                        height: 200,
                        width: context.width,
                        fit: BoxFit.cover, // Ensur
                        //  radius: BorderRadius.circular(45),
                      ),

                      /*  Image.network(
                    post.mediaContent?[0].url ?? "",
                    height: 200,
                    width: context.width,
                    fit: BoxFit
                        .cover, // Ensures the image covers the area properly
                                    ), */
                    ),
                  );
                  // return Image.network(url, fit: BoxFit.cover);
                } else {
                  return Container();
                }
              },
            ),
          ),
          SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.mediaUrls.length,
            effect: ExpandingDotsEffect(
              activeDotColor: wayaTheme.primaryColor,
              dotColor: Colors.grey,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CardMediaContent {
  String? type;
  String? url;

  CardMediaContent({this.type, this.url});

  CardMediaContent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}
