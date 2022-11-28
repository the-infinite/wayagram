import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/followers_model_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/notification_view.dart';

class Followers extends StatelessWidget {
  const Followers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark
    ),
      child: GetBuilder<HomeController>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Followers', style: AppTextStyle.subtitle1.copyWith(
              color: const Color(0xff4F4F4F),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
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
                        );
                      }else{
                        return const NotificationView(isLoading: true);
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