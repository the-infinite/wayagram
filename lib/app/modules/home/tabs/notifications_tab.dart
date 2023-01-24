import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/EventInvites.dart';
import '../../../data/model/FriendRequest.dart';
import '../../../data/model/GroupInvites.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/notification_model_entity.dart';
import '../../../data/model/page_invites.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/helpers/dark_mode_helper.dart';
import '../../profile/other_profile.dart';
import '../../search/search.dart';
import '../widgets/notification_view.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> with TickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    return GetBuilder<HomeControllerWayagram>(id:"notification_tab",builder: (controller) {
      return SizedBox(
        width: Get.width,
        height: Get.height*0.78,
        child: TabBarView(
          controller: controller.notificationController,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<ApiResponse>(
                      future: controller.getNotification,
                      builder: (context, snapshot) {
                        var savedPosts = MyPref.notifications.val;
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                          final posts = snapshot.data!.data as NotificationModelEntity;
                          return NotificationView(moments: posts.data!);
                        } else if(savedPosts.isNotEmpty){
                          var posts = NotificationModelEntity.fromJson(jsonDecode(savedPosts));
                          return NotificationView(moments: posts.data!);
                        }else{
                          return NotificationView(isLoading: true);
                        }
                      }),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: tabController,
                  padding: EdgeInsets.zero,
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xff9A9A9A),
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.only(left: Get.width * 0.02),
                  indicatorPadding: EdgeInsets.zero,
                  tabs: const [
                    Tab(text: 'Friend',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Events',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Groups',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Pages',iconMargin: EdgeInsets.zero,),
                  ],
                ),
                const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getData("/wayagram-service/graph/friend/requests?user_id=${fullProfile.userId}&page=1&limit=40", true),
                                  builder: (context, snapshot) {
                                    var savedPosts = ReadWriteValue('wayagram_friend_requests', '', MyPref.box);
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = FriendRequest.fromJsonList(snapshot.data!.data['data']);
                                      savedPosts.val = jsonEncode(posts);
                                      if(posts.isEmpty){
                                        return SizedBox(
                                          height: Get.height*0.7,
                                            child: const Center(child: Text('No Friend Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body = {
                                                                "user_id": fullProfile.userId,
                                                                "username": post.profile!.username
                                                              };
                                                              var response = await controller.postData(body, "/wayagram-service/graph/friend/accept-request");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Friend Request Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body = {
                                                                "user_id": post.profile!.userId.toString(),
                                                                "username": post.profile!.username.toString()
                                                              };
                                                              var response = await controller.postData(body, "/wayagram-service/graph/friend/decline-request");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Friend Request Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if(savedPosts.val.isNotEmpty){
                                      var posts = FriendRequest.fromJsonList(jsonDecode(savedPosts.val));
                                      if(posts.isEmpty){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Friend Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body = {
                                                                "user_id": fullProfile.userId,
                                                                "username": post.profile!.username
                                                              };
                                                              var response = await controller.postData(body, "/wayagram-service/graph/friend/accept-request");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Friend Request Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body = {
                                                                "user_id": post.profile!.userId.toString(),
                                                                "username": post.profile!.username.toString()
                                                              };
                                                              var response = await controller.postData(body, "/wayagram-service/graph/friend/decline-request");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Friend Request Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }else{
                                      if(snapshot.connectionState == ConnectionState.done){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Friend Requests'),));
                                      }
                                      return NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getData("/wayagram-service/all-posts/get-a-user-events-invitations?page=1", true),
                                  builder: (context, snapshot) {
                                    var savedPosts = ReadWriteValue('wayagram_events_invites', '', MyPref.box);
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = EventInvites.fromJsonList(snapshot.data!.data['data']);
                                      savedPosts.val = jsonEncode(posts);
                                      if(posts.isEmpty){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Events Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body =  {
                                                                "event_id": post.eventId.toString(),
                                                                "action": "accept"
                                                              };
                                                              var response = await controller.patchData(body, "/wayagram-service/all-posts/accept-or-reject-invites");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Event Invitation Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body =  {
                                                                "event_id": post.eventId.toString(),
                                                                "action": "reject"
                                                              };
                                                              var response = await controller.patchData(body, "/wayagram-service/all-posts/accept-or-reject-invites");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Event Invitation Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if(savedPosts.val.isNotEmpty){
                                      var posts = EventInvites.fromJsonList(jsonDecode(savedPosts.val));
                                      if(posts.isEmpty){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Events Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body =  {
                                                                "event_id": post.eventId.toString(),
                                                                "action": "accept"
                                                              };
                                                              var response = await controller.patchData(body, "/wayagram-service/all-posts/accept-or-reject-invites");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Event Invitation Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body =  {
                                                                "event_id": post.eventId.toString(),
                                                                "action": "reject"
                                                              };
                                                              var response = await controller.patchData(body, "/wayagram-service/all-posts/accept-or-reject-invites");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Event Invitation Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }else{
                                      if(snapshot.connectionState == ConnectionState.done){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Events Requests'),));
                                      }
                                      return NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getData("/wayagram-service/main/group/get-all-groups-invites?pageNumber=1&userId=${fullProfile.id}", true),
                                  builder: (context, snapshot) {
                                    var savedPosts = ReadWriteValue('wayagram_group_invites', '', MyPref.box);
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = GroupInvites.fromJsonList(snapshot.data!.data);
                                      savedPosts.val = jsonEncode(posts);
                                      if(posts.isEmpty){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Group Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body = {
                                                                "groupId": post.groupId.toString(),
                                                                "requestFrom": post.requestFrom.toString(),
                                                                "requestTo": post.requestTo.toString(),
                                                                "groupInviteId": post.id,
                                                                "accepted": true
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/group/respond-to-group-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Group Invite Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body = {
                                                                "groupId": post.groupId.toString(),
                                                                "requestFrom": post.requestFrom.toString(),
                                                                "requestTo": post.requestTo.toString(),
                                                                "groupInviteId": post.id,
                                                                "accepted": false
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/group/respond-to-group-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Group Invite Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if(savedPosts.val.isNotEmpty){
                                      var posts = GroupInvites.fromJsonList(jsonDecode(savedPosts.val));
                                      if(posts.isEmpty){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Group Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body = {
                                                                "groupId": post.groupId.toString(),
                                                                "requestFrom": post.requestFrom.toString(),
                                                                "requestTo": post.requestTo.toString(),
                                                                "groupInviteId": post.id,
                                                                "accepted": true
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/group/respond-to-group-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Group Invite Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body = {
                                                                "groupId": post.groupId.toString(),
                                                                "requestFrom": post.requestFrom.toString(),
                                                                "requestTo": post.requestTo.toString(),
                                                                "groupInviteId": post.id,
                                                                "accepted": false
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/group/respond-to-group-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Group Invite Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }else{
                                      if(snapshot.connectionState == ConnectionState.done){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Group Requests'),));
                                      }
                                      return NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<ApiResponse>(
                                  future: controller.getData("/wayagram-service/main/page/get-all-pages-invitation?pageNumber=1&userId=${fullProfile.id}", true),
                                  builder: (context, snapshot) {
                                    var savedPosts = ReadWriteValue('wayagram_page_invites', '', MyPref.box);
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                      final posts = PageInvites.fromJsonList(snapshot.data!.data);
                                      savedPosts.val = jsonEncode(posts);
                                      if(posts.isEmpty){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Page Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body = {
                                                                "pageFollowInviteId": post.id,
                                                                "pageId": post.pageId,
                                                                "requestFrom": post.requestFrom,
                                                                "requestTo": post.requestTo,
                                                                "accepted": true
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/page/respond-to-page-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Page Invite Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body = {
                                                                "pageFollowInviteId": post.id,
                                                                "pageId": post.pageId,
                                                                "requestFrom": post.requestFrom,
                                                                "requestTo": post.requestTo,
                                                                "accepted": false
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/page/respond-to-page-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Page Invite Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if(savedPosts.val.isNotEmpty){
                                      var posts = PageInvites.fromJsonList(jsonDecode(savedPosts.val));
                                      if(posts.isEmpty){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Page Requests'),));
                                      }
                                      return ListView.builder(
                                        itemCount: posts.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var post = posts[index];
                                          return InkWell(
                                            onTap: (){
                                              Get.to(() => OtherProfile(info: [
                                                post.profile!.displayName.toString(),
                                                post.profile!.username.toString(),
                                                post.profile!.avatar.toString(),
                                                post.profile!.userId.toString(),
                                                post.profile!.bio.toString(),
                                                post.profile!.posts.toString(),
                                                post.profile!.followers.toString(),
                                                post.profile!.followings.toString(),
                                                post.profile!.coverImage.toString(),
                                                post.profile!.id.toString(),
                                                post.profile!.notPublic == true ? "true" : "false"
                                              ]));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: Get.height*0.04,
                                                    width: Get.height*0.04,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: AppAvatar(
                                                      imgUrl: post.profile!.avatar.toString(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width*0.8,
                                                        child: HashTagText(text: post.content.toString(), decoratedStyle: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                          color: Colors.black,
                                                          fontSize: Get.textScaleFactor * 17,
                                                          fontWeight: FontWeight.w500,),
                                                          softWrap: true,
                                                          onTap: (text) {
                                                            controller.defaultSearchValue = text;
                                                            Get.to(() => Search());
                                                          },
                                                          decorateAtSign: true,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: Get.textScaleFactor * 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                      SizedBox(height: Get.height*0.01,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          AppButton(
                                                            title: "Accept",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            border: Border.all(color: AppColors.primary),
                                                            onPressed: () async {
                                                              var body = {
                                                                "pageFollowInviteId": post.id,
                                                                "pageId": post.pageId,
                                                                "requestFrom": post.requestFrom,
                                                                "requestTo": post.requestTo,
                                                                "accepted": true
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/page/respond-to-page-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Page Invite Accepted Successfully");
                                                                controller.update(["notification_tab"]);
                                                                controller.getFollowing;
                                                                controller.getFollowers;
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(width: Get.width*0.02,),
                                                          AppButton(
                                                            title: "Reject",
                                                            width: Get.width*0.35,
                                                            padding: EdgeInsets.symmetric(vertical: Get.height*0.01),
                                                            bckgrndColor: getAppColor(AppColors.background),
                                                            border: Border.all(color: AppColors.primary),
                                                            fontColor: AppColors.primary,
                                                            onPressed: () async {
                                                              var body = {
                                                                "pageFollowInviteId": post.id,
                                                                "pageId": post.pageId,
                                                                "requestFrom": post.requestFrom,
                                                                "requestTo": post.requestTo,
                                                                "accepted": false
                                                              };
                                                              var response = await controller.putData(body, "/wayagram-service/main/page/respond-to-page-invite");
                                                              if(response.isSuccessful){
                                                                AppOverlay.showSuccessSnackBar(content: "Page Invite Declined Successfully");
                                                                controller.update(["notification_tab"]);
                                                              }else{
                                                                AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please Try Again");
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }else{
                                      if(snapshot.connectionState == ConnectionState.done){
                                        return SizedBox(
                                            height: Get.height*0.7,
                                            child: const Center(child: Text('No Page Requests'),));
                                      }
                                      return NotificationView(isLoading: true);
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}