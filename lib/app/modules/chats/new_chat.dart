import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../data/socket_models/chat_list_over_view.dart';
import '../../global_widgets/app_refresher.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/notification_view.dart';
import 'chat_screen.dart';


class NewChat extends StatelessWidget{
  NewChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController(initialRefresh: false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<ChatControllerWayagram>(id:'new_chats_screen',builder: (chatController) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarColor: getAppColor(AppColors.background),
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: getAppColor(AppColors.background),
              systemNavigationBarIconBrightness: Brightness.dark
          ),
          child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
            var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
            var currentPage = ReadWriteValue('wayagram_following_current_page', 1, MyPref.box);
            var savedPosts = MyPref.following.val;
            var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
            return Scaffold(
              appBar: AppBar(
                backgroundColor: getAppColor(AppColors.background),
                title: Text('New Chat', style: AppTextStyle.subtitle1.copyWith(
                  color: Color(0xff4F4F4F),
                  fontSize: Get.textScaleFactor * 18,
                  fontWeight: FontWeight.bold,
                )),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(FeatherIcons.arrowLeft, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                bottom: PreferredSize(
                    preferredSize: Size(Get.width, 0.5),
                    child: Column(
                      children: [
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ],
                    )),
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: getAppColor(AppColors.background),
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.dark,
                    systemNavigationBarColor: getAppColor(AppColors.background),
                    systemNavigationBarIconBrightness: Brightness.dark
                ),
              ),
              body: AppRefresher(
                onRefresh: () async {
                  final response = await controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=1',true);
                  if(response.isSuccessful){
                    var posts = FollowingModelEntity.fromJson(response.data);
                    if(posts.following != null){
                      if(posts.following!.isNotEmpty && savedPosts.isNotEmpty){
                        var saved = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                        if(saved.following!.isNotEmpty){
                          var first = saved.following!.first;
                          var current = posts.following!.first;
                          if(first.id != current.id){
                            posts.following = saved.following! + posts.following!;
                            MyPref.following.val = jsonEncode(posts);
                          }
                        }else{
                          MyPref.following.val = jsonEncode(response.data);
                        }
                      }
                    }
                  }
                  refreshController.refreshCompleted();
                  controller.update();
                },
                onLoading: () async {
                  final response = await controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=${currentPage.val}',true);
                  if(response.isSuccessful){
                    var posts = FollowingModelEntity.fromJson(response.data);
                    var saved = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                    for (var element in posts.following!) {
                      saved.following!.removeWhere((e) => e.id == element.id);
                    }
                    saved.following!.addAll(posts.following!);
                    MyPref.following.val = jsonEncode(saved);
                    if(posts.following!.isNotEmpty){
                      currentPage.val = currentPage.val + 1;
                    }
                  }
                  refreshController.loadComplete();
                  controller.update();
                },
                controller: refreshController,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<ApiResponse>(
                          future: controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=1',true),
                          builder: (context, snapshot) {
                            var savedPosts = MyPref.following.val;
                            if(savedPosts.isNotEmpty){
                              var posts = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                              var names = posts.following!.map((e) => e.displayName.toString()).toList();
                              var username = posts.following!.map((e) => e.username.toString()).toList();
                              var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                              var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                              return PersonView(
                                name: names,
                                username: username,
                                profilePic: profile,
                                length: posts.following == null ? 0 : posts.following!.length,
                                userIDs: userIds,
                                following: posts.following,
                                showButton: true,
                                buttonName: "Message",
                                onButtonClick: (person) async{
                                  ChatOverview chatOverview = ChatOverview();
                                  chatOverview.id = person.id.toString();
                                  chatOverview.chatId = "${fullProfile.userId}_${person.id.toString().hashCode}";
                                  chatOverview.otherId = person.id;
                                  chatOverview.otherImageURL = person.coverImage;
                                  chatOverview.otherUserName = person.username;
                                  chatOverview.otherDisplayName = person.displayName;
                                  Get.to(() => ChatScreen(chatOverview: chatOverview));
                                },
                              );
                            }else{
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                var posts = FollowingModelEntity.fromJson(snapshot.data!.data);
                                var names = posts.following!.map((e) => e.displayName.toString()).toList();
                                var username = posts.following!.map((e) => e.username.toString()).toList();
                                var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                                var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                                MyPref.following.val = jsonEncode(posts);
                                currentPage.val = 2;
                                return PersonView(
                                  name: names,
                                  username: username,
                                  profilePic: profile,
                                  length: posts.following == null ? 0 : posts.following!.length,
                                  userIDs: userIds,
                                  following: posts.following,
                                  showButton: true,
                                  buttonName: "Message",
                                  onButtonClick: (person) async{
                                      ChatOverview chatOverview = ChatOverview();
                                      chatOverview.id = person.id.toString();
                                      chatOverview.chatId = "${fullProfile.userId}_${person.id.toString().hashCode}";
                                      chatOverview.otherId = person.id;
                                      chatOverview.otherImageURL = person.coverImage;
                                      chatOverview.otherUserName = person.username;
                                      chatOverview.otherDisplayName = person.displayName;
                                    Get.to(() => ChatScreen(chatOverview: chatOverview));
                                  },
                                );
                              }
                              return NotificationView(isLoading: true);
                            }
                          }),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}