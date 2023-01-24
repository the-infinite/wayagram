import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/blocked_accounts_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/notification_view.dart';

class Muted extends StatelessWidget {
  const Muted({Key? key}) : super(key: key);

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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text('Muted Users', style: AppTextStyle.subtitle1.copyWith(
              color: getAppColor(const Color(0xff4F4F4F)),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 0.5),
                child: Column(
                  children: const [
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ],
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
                    future: controller.getMuted,
                    builder: (context, snapshot) {
                      var savedPosts = MyPref.mutedAccounts.val;
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts = snapshot.data!.data as List<BlockedAccountsEntity>;
                        var names = posts.map((e) => e.displayName.toString()).toList();
                        var username = posts.map((e) => e.username.toString()).toList();
                        var profile = posts.map((e) => e.avatar.toString()).toList();
                        var userIds = posts.map((e) => e.userId.toString()).toList();
                        return PersonView(
                          name: names,
                          username: username,
                          profilePic: profile,
                          length: posts.length,
                          userIDs: userIds,
                          blocked: posts,
                        );
                      } else if(savedPosts.isNotEmpty){
                        var posts = BlockedAccountsEntity.getService(jsonDecode(savedPosts));
                        var names = posts.map((e) => e.displayName.toString()).toList();
                        var username = posts.map((e) => e.username.toString()).toList();
                        var profile = posts.map((e) => e.avatar.toString()).toList();
                        var userIds = posts.map((e) => e.userId.toString()).toList();
                        return PersonView(
                          name: names,
                          username: username,
                          profilePic: profile,
                          length: posts.length,
                          userIDs: userIds,
                          blocked: posts,
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