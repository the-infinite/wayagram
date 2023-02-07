import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/app/data/model/account_model_entity.dart';
import 'package:wayagram/app/modules/multiplexor/multiplexor.dart';
import 'package:wayagram/app/modules/top_clips/top_clips.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../main.dart';
import '../bindings/wayagram_binding.dart';
import '../controllers/home_controller.dart';
import '../data/model/followers_model_entity.dart';
import '../data/model/following_model_entity.dart';
import '../data/model/friends_model_entity.dart';
import '../data/model/full_user_profile_entity.dart';
import '../data/model/profile_model_entity.dart';
import '../data/providers/my_pref.dart';
import '../modules/activity_log/activity_log.dart';
import '../modules/bookmarks/bookmark.dart';
import '../modules/events/all_events.dart';
import '../modules/groups_and_pages/groups_and_pages.dart';
import '../modules/interests/add_interests.dart';
import '../modules/profile/profile.dart';
import '../modules/promotion/promotion_analytics.dart';
import '../modules/settings/settings.dart';
import '../modules/support/support.dart';
import 'app_avatar.dart';
import 'app_button.dart';
import 'helpers/dark_mode_helper.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  static const String route = "/drawer";

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var homeController = Get.find<HomeControllerWayagram>();

  @override
  void initState() {
    super.initState();
    homeController.userRepo.getFriends().then((value) {
      homeController.userRepo.getAccountNumber().then((value) {
        if(mounted){
          setState(() {

          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var followers = 0;
    var following = 0;
    var accountNumber = '';
    var bankName = '';
    //var friends = FriendsModelEntity.fromJson(jsonDecode(MyPref.friends.val));
    //if(MyPref.friends.val.isNotEmpty){
      //var friends = FriendsModelEntity.fromJson(jsonDecode(MyPref.friends.val));
      //followers = friends.followers!;
      //following = friends.following!;
   // }
    if(MyPref.account.val.isNotEmpty){
      var account = AccountModelEntity.fromJson(jsonDecode(MyPref.account.val));
      accountNumber = account.accountNumber!;
      bankName = account.bankName!;
    }

    if(MyPref.followers.val.isNotEmpty) {
      var follower = FollowersModelEntity.fromJson(jsonDecode(MyPref.followers.val));
      followers = follower.followers!.length;
    }

    if(MyPref.following.val.isNotEmpty) {
      var follow = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
      following = follow.following!.length;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: getAppColor(AppColors.background),
            statusBarIconBrightness: getAppBrightness(),
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: getAppColor(AppColors.background),
            systemNavigationBarIconBrightness: getAppBrightness()
        ),
        child: GetBuilder<HomeControllerWayagram>(
            builder: (controller) {
              var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

              return SizedBox(
                width: Get.width*0.7,
                child: Scaffold(
                    backgroundColor: getAppColor(AppColors.background),
                    body: SafeArea(
                      child: ListView(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.imagePaths.clear();
                              Get.back();
                              Get.to(() => const Profile());
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: Get.width*0.025, right: Get.width*0.025),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: Get.width*0.2,
                                    height: Get.width*0.2,
                                    child: IconButton(
                                      icon: AppAvatar(
                                        imgUrl: (fullProfile.avatar as String?).toString(),
                                        radius: 45,
                                      ),
                                      onPressed: () {
                                        controller.imagePaths.clear();
                                        Get.back();
                                        Get.to(() => const Profile());
                                      },
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.profile.displayName}",
                                        style: AppTextStyle.headline4.copyWith(
                                          color: getAppColor(Colors.black),
                                          fontWeight: FontWeight.bold,
                                          fontSize: Get.width*0.035,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            followers.toString(),
                                            style: AppTextStyle.headline4.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: Get.width*0.034,
                                            ),
                                          ),
                                          Text(
                                            " followers",
                                            style: AppTextStyle.headline4.copyWith(
                                              color: getAppColor(Colors.black),
                                              fontWeight: FontWeight.normal,
                                              fontSize: Get.width*0.034,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            following.toString(),
                                            style: AppTextStyle.headline4.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.normal,
                                              fontSize: Get.width*0.034,
                                            ),
                                          ),
                                          Text(
                                            " following",
                                            style: AppTextStyle.headline4.copyWith(
                                              color: getAppColor(Colors.black),
                                              fontWeight: FontWeight.normal,
                                              fontSize: Get.width*0.034,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          if(accountNumber.isNotEmpty)
                            InkWell(
                              onTap: (){
                                controller.imagePaths.clear();
                                Get.back();
                                Get.to(() => const Profile());
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: Get.width*0.025, right: Get.width*0.025),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Account No: ",
                                      style: AppTextStyle.headline4.copyWith(
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.normal,
                                        fontSize: Get.width*0.04,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          accountNumber,
                                          style: AppTextStyle.headline4.copyWith(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                            fontSize: Get.width*0.031,
                                          ),
                                        ),
                                        Text(
                                          "WAYA MICROFINANCE BANK",
                                          style: AppTextStyle.headline4.copyWith(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                            fontSize: Get.width*0.031,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          //Divider
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.05, right: Get.width*0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _TextButton(
                                  leading: Icon(Icons.person, color: getAppColor(Colors.black)),
                                  text: "My Account",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const Profile());
                                  },
                                ),

                                /*_TextButton(
                            leading: Icon(Icons.person_add, color: getAppColor(Colors.black)),
                            text: "Discover People",
                            onPressed: () {

                            },
                          ),*/

                                _TextButton(
                                  leading: Icon(Icons.people, color: getAppColor(Colors.black)),
                                  text: "Groups & Pages",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const GroupsAndPages());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.bookmark, color: getAppColor(Colors.black)),
                                  text: "Bookmarks",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const BookmarksPage());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.account_tree_sharp, color: getAppColor(Colors.black)),
                                  text: "Top Clips",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const TopClips());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.interests, color: getAppColor(Colors.black)),
                                  text: "Interests",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const AddInterestPage());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.calendar_month, color: getAppColor(Colors.black)),
                                  text: "Events",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const AllEvents());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.analytics, color: getAppColor(Colors.black)),
                                  text: "Post Promotion Analytics",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const PromotionAnalytics());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.local_activity, color: getAppColor(Colors.black)),
                                  text: "Activity Log",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const ActivityLog());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.settings, color: getAppColor(Colors.black)),
                                  text: "Settings",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const Settings());
                                  },
                                ),

                                _TextButton(
                                  leading: Icon(Icons.support_agent, color: getAppColor(Colors.black)),
                                  text: "Support",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const Support());
                                  },
                                ),
                              ],
                            ),
                          ),

                          const Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),

                          _TextButton(
                              leading: const SizedBox.shrink(),
                              text: "FAQ",
                              onPressed: ()  {
                                controller.launchURL("https://wayagram.ng/faq");
                              }),
                          _TextButton(
                              leading: const SizedBox.shrink(),
                              text: "Privacy Policy",
                              onPressed: ()  {
                                controller.launchURL("https://wayagram.ng/privacy-policy");
                              }),
                          _TextButton(
                              leading: const SizedBox.shrink(),
                              text: "Terms of Use",
                              onPressed: () {
                                controller.launchURL("https://wayagram.ng/terms");
                              }),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              _TextButton(
                                  leading: const SizedBox.shrink(),
                                  text: "Dark Mode",
                                  onPressed: () {
                                    var darkMode = MyPref.darkMode.val;
                                    MyPref.darkMode.val = !darkMode;
                                    AppBuilder.of(context)!.rebuild();
                                  }),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Get.width*0.018),
                                child: Switch(
                                  value: MyPref.darkMode.val,
                                  onChanged: (val){
                                  MyPref.darkMode.val = val;
                                  AppBuilder.of(context)!.rebuild();
                                },
                                  activeColor: AppColors.primary,
                                ),
                              )
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.05, right: Get.width*0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: Get.width*0.2,
                                  child: AppButton(
                                    title: 'LOGOUT',
                                    onPressed: () async {
                                      if(MyPref.uniqueID.val.isNotEmpty){
                                        var body = {
                                          "device_token_id": MyPref.uniqueID.val,
                                        };
                                        await controller.deleteData(body, "/wayagram-service/notification/delete-device-token");
                                      }
                                      controller.userRepo.api.disconnect();
                                      Get.back();
                                      await MyPref.clearBoxes();
                                      Freshchat.resetUser();
                                      Get.offAll(() => const Multiplexor(),binding: WayagramBinding());
                                    },
                                    borderRadius: 10,
                                    fontColor: AppColors.primary,
                                    bckgrndColor: getAppColor(AppColors.background),
                                    fontSize: Get.width*0.045,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            })
    );
  }

  void rebuildUI(BuildContext context){
    void rebuild(Element e){
      e.markNeedsBuild();
      e.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}

class _TextButton extends StatelessWidget {
  final Widget leading;
  final String text;
  final Function() onPressed;
  const _TextButton({required this.text, required this.onPressed, required this.leading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.height*0.018),
        child: Row(children: [
          leading,
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: AppTextStyle.subtitle1.copyWith(color: getAppColor(Colors.black)),
            ),
          ),
        ]),
      ),
    );
  }
}
