import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/app/modules/profile/inner_pages/blocked.dart';
import 'package:wayagram/app/modules/profile/inner_pages/muted.dart';
import 'package:wayagram/app/modules/profile/update_profile.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/blocked_accounts_entity.dart';
import '../../data/model/followers_model_entity.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/friends_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/log_in_model_entity.dart';
import '../../data/model/products_model_entity.dart';
import '../../data/model/profile_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/app_drawer.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/posts_view.dart';
import '../home/widgets/product_view.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';
import 'inner_pages/followers.dart';
import 'inner_pages/following.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({Key? key}) : super(key: key);

  static const route = '/otherProfile';

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> with TickerProviderStateMixin{
  var page = 0;
  late TabController tabController;
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var top = 0.0;
    var arguments = Get.arguments as List<String>;
    var userId = arguments[3];
    var userName = arguments[1];
    var userImage = arguments[2];
    var userBio = arguments[4];
    var userFollowers = arguments[6];
    var userFollowing = arguments[7];
    var userPosts = arguments[5];
    var displayName = arguments[0];
    var coverImage = arguments[8];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(
          id: 'other_profile_page',
          builder: (controller) {
            var followers = FollowersModelEntity.fromJson(jsonDecode(MyPref.followers.val));
            var following = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
            var blocked = BlockedAccountsEntity.getService(jsonDecode(MyPref.restrictedAccounts.val));
            var muted = BlockedAccountsEntity.getService(jsonDecode(MyPref.mutedAccounts.val));

            var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

            var isAFollower = followers.followers!.any((element) => element.username == userName);
            var isFollowing = following.following!.any((element) => element.username == userName);
            var isBlocked = blocked.any((element) => element.username == userName);
            var isMuted = muted.any((element) => element.username == userName);

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverLayoutBuilder(
                      builder: (BuildContext context, constraints) {
                        final scrolled = constraints.scrollOffset >= ((Get.height * 0.20));
                        return SliverAppBar(
                          expandedHeight: Get.height * 0.40,
                          floating: false,
                          pinned: true,
                          flexibleSpace: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                top = constraints.biggest.height;
                                return FlexibleSpaceBar(
                                  stretchModes: const [
                                    StretchMode.zoomBackground,
                                    StretchMode.blurBackground,
                                  ],
                                  collapseMode: CollapseMode.pin,
                                  background: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.25,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: Get.height * 0.2,
                                              width: Get.width,
                                              child: Image.network(
                                                coverImage,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Container(
                                                    color: Colors.grey[300],
                                                  );
                                                },
                                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[300],
                                                  );
                                                },
                                              ),
                                            ),
                                            //Profile Image
                                            Positioned(
                                              bottom: 0,
                                              left: 20,
                                              child: Container(
                                                width: Get.height*0.1,
                                                height: Get.height*0.1,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white, width: 2),
                                                ),
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: AppAvatar(
                                                    imgUrl: userImage,
                                                  ),
                                                  onPressed: () {
                                                    //Get.toNamed(Profile.route);
                                                  },
                                                ),
                                              ),
                                            ),
                                            //Edit Profile
                                            Positioned(
                                              bottom: 0,
                                              right: 20,
                                              child: SizedBox(
                                                child: AppButton(
                                                  title: isFollowing ? 'Following' : 'Follow',
                                                  onPressed: () async {
                                                    var body = {
                                                      "user_id": userId,
                                                      "username": userName
                                                    };
                                                    if(!isFollowing){
                                                      var response = await controller.postData(body, "wayagram-service/graph/friend/follow");
                                                      if(response.isSuccessful){
                                                        if(response.message.toString().toLowerCase().contains("request")){
                                                          AppOverlay.showSuccessSnackBar(content :"Friend request sent successfully");
                                                        }
                                                        await controller.getFollowing;
                                                        //await controller.getPosts;
                                                        controller.update(['other_profile_page']);
                                                      }else{
                                                        if(response.message.toString().toLowerCase().contains("request")){
                                                          AppOverlay.showSuccessSnackBar(content :"Friend request sent successfully");
                                                        }else{
                                                          AppOverlay.showErrorSnackBar();
                                                        }
                                                      }
                                                    }else{
                                                      var response = await controller.postData(body, "wayagram-service/graph/friend/unfollow");
                                                      if(response.isSuccessful){
                                                        await controller.getFollowing;
                                                        //await controller.getPosts;
                                                        controller.update(['other_profile_page']);
                                                      }
                                                    }
                                                  },
                                                  borderRadius: 10,
                                                  fontColor: isFollowing ? AppColors.primary : AppColors.background,
                                                  bckgrndColor: isFollowing ? AppColors.background : AppColors.primary,
                                                  border: Border.all(color: isFollowing ? AppColors.primary : AppColors.background, width: 1),
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                  fontSize: Get.width * 0.04,
                                                  width: Get.width * 0.3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.01),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              displayName,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Get.width*0.04,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "@$userName",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Get.width*0.035,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            if(fullProfile.bio.toString() != "null")
                                              Text(
                                                userBio,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: Get.width*0.04,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.01),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                //Get.to(() => const Followers());
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    userFollowers.split(".")[0],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: Get.width*0.035,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    " Followers",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: Get.width*0.035,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),

                                            InkWell(
                                              onTap: () {
                                                //Get.to(() => const Following());
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    userFollowing.split(".")[0],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: Get.width*0.035,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    " Following",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: Get.width*0.035,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),

                                            Text(
                                              userPosts.split(".")[0],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Get.width*0.035,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              " Posts",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Get.width*0.035,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Get.height * 0.01),
                                    ],
                                  ),
                                );
                              }
                          ),
                          leading: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                width: Get.width * 0.1,
                                height: Get.width * 0.1,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    FeatherIcons.arrowLeft,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  iconSize: Get.width * 0.06,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            PopupMenuButton(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.5,right: 5),
                                  child: Center(
                                    child: Container(
                                      width: Get.width * 0.1,
                                      height: Get.width * 0.1,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        ),
                                        onPressed: null,
                                        iconSize: Get.width * 0.06,
                                      ),
                                    ),
                                  ),
                                ),
                                onSelected: (value) {
                                  if (value == 0) {

                                  } else if (value == 1) {
                                    showPlatformDialog(
                                      context: context,
                                      builder: (context) => BasicDialogAlert(
                                        title: Text(
                                          isMuted ? "UnMute @$userName" : "Mute @$userName",
                                          style: AppTextStyle.bodyText1.copyWith(
                                            //color: Colors.grey,
                                            fontSize: Get.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          isMuted ? "You will now see their activities on your timeline" : "You will not see their activities on your timeline, they can still see your activities and follow you",
                                          style: AppTextStyle.bodyText1.copyWith(
                                            //color: Colors.grey,
                                            fontSize: Get.width * 0.035,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          BasicDialogAction(
                                            title: Text(
                                              "Cancel",
                                              style: AppTextStyle.bodyText1.copyWith(
                                                color: Colors.blue,
                                                fontSize: Get.width * 0.03,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          BasicDialogAction(
                                            title: Text(
                                              isMuted ? "Unmute" : "Mute",
                                              style: AppTextStyle.bodyText1.copyWith(
                                                color: Colors.blue,
                                                fontSize: Get.width * 0.03,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              var body = {
                                                "user_id": userId,
                                                "username": userName,
                                              };
                                              controller.putData(body, "/wayagram-service/graph/friend/mute-or-unmute-friend").then((value){
                                                if(value.isSuccessful){
                                                  AppOverlay.showSuccessSnackBar(content: isMuted ? "User un-muted successfully" : "User muted successfully");
                                                  controller.getMuted.then((value){
                                                    controller.update(["other_profile_page"]);
                                                  });
                                                }else {
                                                  var message = "Something went wrong, Please try again later";
                                                  if(value.message.toString().contains("You can only mute your follower")){
                                                    message = "You can only mute your followers";
                                                  }
                                                  AppOverlay.showErrorSnackBar(content: message);
                                                }
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (value == 2) {
                                    showPlatformDialog(
                                      context: context,
                                      builder: (context) => BasicDialogAlert(
                                        title: Text(
                                          isBlocked ? "UnBlock @$userName" : "Block @$userName",
                                          style: AppTextStyle.bodyText1.copyWith(
                                            //color: Colors.grey,
                                            fontSize: Get.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          isBlocked ? "They will be able to follow you and view your posts, you will also be able to see them and their activities" : "They will not be able to follow you or view your posts, you will also not see them or their activities",
                                          style: AppTextStyle.bodyText1.copyWith(
                                            //color: Colors.grey,
                                            fontSize: Get.width * 0.035,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          BasicDialogAction(
                                            title: Text(
                                              "Cancel",
                                              style: AppTextStyle.bodyText1.copyWith(
                                                color: Colors.blue,
                                                fontSize: Get.width * 0.03,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          BasicDialogAction(
                                            title: Text(
                                              isBlocked ? "Unblock" : "Block",
                                              style: AppTextStyle.bodyText1.copyWith(
                                                color: Colors.blue,
                                                fontSize: Get.width * 0.03,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            onPressed: () {
                                              var body = {
                                                "user_id": userId,
                                                "username": userName,
                                              };
                                              if(isBlocked){
                                                controller.postData(body, "/wayagram-service/graph/friend/unblock").then((value){
                                                  if(value.isSuccessful){
                                                    AppOverlay.showSuccessSnackBar(content: "User un-blocked successfully");
                                                    controller.getBlocked.then((value){
                                                      controller.update(["other_profile_page"]);
                                                    });
                                                  }else {
                                                    var message = "Something went wrong, Please try again later";
                                                    if(value.message.toString().contains("You can only block active friends")){
                                                      message = "You can only block active friends";
                                                    }
                                                    AppOverlay.showErrorSnackBar(content: message);
                                                  }
                                                });
                                              }else{
                                                controller.postData(body, "/wayagram-service/graph/friend/block").then((value){
                                                  if(value.isSuccessful){
                                                    AppOverlay.showSuccessSnackBar(content:  "User blocked successfully");
                                                    controller.getBlocked.then((value){
                                                      controller.update(["other_profile_page"]);
                                                    });
                                                  }else {
                                                    AppOverlay.showErrorSnackBar(content: "Something went wrong, Please try again later");
                                                  }
                                                });
                                              }
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      "Report User",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      isMuted ? "Unmute User" : "Mute User",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Text(
                                      isBlocked ? "Unblock User" : "Block User",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                          title: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: scrolled ? 1.0 : 0.0,
                              child: Text(
                                displayName,
                                style: AppTextStyle.subtitle1.copyWith(
                                  color: const Color(0xff4F4F4F),
                                  fontSize: Get.textScaleFactor * 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          backgroundColor: AppColors.background,
                          systemOverlayStyle: SystemUiOverlayStyle(
                              statusBarColor: scrolled ? AppColors.background : Colors.transparent,
                              statusBarIconBrightness: Brightness.dark,
                              statusBarBrightness: Brightness.dark,
                              systemNavigationBarColor: AppColors.background,
                              systemNavigationBarIconBrightness: Brightness.dark
                          ),
                          bottom: PreferredSize(
                              preferredSize: Size(Get.width, Get.height * 0.06),
                              child: Column(
                                children: [
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: scrolled ? 1.0 : 0.0,
                                    child: const Divider(
                                      height: 0.5,
                                      thickness: 0.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TabBar(
                                    controller: tabController,
                                    padding: EdgeInsets.zero,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: const Color(0xff9A9A9A),
                                    indicatorColor: AppColors.primary,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelStyle: TextStyle(
                                      fontSize: Get.width*0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    unselectedLabelStyle: TextStyle(
                                      fontSize: Get.width*0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    tabs: const [
                                      Tab(text: 'Posts',iconMargin: EdgeInsets.zero,),
                                      Tab(text: 'Products',iconMargin: EdgeInsets.zero,),
                                      Tab(text: 'Events',iconMargin: EdgeInsets.zero,),
                                      Tab(text: 'Donation',iconMargin: EdgeInsets.zero,),
                                    ],
                                    onTap: (index) {
                                      //pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                      //controller.update(['profile_page']);
                                    },
                                  ),
                                  const Divider(
                                    height: 0.5,
                                    thickness: 0.5,
                                    color: Colors.grey,
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  ];
                },
                body: TabBarView(
                  controller: tabController,
                  children: [
                    Column(),
                    Column(),
                    Column(),
                    Column(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    pageController.dispose();
  }
}
