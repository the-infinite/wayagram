import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../widgets/moments_view.dart';
import '../widgets/posts_view.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    return GetBuilder<HomeController>(
        id: 'home_tab',
        builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<ApiResponse>(
              future: controller.getMoments,
              builder: (context, snapshot) {
                var saved = MyPref.moments.val;
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final moments = snapshot.data!.data as List<MomentsModelEntity>;
                  return MomentsView(moments: moments);
                } else if(saved.isNotEmpty) {
                  var posts = MomentsModelEntity.getService(jsonDecode(saved));
                  return MomentsView(moments: posts);
                }else{
                  return const MomentsView(isLoading: true);
                }
              }),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              top: 15,
            ),
            child: Text(
              'Posts',
              style: AppTextStyle.headline4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder<ApiResponse>(
              future: controller.getPosts,
              builder: (context, snapshot) {
                var savedPosts = MyPref.posts.val;
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                  final posts = snapshot.data!.data as List<AllPostsEntity>;
                  return PostsView(posts: posts);
                } else if(savedPosts.isNotEmpty){
                  var posts = AllPostsEntity.getService(jsonDecode(savedPosts));
                  return PostsView(posts: posts);
                }else{
                  if(snapshot.connectionState == ConnectionState.done){
                    return const SizedBox.shrink();
                  }
                  return const PostsView(isLoading: true);
                }
              }),
        ],
      );
    });
  }
}