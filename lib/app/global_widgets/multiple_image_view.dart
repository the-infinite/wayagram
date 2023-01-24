import 'package:flutter/material.dart';
import 'package:wayagram/app/global_widgets/smart_image.dart';
import 'package:wayagram/app/global_widgets/video_player/reusable_video_list_controller.dart';

import '../../core/theme/app_styles.dart';

class MultipleImageView extends StatelessWidget {
  final List<String> imageUrls;
  final double radius;
  final bool isFile;
  final bool useAspectRatio;
  final bool isSlideShow;
  final ReusableVideoListController videoListController;

  const MultipleImageView({
    Key? key,
    required this.imageUrls,
    this.radius = 10,
    this.isFile = false,
    this.useAspectRatio = false,
    this.isSlideShow = false,
    required this.videoListController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _contentRender(),
    );
  }

  List<Widget> _contentRender() {
    switch (imageUrls.length) {
      case 1:
        return _singleImageView();

      case 2:
        return _twoImageView();

      case 3:
        return _threeImageView();

      case 4:
        return _foureImageView();

      default:
        return _multipleImageView();
    }
  }

  List<Widget> _singleImageView() {
    return [
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SmartImage(
            imageUrls.first,
            fit: BoxFit.cover,
            isPost: true,
            useAspectRatio: useAspectRatio,
            isSlideShow: isSlideShow,videoListController:  videoListController
          ),
        ),
      ),
    ];
  }

  List<Widget> _twoImageView() {
    return [
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
          child: SmartImage(
            imageUrls.first,
            fit: BoxFit.cover,
            isPost: true,
            useAspectRatio: useAspectRatio,
            isSlideShow: isSlideShow,videoListController:  videoListController
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
          child: SmartImage(
            imageUrls.last,
            fit: BoxFit.cover,
            isPost: true,
            useAspectRatio: useAspectRatio,
            isSlideShow: isSlideShow,videoListController:  videoListController
          ),
        ),
      )
    ];
  }

  List<Widget> _threeImageView() {
    return [
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
          child: SmartImage(
            imageUrls[0],
            fit: BoxFit.cover,
            isPost: true,
            useAspectRatio: useAspectRatio,
            isSlideShow: isSlideShow,videoListController:  videoListController
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                ),
                child: SmartImage(
                  imageUrls[1],
                  fit: BoxFit.cover,
                  isPost: true,
                  useAspectRatio: useAspectRatio,
                  isSlideShow: isSlideShow,videoListController:  videoListController
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius:BorderRadius.only(
                  bottomRight: Radius.circular(radius),
                ),
                child: SmartImage(
                  imageUrls[2],
                  fit: BoxFit.cover,
                  isPost: true,
                  useAspectRatio: useAspectRatio,
                  isSlideShow: isSlideShow,videoListController:  videoListController
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _foureImageView() {
    return [
      Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
          child: SmartImage(
            imageUrls[0],
            fit: BoxFit.cover,
            isPost: true,
            useAspectRatio: useAspectRatio,
            isSlideShow: isSlideShow,videoListController:  videoListController
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius:BorderRadius.only(
                  topRight: Radius.circular(radius),
                ),
                child: SmartImage(
                  imageUrls[1],
                  fit: BoxFit.cover,
                  isPost: true,
                  useAspectRatio: useAspectRatio,
                  isSlideShow: isSlideShow,videoListController:  videoListController
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                child: SmartImage(
                  imageUrls[2],
                  fit: BoxFit.cover,
                  isPost: true,
                  useAspectRatio: useAspectRatio,
                  isSlideShow: isSlideShow,videoListController:  videoListController
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(radius),
                ),
                child: SmartImage(
                  imageUrls[3],
                  fit: BoxFit.cover,
                  isPost: true,
                  useAspectRatio: useAspectRatio,
                  isSlideShow: isSlideShow,videoListController:  videoListController
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _multipleImageView() {
    return [
      Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
          child: SmartImage(
            imageUrls[0],
            fit: BoxFit.cover,
            isPost: true,
            useAspectRatio: useAspectRatio,
            isSlideShow: isSlideShow,videoListController:  videoListController
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                ),
                child: SmartImage(
                  imageUrls[1],
                  fit: BoxFit.cover,
                  isPost: true,
                  useAspectRatio: useAspectRatio,
                  isSlideShow: isSlideShow,videoListController:  videoListController
                ),
              ),
            ),
           const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: ClipRRect(
                child: SmartImage(
                  imageUrls[2],
                  fit: BoxFit.cover,
                  isPost: true,
                  useAspectRatio: useAspectRatio,
                  isSlideShow: isSlideShow,videoListController:  videoListController
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(radius),
                    ),
                    child: SmartImage(
                      imageUrls[3],
                      fit: BoxFit.cover,
                      isPost: true,
                      useAspectRatio: useAspectRatio,
                      isSlideShow: isSlideShow,videoListController:  videoListController
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(radius),
                        ),
                      ),
                      child: Text(
                        '+${imageUrls.length - 4}',
                        style: AppTextStyle.subtitle1.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
