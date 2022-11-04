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
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/blocked_accounts_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/notification_view.dart';

class PrivacySettings extends StatelessWidget {
  const PrivacySettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();
    var page = 0;

    var blockedTextController = TextEditingController(text: "0");
    var mutedTextController = TextEditingController(text: "0");

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
              title: Text('Privacy Settings', style: AppTextStyle.subtitle1.copyWith(
                color: Colors.black,
              )),
              centerTitle: false,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                ToggleSwitch(
                  minWidth: Get.width * 0.5,
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  inactiveBgColor: AppColors.background,
                  activeBgColor: const [AppColors.background, AppColors.background],
                  activeBorders: [
                    //Bottom Border
                    Border.all(
                      color: AppColors.background,
                      width: 3.0,
                    ),
                    Border.all(
                      color: AppColors.background,
                      width: 3.0,
                    ),
                  ],
                  radiusStyle: true,
                  cornerRadius: 10.0,
                  labels: ['Muted Users(${mutedTextController.text})', 'Blocked Users(${blockedTextController.text})'],
                  customTextStyles: [
                    AppTextStyle.bodyText1.copyWith(
                      color: page == 0 ? AppColors.primary : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    AppTextStyle.bodyText1.copyWith(
                      color: page == 1 ? AppColors.primary : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                  onToggle: (index) {
                    page = index!;
                    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                SizedBox(
                  height: Get.height * 0.7,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      page = index;
                      controller.update();
                    },
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
                              mutedTextController.text = posts.length.toString();
                              return PersonView(
                                name: names,
                                username: username,
                                profilePic: profile,
                                length: posts.length,
                              );
                            } else if(savedPosts.isNotEmpty){
                              var posts = BlockedAccountsEntity.getService(jsonDecode(savedPosts));
                              var names = posts.map((e) => e.displayName.toString()).toList();
                              var username = posts.map((e) => e.username.toString()).toList();
                              var profile = posts.map((e) => e.avatar.toString()).toList();
                              mutedTextController.text = posts.length.toString();
                              return PersonView(
                                name: names,
                                username: username,
                                profilePic: profile,
                                length: posts.length,
                              );
                            }else{
                              return const NotificationView(isLoading: true);
                            }
                          }),
                      FutureBuilder<ApiResponse>(
                          future: controller.getBlocked,
                          builder: (context, snapshot) {
                            var savedPosts = MyPref.restrictedAccounts.val;
                            if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                              final posts = snapshot.data!.data as List<BlockedAccountsEntity>;
                              var names = posts.map((e) => e.displayName.toString()).toList();
                              var username = posts.map((e) => e.username.toString()).toList();
                              var profile = posts.map((e) => e.avatar.toString()).toList();
                              blockedTextController.text = posts.length.toString();
                              //controller.update();
                              return PersonView(
                                name: names,
                                username: username,
                                profilePic: profile,
                                length: posts.length,
                              );
                            } else if(savedPosts.isNotEmpty){
                              var posts = BlockedAccountsEntity.getService(jsonDecode(savedPosts));
                              var names = posts.map((e) => e.displayName.toString()).toList();
                              var username = posts.map((e) => e.username.toString()).toList();
                              var profile = posts.map((e) => e.avatar.toString()).toList();
                              blockedTextController.text = posts.length.toString();

                              return PersonView(
                                name: names,
                                username: username,
                                profilePic: profile,
                                length: posts.length,
                              );
                            }else{
                              return const NotificationView(isLoading: true);
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}