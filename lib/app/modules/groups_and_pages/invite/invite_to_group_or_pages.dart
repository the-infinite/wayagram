import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/followers_model_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/group_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/notification_view.dart';

class InviteToGroupOrPage extends StatelessWidget {
  const InviteToGroupOrPage({Key? key,this.isGroup = false, this.isPage = false,this.group,this.page}) : super(key: key);

  final bool isGroup;
  final bool isPage;
  final GroupModelEntity? group;
  final GroupModelEntity? page;

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(isPage ? "Invite To Page" : "Invite To Group", style: AppTextStyle.subtitle1.copyWith(
              color: getAppColor(const Color(0xff4F4F4F)),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<ApiResponse>(
                    future: controller.getFollowers,
                    builder: (context, snapshot) {
                      var savedPosts = MyPref.followers.val;
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts = snapshot.data!.data as FollowersModelEntity;
                        var names = posts.followers!.map((e) => e.displayName.toString()).toList();
                        var username = posts.followers!.map((e) => e.username.toString()).toList();
                        var profile = posts.followers!.map((e) => e.avatar.toString()).toList();
                        var userIds = posts.followers!.map((e) => e.userId.toString()).toList();
                        return PersonView(
                          name: names,
                          username: username,
                          profilePic: profile,
                          length: posts.followers == null ? 0 : posts.followers!.length,
                          userIDs: userIds,
                          followers: posts.followers,
                          showButton: isPage || isGroup,
                          onButtonClick: (val) async {
                            if(isPage) {
                              var body = {
                                "pageId": page!.id,
                                "requestFrom": fullProfile.id,
                                "requestTo": val.id
                              };
                              var response = await controller.postData(body, "/wayagram-service/main/page/invite-to-a-page",updatePages: false);
                              if(response.isSuccessful || response.message.toString().toLowerCase().contains("you have already sent an invite to")){
                                AppOverlay.showSuccessSnackBar(content: "Invitation sent successfully to ${val.displayName}");
                              }else{
                                AppOverlay.showErrorSnackBar(content: "Something went wrong, please try again later");
                              }
                            }else if(isGroup) {
                              var body = {
                                "groupId": group!.id,
                                "requestFrom": fullProfile.id,
                                "requestTo": val.id
                              };
                              var response = await controller.postData(body, "/wayagram-service/main/group/invite-others-to-group",updatePages: false);
                              if(response.isSuccessful|| response.message.toString().toLowerCase().contains("you have already sent an invite to")){
                                AppOverlay.showSuccessSnackBar(content: "Invitation sent successfully to ${val.displayName}");
                              }else{
                                AppOverlay.showErrorSnackBar(content: "Something went wrong, please try again later");
                              }
                            }
                          },
                        );
                      } else if(savedPosts.isNotEmpty){
                        var posts = FollowersModelEntity.fromJson(jsonDecode(savedPosts));
                        var names = posts.followers!.map((e) => e.displayName.toString()).toList();
                        var username = posts.followers!.map((e) => e.username.toString()).toList();
                        var profile = posts.followers!.map((e) => e.avatar.toString()).toList();
                        var userIds = posts.followers!.map((e) => e.userId.toString()).toList();

                        return PersonView(
                          name: names,
                          username: username,
                          profilePic: profile,
                          length: posts.followers == null ? 0 : posts.followers!.length,
                          userIDs: userIds,
                          followers: posts.followers,
                          showButton: isPage || isGroup,
                          onButtonClick: (val) async {
                            if(isPage) {
                              var body = {
                                "pageId": page!.id,
                                "requestFrom": fullProfile.id,
                                "requestTo": val.id
                              };
                              var response = await controller.postData(body, "/wayagram-service/main/page/invite-to-a-page",updatePages: false);
                              if(response.isSuccessful || response.message.toString().toLowerCase().contains("you have already sent an invite to")){
                                AppOverlay.showSuccessSnackBar(content: "Invitation sent successfully to ${val.displayName}");
                              }else{
                                AppOverlay.showErrorSnackBar(content: "Something went wrong, please try again later");
                              }
                            }else if(isGroup) {
                              var body = {
                                "groupId": group!.id,
                                "requestFrom": fullProfile.id,
                                "requestTo": val.id
                              };
                              var response = await controller.postData(body, "/wayagram-service/main/group/invite-others-to-group",updatePages: false);
                              if(response.isSuccessful|| response.message.toString().toLowerCase().contains("you have already sent an invite to")){
                                AppOverlay.showSuccessSnackBar(content: "Invitation sent successfully to ${val.displayName}");
                              }else{
                                AppOverlay.showErrorSnackBar(content: "Something went wrong, please try again later");
                              }
                            }
                          },
                        );
                      }else{
                        return NotificationView(isLoading: true);
                      }
                    }),
              ],
            ),
          ),
        );
      }),
    );
  }
}