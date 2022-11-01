import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wayagram/app/modules/home/widgets/story_view.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../global_widgets/app_avatar.dart';

class MomentsView extends StatefulWidget {
  const MomentsView({
    Key? key,
    this.isLoading = false,
    this.moments,
  }) : super(key: key);

  final bool isLoading;
  final List<MomentsModelEntity>? moments;

  @override
  State<MomentsView> createState() => _MomentsViewState();
}

class _MomentsViewState extends State<MomentsView> {
  var userID = "";
  List<MomentsModelEntity> list = [];

  @override
  Widget build(BuildContext context) {
    final storyController = StoryController();
    widget.moments?.forEach((element) {
      if (element.profileId != userID) {
        list.add(element);
        userID = element.profileId.toString();
      }
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Text(
            'Moments',
            style: AppTextStyle.headline4.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: Get.height * 0.20,
          width: Get.width,
          child: ListView.builder(
            itemCount: widget.isLoading ? 5 : list.length,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if(widget.isLoading){
                return SizedBox(
                  height: Get.height * 0.18,
                  width: Get.width * 0.35,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.8),
                    highlightColor: Colors.grey.withOpacity(0.2),
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                      height: Get.height * 0.18,
                      width: Get.width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(.5),
                      ),
                    ),
                  ),
                );
              }
              return InkWell(
                onTap: (){
                  List<StoryItem> storyItems = [];
                  widget.moments?.forEach((element) {
                    if (element.profileId == list[index].profileId) {
                      storyItems.add(
                        StoryItem.pageImage(
                          url: element.image.toString(),
                          controller: storyController,
                          imageFit: BoxFit.contain,
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  });
                  Get.to(
                    () => Story(storyItems: storyItems, storyController: storyController),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                  height: Get.height * 0.18,
                  width: Get.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(.5),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            list[index].image.toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.10,
                                height: Get.width * 0.10,
                                child: IconButton(
                                  icon: AppAvatar(
                                    imgUrl: list[index].profile!.avatar.toString(),
                                    radius: Get.width * 0.09,
                                  ),
                                  onPressed: null,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.2,
                                child: Text(
                                  list[index].profile!.displayName.toString().split(" ")[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.width * 0.04,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}