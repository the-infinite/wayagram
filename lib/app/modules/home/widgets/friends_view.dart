import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_events_entity.dart';
import '../../../data/model/following_model_entity.dart';
import '../../../data/model/friends_suggestions_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_avatar.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/overlays.dart';
import '../../profile/other_profile.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({
    Key? key,
    this.isLoading = false,
    this.data = const [],
  }) : super(key: key);

  final bool isLoading;
  final List<FriendsSuggestionsEntity> data;

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            color: Colors.blue.shade50,
            width: Get.width,
            padding: EdgeInsets.all(8),
            child: Text(
              'People To Follow',
              style: AppTextStyle.headline4.copyWith(
                color: getAppColor(Colors.black),
                fontWeight: FontWeight.normal,
                fontSize: Get.textScaleFactor * 14,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.25,
          width: Get.width,
          child: ListView.builder(
            itemCount: widget.isLoading ? 5 : widget.data.length,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            // physics: widget.isLoading ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if(widget.isLoading){
                return SizedBox(
                  height: Get.height * 0.18,
                  width: Get.width * 0.35,
                  child: Shimmer.fromColors(
                    baseColor: getAppColor(Colors.grey).withOpacity(0.8),
                    highlightColor: getAppColor(Colors.grey).withOpacity(0.2),
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                      height: Get.height * 0.18,
                      width: Get.width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: getAppColor(Colors.grey).withOpacity(.5),
                      ),
                    ),
                  ),
                );
              }
              var person = widget.data[index];
              //var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
              var isFollowing = false;
              if(MyPref.following.val.isNotEmpty){
                var following = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
                isFollowing = following.following!.any((element) => element.username == person.username);
              }

              return GetBuilder<HomeControllerWayagram>(
                  builder: (controller) {
                    return InkWell(
                      onTap: (){
                        var displayName = person.displayName.toString();
                        var username = person.username.toString();
                        var profilePic = person.avatar.toString();
                        var userID = person.userId.toString();
                        var postCount = person.posts.toString();
                        var followersCount = person.followers.toString();
                        var followingCount = person.followings.toString();
                        var bio = person.bio.toString();
                        var coverImage = person.coverImage.toString();

                        Get.to(() => OtherProfile(),arguments: [displayName, username, profilePic, userID, bio,postCount,followersCount,followingCount,coverImage,person.id.toString(),person.notPublic == true ? "true" : "false"]);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 5, bottom: 3.7, left: 5,right: 5),
                        width: Get.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: getAppColor(Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: getAppColor(Colors.grey).withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(
                              width: Get.width * 0.13,
                              height: Get.width * 0.13,
                              child: AppAvatar(
                                imgUrl: person.avatar.toString(),
                                radius: Get.width * 0.1,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.0025),
                            Text(
                              person.displayName.toString(),
                              style: TextStyle(
                                color: getAppColor(Colors.black) ,
                                fontSize: Get.width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "@${person.username}",
                              style: TextStyle(
                                color: getAppColor(Colors.grey),
                                fontSize: Get.width * 0.04,
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: Get.height * 0.02),
                            SizedBox(
                              width: Get.width * 0.3,
                              child: AppButton(
                                title: isFollowing ? 'Following' : 'Follow',
                                onPressed: () async {
                                  var body = {
                                    "user_id": person.userId,
                                    "username": person.username
                                  };

                                  if(!isFollowing){
                                    var response = await controller.postData(body, "wayagram-service/graph/friend/follow");
                                    if(response.isSuccessful){
                                      if(response.message.toString().toLowerCase().contains("request")){
                                        AppOverlay.showSuccessSnackBar(content :"Friend request sent successfully");
                                      }
                                      await controller.getFollowing;
                                      //await controller.getPosts;
                                      setState(() {

                                      });
                                    }else{
                                      if(response.message.toString().toLowerCase().contains("request")){
                                        AppOverlay.showSuccessSnackBar(content :"Friend request sent successfully");
                                      }else{
                                        AppOverlay.showErrorSnackBar();
                                      }
                                    }
                                  }else{
                                    var response = await controller.postData(body, "wayagram-service/graph/friend/unfollow");
                                    if(response.isSuccessful){
                                      await controller.getFollowing;
                                      //await controller.getPosts;
                                      setState(() {

                                      });
                                    }
                                  }
                                },
                                borderRadius: 10,
                                fontColor: isFollowing ? AppColors.primary : getAppColor(AppColors.background),
                                bckgrndColor: isFollowing ? getAppColor(AppColors.background) : AppColors.primary,
                                border: Border.all(color: AppColors.primary, width: 1),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: Get.height * 0.01),
                                fontSize: Get.width * 0.04,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.01),
                          ],
                        ),
                      ),
                    );
                  },
              );
            },
          ),
        ),
      ],
    );
  }
}