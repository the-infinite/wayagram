import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wayagram/app/modules/home/widgets/story_view.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_avatar.dart';
import '../tabs/create_moment.dart';

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
  void initState() {
    super.initState();
    list.clear();
    widget.moments?.forEach((element) {
      if (element.profileId != userID) {
        if(!list.contains(element)){
          list.add(element);
          userID = element.profileId.toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final storyController = StoryController();
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

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
              fontSize: Get.textScaleFactor * 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: Get.height * 0.18,
          width: Get.width,
          child: ListView.builder(
            itemCount: widget.isLoading ? 10 : (list.length+1),
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              if(widget.isLoading){
                return SizedBox(
                  height: Get.height * 0.18,
                  width: Get.width * 0.28,
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
              if(i == 0){
                return InkWell(
                  onTap: (){
                    Get.to(() => const CreateMoment());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                    height: Get.height * 0.15,
                    width: Get.width * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(.5),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                          ),
                          child: SizedBox(
                            height: Get.height * 0.19,
                            width: Get.width * 0.3,
                            child: CachedNetworkImage(
                              imageUrl: (fullProfile.avatar as String?).toString(),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return const Icon(
                                  IconlyLight.profile,
                                  color: Colors.black,
                                  size: 25,
                                );
                              },
                              width: Get.width * 0.3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Get.width * 0.01,
                            bottom: Get.height * 0.005,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: Get.width * 0.07,
                                width: Get.width * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                      onPressed: (){
                                        Get.to(() => const CreateMoment());
                                      },
                                      icon: const Icon(Icons.add_circle_rounded),color: Colors.grey.withOpacity(.8),
                                    iconSize: Get.width * 0.06,
                                  ),
                                ),
                              ),
                              SizedBox(width: Get.width *0.01),
                              BorderedText(
                                strokeWidth: 2.0,
                                child: Text(
                                  "Create",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.width * 0.035,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              var index = i-1;
              return InkWell(
                onTap: (){
                  List<StoryItem> storyItems = [];
                  List<MomentsModelEntity> momentItems = [];
                  widget.moments?.forEach((element) {
                    if (element.profileId == list[index].profileId) {
                      momentItems.add(element);
                      if(element.image != null){
                        var image = element.image.toString();
                        var caption = element.text;

                        storyItems.add(
                          StoryItem.pageImage(
                            url: image,
                            controller: storyController,
                            imageFit: BoxFit.contain,
                            duration: const Duration(seconds: 5),
                            caption: caption,
                            key: ValueKey(element),
                          ),
                        );
                      }else{
                        storyItems.add(
                            StoryItem.text(
                              title: element.text.toString(),
                              backgroundColor: Colors.black,
                              textStyle: AppTextStyle.headline4.copyWith(color: Colors.white),
                              key: ValueKey(element),
                            )
                        );
                      }
                    }
                  });
                  Get.to(
                    () => Story(storyItems: storyItems, storyController: storyController,momentItems: momentItems),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                  height: Get.height * 0.18,
                  width: Get.width * 0.28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
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
                          child: list[index].image != null ? Image.network(list[index].image.toString(), fit: BoxFit.cover,) : Center(
                            child: Text(
                              list[index].text.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.width * 0.03,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Expanded(
                                //width: Get.width * 0.15,
                                child: Text(
                                  (list[index].profile!.displayName.toString().split(" ")[0]),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Get.width * 0.035,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
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