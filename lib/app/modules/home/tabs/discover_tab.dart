import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/app/data/model/TrendingHashtagsModel.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../bindings/wayagram_binding.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_events_entity.dart';
import '../../../data/model/friends_suggestions_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/group_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/helpers/dark_mode_helper.dart';
import '../../search/search.dart';
import '../widgets/HashTagView.dart';
import '../widgets/events_view.dart';
import '../widgets/friends_view.dart';
import '../widgets/group_view.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({Key? key}) : super(key: key);

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerWayagram>(builder: (controller) {
      var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: getAppColor(Colors.blue.shade50),
            width: Get.width,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Trending',
              style: AppTextStyle.headline4.copyWith(
                color: getAppColor(Colors.black),
                fontWeight: FontWeight.normal,
                fontSize: Get.textScaleFactor * 14,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          FutureBuilder<ApiResponse>(
              future: controller.getData("/wayagram-service/all-posts/get-trending-hashtags?profile_id=${fullProfile.id}", true),
              builder: (context, snapshot) {
                var savedPosts = ReadWriteValue('wayagram_trending_hashtags', '', MyPref.box);
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final posts = TrendingHashtagsModel.listFromJson(snapshot.data!.data['data']);
                  savedPosts.val = jsonEncode(posts);
                  List<String> title = [];
                  List<String> subtitle = [];
                  for (var element in posts) {
                    if(element.hashtag != null){
                      title.add(element.hashtag!);
                      if(element.postToHashtags != null){
                        subtitle.add('${element.postToHashtags!.length} Conversations');
                      }else{
                        subtitle.add('0 Conversations');
                      }
                    }
                  }
                  return HashTagView(
                    title: title,
                    subtitle: subtitle,
                    onClick: (title, subtitle) {
                      controller.defaultSearchValue = title;
                      controller.defaultSearchPos = 1;
                      Get.to(() => const Search(),binding: WayagramBinding());
                    },
                  );
                }
                else if(savedPosts.val.isNotEmpty){
                  var posts = TrendingHashtagsModel.listFromJson(jsonDecode(savedPosts.val));
                  List<String> title = [];
                  List<String> subtitle = [];
                  for (var element in posts) {
                    if(element.hashtag != null){
                      title.add(element.hashtag!);
                      if(element.postToHashtags != null){
                        subtitle.add('${element.postToHashtags!.length} Conversations');
                      }else{
                        subtitle.add('0 Conversations');
                      }
                    }
                  }
                  return HashTagView(
                    title: title,
                    subtitle: subtitle,
                    onClick: (title, subtitle) {
                      controller.defaultSearchValue = title;
                      controller.defaultSearchPos = 1;
                      Get.to(() => const Search(),binding: WayagramBinding());
                    },
                  );
                }else{
                  if(snapshot.connectionState == ConnectionState.done){
                    return const SizedBox.shrink();
                  }
                  return const GroupView(isLoading: true);
                }
              }),
          Container(
            color: getAppColor(Colors.blue.shade50),
            width: Get.width,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Groups To Join',
              style: AppTextStyle.headline4.copyWith(
                color: getAppColor(Colors.black),
                fontWeight: FontWeight.normal,
                fontSize: Get.textScaleFactor * 14,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          FutureBuilder<ApiResponse>(
              future: controller.getSuggestedGroups,
              builder: (context, snapshot) {
                var savedPosts = MyPref.suggestedGroups.val;
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                  return GroupView(posts: posts,onButtonClick: (group) async {
                    var body = {
                      "groupId": group.id,
                      "userId": fullProfile.id,
                    };
                    var response = await controller.postData(body, "/wayagram-service/main/group/join-group");
                    if(response.isSuccessful){
                      var newRes = await controller.getData("/wayagram-service/main/group/get-all-user-created-groups?pageNumber=1&userId=${fullProfile.id}", true);
                      if(newRes.isSuccessful){
                        var savedPosts = ReadWriteValue('wayagram_created_groups', '', MyPref.box);
                        final posts = GroupModelEntity.getService(response.groups);
                        savedPosts.val = jsonEncode(posts);
                      }
                      controller.update();
                      setState(() {});
                      Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                    }else{
                      Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },minimum: 5,);
                } else if(savedPosts.isNotEmpty){
                  var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                  return GroupView(posts: posts,onButtonClick: (group) async {
                    var body = {
                      "groupId": group.id,
                      "userId": fullProfile.id,
                    };
                    var response = await controller.postData(body, "/wayagram-service/main/group/join-group");
                    if(response.isSuccessful){
                      var newRes = await controller.getData("/wayagram-service/main/group/get-all-user-created-groups?pageNumber=1&userId=${fullProfile.id}", true);
                      if(newRes.isSuccessful){
                        var savedPosts = ReadWriteValue('wayagram_created_groups', '', MyPref.box);
                        final posts = GroupModelEntity.getService(response.groups);
                        savedPosts.val = jsonEncode(posts);
                      }
                      controller.update();
                      setState(() {});
                      Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                    }else{
                      Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },minimum: 5,);
                }else{
                  if(snapshot.connectionState == ConnectionState.done){
                    return const SizedBox.shrink();
                  }
                  return const GroupView(isLoading: true);
                }
              }),
          FutureBuilder<ApiResponse>(
              future: controller.getFriendSuggestions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final friendsToFollow = snapshot.data!.data as List<FriendsSuggestionsEntity>;
                  if(friendsToFollow.isEmpty){
                    return const SizedBox.shrink();
                  }
                  return FriendsView(data: friendsToFollow);
                } else {
                  var savedEvents = MyPref.friendSuggestions.val;
                  if(savedEvents.isNotEmpty) {
                    var friendsToFollow = FriendsSuggestionsEntity.getService(jsonDecode(savedEvents));
                    return FriendsView(data: friendsToFollow);
                  }else{
                    if(snapshot.connectionState == ConnectionState.done){
                      return const SizedBox.shrink();
                    }
                    return const FriendsView(isLoading: true);
                  }
                }
              }),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 0,
                top: 10
            ),
            child: Container(
              color: getAppColor(Colors.blue.shade50),
              width: Get.width,
              padding: const EdgeInsets.all(8),
              child: Text(
                'Pages To Follow',
                style: AppTextStyle.headline4.copyWith(
                  color: getAppColor(Colors.black),
                  fontWeight: FontWeight.normal,
                  fontSize: Get.textScaleFactor * 14,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          FutureBuilder<ApiResponse>(
              future: controller.getSuggestedPages,
              builder: (context, snapshot) {
                var savedPosts = MyPref.suggestedPages.val;
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                  return GroupView(posts: posts,isGroup: false,
                      onButtonClick: (group) async {
                        var body = {
                          "pageId": group.id,
                          "userId": fullProfile.id,
                        };
                        var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                        if(response.isSuccessful){
                          await controller.getSuggestedPages;
                          await controller.getPagesFollowed;
                          controller.update();
                          setState(() {

                          });
                          Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                        }else{
                          Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      },minimum: 5,);
                } else if(savedPosts.isNotEmpty){
                  var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                  return GroupView(posts: posts,isGroup: false,
                      onButtonClick: (group) async {
                        var body = {
                          "pageId": group.id,
                          "userId": fullProfile.id,
                        };
                        var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                        if(response.isSuccessful){
                          await controller.getSuggestedPages;
                          await controller.getPagesFollowed;
                          controller.update();
                          setState(() {

                          });
                          Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                        }else{
                          Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      },minimum: 5,);
                }else{
                  if(snapshot.connectionState == ConnectionState.done){
                    return const SizedBox.shrink();
                  }
                  return const GroupView(isLoading: true,isGroup: false,);
                }
              }),
          FutureBuilder<ApiResponse>(
              future: controller.getEventsToAttend,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final moments = snapshot.data!.data as AllEventsEntity;
                  if(moments.data == null){
                    return const SizedBox.shrink();
                  }
                  return EventsView(moments: moments.data);
                } else {
                  var savedEvents = MyPref.eventsToAttend.val;
                  if(savedEvents.isNotEmpty) {
                    var events = AllEventsEntity.fromJson(jsonDecode(savedEvents));
                    return EventsView(moments: events.data);
                  }else{
                    if(snapshot.connectionState == ConnectionState.done){
                      return const SizedBox.shrink();
                    }
                    return const EventsView(isLoading: true);
                  }
                }
              }),
        ],
      );
    });
  }
}