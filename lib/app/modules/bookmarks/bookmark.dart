import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../controllers/home_controller.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';

import '../home/widgets/posts_view.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {

  @override
  Widget build(BuildContext context) {
    //var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "bookmark_page",builder: (controller) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Bookmarks",
              style: TextStyle(
                color: getAppColor(const Color(0xff4F4F4F)),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black))
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: getAppColor(const Color(0xffEDEAEA)),
                  height: 1.0,
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: getAppColor(AppColors.background),
            child: Padding(
              padding: EdgeInsets.only(left: Get.width*0.008,right: Get.width*0.008),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<ApiResponse>(
                        future: controller.getBookmarks,
                        builder: (context, snapshot) {
                          var savedPosts = MyPref.bookmarks.val;
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
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}