import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_events_entity.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/group_model_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../widgets/events_view.dart';
import '../widgets/group_view.dart';
import '../widgets/moments_view.dart';
import '../widgets/posts_view.dart';

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10
            ),
            child: Container(
              color: Colors.blue.shade50,
              width: Get.width,
              padding: const EdgeInsets.all(10),
              child: Text(
                'Groups To Join',
                style: AppTextStyle.headline4.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          FutureBuilder<ApiResponse>(
              future: controller.getSuggestedGroups,
              builder: (context, snapshot) {
                var savedPosts = MyPref.suggestedGroups.val;
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                  return GroupView(posts: posts);
                } else if(savedPosts.isNotEmpty){
                  var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                  return GroupView(posts: posts);
                }else{
                  return const GroupView(isLoading: true);
                }
              }),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 10
            ),
            child: Container(
              color: Colors.blue.shade50,
              width: Get.width,
              padding: const EdgeInsets.all(10),
              child: Text(
                'Pages To Follow',
                style: AppTextStyle.headline4.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
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
                  return GroupView(posts: posts,isGroup: false,);
                } else if(savedPosts.isNotEmpty){
                  var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                  return GroupView(posts: posts,isGroup: false,);
                }else{
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
                    return const EventsView(isLoading: true);
                  }
                }
              }),
        ],
      );
    });
  }
}