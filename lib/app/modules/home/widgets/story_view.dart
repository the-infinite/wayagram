import 'dart:convert';

import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/overlays.dart';
import '../../profile/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_avatar.dart';
import '../../profile/other_profile.dart';
import 'bottom_sheet.dart';

class Story extends StatefulWidget {
  const Story({Key? key, required this.storyItems, required this.storyController, required this.momentItems}) : super(key: key);

  final List<StoryItem> storyItems;
  final List<MomentsModelEntity> momentItems;
  final StoryController storyController;

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    var firstItem = widget.momentItems.first;
    ValueKey<MomentsModelEntity> storyKey = widget.storyItems.first.view.key as ValueKey<MomentsModelEntity>;
    if(widget.momentItems.isEmpty || widget.storyItems.isEmpty){
      Get.back();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              StoryView(
                  storyItems: widget.storyItems,
                  controller: widget.storyController,
                  repeat: false,
                  onStoryShow: (s) {
                    ValueKey<MomentsModelEntity> valueKey = s.view.key as ValueKey<MomentsModelEntity>;
                    storyKey = valueKey;
                    firstItem = valueKey.value;
                    controller.update(['bottomBar']);
                  },
                  onComplete: () {
                    Navigator.pop(context);
                  },
                  onVerticalSwipeComplete: (direction) {
                    if (direction == Direction.down) {
                      Navigator.pop(context);
                    }
                  },
                //progressPosition: ProgressPosition.bottom,
              ),
              Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight * 1,right: 10,left: 10),
                child: SizedBox(
                  height: Get.height* 0.08,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          if(firstItem.profile!.userId!=null){
                            if(firstItem.profile!.userId == fullProfile.userId) {
                              Get.to(() => Profile());
                            }else{
                              Get.to(() => OtherProfile(info: [
                                firstItem.profile!.displayName.toString(),
                                firstItem.profile!.username.toString(),
                                firstItem.profile!.avatar.toString(),
                                firstItem.profile!.userId.toString(),
                                firstItem.profile!.bio.toString(),
                                firstItem.profile!.posts.toString(),
                                firstItem.profile!.followers.toString(),
                                firstItem.profile!.followings.toString(),
                                firstItem.profile!.coverImage.toString(),
                                firstItem.profile!.id.toString(),
                                firstItem.profile!.notPublic == true ? "true" : "false"
                              ]));
                            }
                          }else{
                            Get.to(() => OtherProfile(info: [
                              firstItem.profile!.displayName.toString(),
                              firstItem.profile!.username.toString(),
                              firstItem.profile!.avatar.toString(),
                              firstItem.profile!.userId.toString(),
                              firstItem.profile!.bio.toString(),
                              firstItem.profile!.posts.toString(),
                              firstItem.profile!.followers.toString(),
                              firstItem.profile!.followings.toString(),
                              firstItem.profile!.coverImage.toString(),
                              firstItem.profile!.id.toString(),
                              firstItem.profile!.notPublic == true ? "true" : "false"
                            ]));
                          }
                        },
                        child: SizedBox(
                          width: Get.width * 0.13,
                          height: Get.width * 0.13,
                          child: IconButton(
                            icon: AppAvatar(
                              imgUrl: firstItem.userAvatar.toString(),
                              radius: 45,
                            ),
                            onPressed: null,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          if(firstItem.profile!.userId!=null){
                            if(firstItem.profile!.userId == fullProfile.userId) {
                              Get.to(() => Profile());
                            }else{
                              Get.to(() => OtherProfile(info: [
                                firstItem.profile!.displayName.toString(),
                                firstItem.profile!.username.toString(),
                                firstItem.profile!.avatar.toString(),
                                firstItem.profile!.userId.toString(),
                                firstItem.profile!.bio.toString(),
                                firstItem.profile!.posts.toString(),
                                firstItem.profile!.followers.toString(),
                                firstItem.profile!.followings.toString(),
                                firstItem.profile!.coverImage.toString(),
                                firstItem.profile!.id.toString(),
                                firstItem.profile!.notPublic == true ? "true" : "false"
                              ]));
                            }
                          }else{
                            Get.to(() => OtherProfile(info: [
                              firstItem.profile!.displayName.toString(),
                              firstItem.profile!.username.toString(),
                              firstItem.profile!.avatar.toString(),
                              firstItem.profile!.userId.toString(),
                              firstItem.profile!.bio.toString(),
                              firstItem.profile!.posts.toString(),
                              firstItem.profile!.followers.toString(),
                              firstItem.profile!.followings.toString(),
                              firstItem.profile!.coverImage.toString(),
                              firstItem.profile!.id.toString(),
                              firstItem.profile!.notPublic == true ? "true" : "false"
                            ]));
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              firstItem.profile!.displayName.toString(),
                              style: AppTextStyle.bodyText1.copyWith(
                                color: Colors.white ,
                                fontSize: Get.width * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "@${firstItem.profile!.username}",
                              style: AppTextStyle.bodyText1.copyWith(
                                color: Colors.white,
                                fontSize: Get.width * 0.035,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(firstItem.millisecCreatedAt.toString()))),
                              style: AppTextStyle.bodyText1.copyWith(
                                color: Colors.white,
                                fontSize: Get.width * 0.03,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if(firstItem.profile!.id == fullProfile.id)
                              PopupMenuButton(
                                  color: Colors.white,
                                  icon: const Icon(
                                    FeatherIcons.moreHorizontal,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onSelected: (value) {
                                    if (value == 0) {
                                      controller.deleteData(null, "/wayagram-service/all-posts/delete-moment?moment_id=${firstItem.id}&profile_id=${fullProfile.id}").then((value){
                                        if(value.isSuccessful){
                                          widget.momentItems.removeWhere((element) => element.id == firstItem.id);
                                          widget.storyItems.removeWhere((element) => storyKey == element.view.key);

                                          if(widget.momentItems.isEmpty || widget.storyItems.isEmpty){
                                            Get.back();
                                          }else{
                                            firstItem = widget.momentItems[0];
                                            storyKey = widget.storyItems[0].view.key as ValueKey<MomentsModelEntity>;
                                            setState(() {});
                                          }
                                          AppOverlay.showSuccessSnackBar(content : "Moment Deleted Successfully");
                                          controller.update();
                                        }else{
                                          AppOverlay.showErrorSnackBar(content : value.message.toString());
                                        }
                                        widget.storyController.play();
                                      });
                                    }
                                  },
                                  onCanceled: () {
                                    widget.storyController.play();
                                  },
                                  itemBuilder: (context){
                                    widget.storyController.pause();
                                    return [
                                      PopupMenuItem(
                                        value: 0,
                                        child: Text(
                                          "Delete",
                                          style: AppTextStyle.bodyText1.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ];
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: firstItem.profile!.id == fullProfile.id ? GetBuilder<HomeControllerWayagram>(builder: (controller) {
            return InkWell(
              onTap: () async {
                widget.storyController.pause();
                await Get.bottomSheet(
                    MomentViewBottomSheet(
                      buttonText: "Forward",
                      title: 'Views (${shortenCount(firstItem.viewCount.toString()*10)})',
                      onTap: (person) async {

                      }, momentId: '${firstItem.id}',
                    ),
                    isScrollControlled: true, ignoreSafeArea: true,
                );
                widget.storyController.play();
              },
              child: Container(
                height: Get.height * 0.06,
                width: Get.width,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(FeatherIcons.eye),
                      onPressed: () {
                        //Navigator.pop(context);
                      },
                      color: Colors.white.withOpacity(.7),
                    ),
                    if(firstItem.viewCount != null)
                      Text('${shortenCount(firstItem.viewCount.toString())} Views', style: AppTextStyle.subtitle1.copyWith(
                      color: Colors.white.withOpacity(.7),
                      fontSize: Get.textScaleFactor * 16,
                      fontWeight: FontWeight.normal,
                    )),
                    if(firstItem.viewCount == null)
                      Text('${shortenCount("0")} Views', style: AppTextStyle.subtitle1.copyWith(
                        color: Colors.white.withOpacity(.7),
                        fontSize: Get.textScaleFactor * 16,
                        fontWeight: FontWeight.normal,
                      )),
                  ],
                ),
              ),
            );
          },id: 'bottomBar') : null,
        );
      }),
    );
  }
}

String shortenCount(String amount){
  if(amount == "null" || amount.isEmpty){
    return "0";
  }
  if(num.parse(amount) >= 1000000000){
    return "${(num.parse(amount) / 1000000000).toStringAsFixed(1)}B";
  }
  if(amount.length > 6){
    return "${(int.parse(amount) / 1000000).toStringAsFixed(1)}M";
  }
  if(amount.length > 3) {
    var first = amount.substring(0, amount.length - 3);
    var last = amount.substring(amount.length - 1, amount.length);
    return "$first.$last K";
  }
  return amount;
}