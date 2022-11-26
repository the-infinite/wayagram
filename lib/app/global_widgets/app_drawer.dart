import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/app/data/model/account_model_entity.dart';
import 'package:wayagram/app/modules/multiplexor/multiplexor.dart';
import 'package:wayagram/app/modules/top_clips/top_clips.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
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
import '../modules/settings/settings.dart';
import '../modules/support/support.dart';
import 'app_avatar.dart';
import 'app_button.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  static const String route = "/drawer";

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var homeController = Get.find<HomeController>();

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

    var controller = Get.find<HomeController>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: AppColors.background,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.background,
            systemNavigationBarIconBrightness: Brightness.dark
        ),
        child: GetBuilder<HomeController>(
            builder: (controller) {
              var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

              return SizedBox(
                width: Get.width*0.7,
                child: Scaffold(
                    backgroundColor: AppColors.background,
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
                                        "${controller.logInDetails.user!.firstName} ${controller.logInDetails.user!.lastName}",
                                        style: AppTextStyle.headline4.copyWith(
                                          color: Colors.black,
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
                                              color: Colors.black,
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
                                              color: Colors.black,
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
                                  children: [
                                    Text(
                                      "Acct: ",
                                      style: AppTextStyle.headline4.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Get.width*0.04,
                                      ),
                                    ),
                                    Text(
                                      "$accountNumber | ",
                                      style: AppTextStyle.headline4.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Get.width*0.04,
                                      ),
                                    ),
                                    Text(
                                      bankName,
                                      style: AppTextStyle.headline4.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Get.width*0.04,
                                      ),
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
                                  leading: const Icon(Icons.person, color: Colors.black),
                                  text: "My Account",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const Profile());
                                  },
                                ),

                                /*_TextButton(
                            leading: const Icon(Icons.person_add, color: Colors.black),
                            text: "Discover People",
                            onPressed: () {

                            },
                          ),*/

                                _TextButton(
                                  leading: const Icon(Icons.people, color: Colors.black),
                                  text: "Groups & Pages",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const GroupsAndPages());
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.bookmark, color: Colors.black),
                                  text: "Bookmarks",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const BookmarksPage());
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.account_tree_sharp, color: Colors.black),
                                  text: "Top Clips",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const TopClips());
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.interests, color: Colors.black),
                                  text: "Interests",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const AddInterestPage());
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.calendar_month, color: Colors.black),
                                  text: "Events",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const AllEvents());
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.analytics, color: Colors.black),
                                  text: "Post Promotion Analytics",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.local_activity, color: Colors.black),
                                  text: "Activity Log",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const ActivityLog());
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.settings, color: Colors.black),
                                  text: "Settings",
                                  onPressed: () {
                                    controller.imagePaths.clear();
                                    Get.back();
                                    Get.to(() => const Settings());
                                  },
                                ),

                                _TextButton(
                                  leading: const Icon(Icons.support_agent, color: Colors.black),
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
                                      Get.back();
                                      await MyPref.clearBoxes();
                                      Get.offAllNamed(Multiplexor.route);
                                    },
                                    borderRadius: 10,
                                    fontColor: AppColors.primary,
                                    bckgrndColor: AppColors.background,
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
              style: AppTextStyle.subtitle1.copyWith(color: Colors.black),
            ),
          ),
        ]),
      ),
    );
  }
}
