import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  late Animation<Color?> animation;
  late AnimationController controller;

  late Animation<Color?> animation2;
  late AnimationController controller2;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = ColorTween(begin: AppColors.background, end: AppColors.primary).animate(controller)
      ..addListener(() {
        setState(() {

        });
      });

    controller2 = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation2= ColorTween(begin: Colors.black, end: Colors.white).animate(controller2)
      ..addListener(() {
        setState(() {

        });
      });
  }

  void animateColorForward() {
    controller.forward();
    controller2.forward();
  }

  void animateColorBackward() {
    controller.animateBack(0);
    controller2.animateBack(0);
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

            var isAFollower = followers.followers!.any((element) => element.userId == userId);
            var isFollowing = following.following!.any((element) => element.userId == userId);
            var isBlocked = blocked.any((element) => element.userId == userId);
            var isMuted = muted.any((element) => element.userId == userId);

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: Get.height * 0.374,
                      floating: true,
                      pinned: true,
                      flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            top = constraints.biggest.height;
                            top == MediaQuery.of(context).padding.top + kToolbarHeight ? animateColorForward() : animateColorBackward();
                            return FlexibleSpaceBar(
                              centerTitle: false,
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
                                            width: Get.width*0.2,
                                            height: Get.width*0.2,
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
                                                  var response = await controller.postData(body, "https://services.staging.wayagram.ng/wayagram-service/graph/friend/follow");
                                                  if(response.isSuccessful){
                                                    await controller.getFollowing;
                                                    controller.update(['other_profile_page']);
                                                  }
                                                }else{
                                                  var response = await controller.postData(body, "https://services.staging.wayagram.ng/wayagram-service/graph/friend/unfollow");
                                                  if(response.isSuccessful){
                                                    await controller.getFollowing;
                                                    controller.update(['other_profile_page']);
                                                  }
                                                }
                                              },
                                              borderRadius: 10,
                                              fontColor: isFollowing ? AppColors.primary : AppColors.background,
                                              bckgrndColor: isFollowing ? AppColors.background : AppColors.primary,
                                              border: Border.all(color: isFollowing ? AppColors.primary : AppColors.background, width: 1),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
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
                                              fontSize: Get.width*0.035,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
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
                                  const SizedBox(height: 10,),
                                  Center(
                                    child: ToggleSwitch(
                                      minWidth: Get.width * 0.5,
                                      initialLabelIndex: 0,
                                      totalSwitches: 4,
                                      inactiveBgColor: animation.value!,
                                      activeBgColor: [animation.value!, animation.value!,animation.value!,animation.value!],
                                      activeBorders: [
                                        //Bottom Border
                                        Border.all(
                                          color: animation.value!,
                                          width: 3.0,
                                        ),
                                        Border.all(
                                          color: animation.value!,
                                          width: 3.0,
                                        ),
                                        Border.all(
                                          color: animation.value!,
                                          width: 3.0,
                                        ),
                                        Border.all(
                                          color: animation.value!,
                                          width: 3.0,
                                        ),
                                      ],
                                      radiusStyle: true,
                                      cornerRadius: 10.0,
                                      labels: const ['Posts', 'Products','Events','Donation'],
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
                                        AppTextStyle.bodyText1.copyWith(
                                          color: page == 2 ? AppColors.primary : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        AppTextStyle.bodyText1.copyWith(
                                          color: page == 3 ? AppColors.primary : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ],
                                      onToggle: (index) {
                                        page = index!;
                                        pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                        controller.update(['profile_page']);
                                      },
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 0.3,
                                  ),
                                ],
                              ),
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
                                child: Text(
                                  displayName,
                                  style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: animation2.value,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      actions: [
                        PopupMenuButton(
                            color: Colors.white,
                            icon: Icon(
                              Icons.more_vert,
                              color: animation2.value,
                            ),
                            onSelected: (value) {
                              if (value == 0) {
                                //Get.to(() => const Muted());
                              } else if (value == 1) {
                                //Get.to(() => const Blocked());
                              } else if (value == 2) {
                                //Get.to(() => const Followers());
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
                                value: 0,
                                child: Text(
                                  isMuted ? "Unmute User" : "Mute User",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  isBlocked ? "Unblock User" : "Block User",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Share",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ])
                      ],
                      backgroundColor: animation.value,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: animation.value,
                          statusBarIconBrightness: Brightness.dark,
                          statusBarBrightness: Brightness.dark,
                          systemNavigationBarColor: AppColors.background,
                          systemNavigationBarIconBrightness: Brightness.dark
                      ),
                    ),
                  ];
                },
                body: PageView(
                  controller: pageController,
                  onPageChanged: (page){
                    setState(() {
                      this.page = page;
                    });
                  },
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
}
