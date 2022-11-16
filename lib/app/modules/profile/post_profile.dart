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

class PostProfile extends StatefulWidget {
  const PostProfile({Key? key}) : super(key: key);

  static const route = '/postProfile';

  @override
  State<PostProfile> createState() => _PostProfileState();
}

class _PostProfileState extends State<PostProfile> with TickerProviderStateMixin{
  var page = 0;
  late TabController tabController;
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
    tabController = TabController(length: 4, vsync: this);
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
    var post = Get.arguments as AllPostsEntity;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: AppColors.background.withOpacity(0.0),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(
          id: 'post_profile_page',
          builder: (controller) {
            var profile = ProfileModelEntity.fromJson(jsonDecode(MyPref.userProfile.val));
            var friends = FriendsModelEntity.fromJson(jsonDecode(MyPref.friends.val));
            var followers = FollowersModelEntity.fromJson(jsonDecode(MyPref.followers.val));
            var following = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
            var blocked = BlockedAccountsEntity.getService(jsonDecode(MyPref.restrictedAccounts.val));
            var muted = BlockedAccountsEntity.getService(jsonDecode(MyPref.mutedAccounts.val));

            var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

            var isAFollower = followers.followers!.any((element) => element.username == post.profile!.username);
            var isFollowing = following.following!.any((element) => element.username == post.profile!.username);
            var isBlocked = blocked.any((element) => element.username == post.profile!.username);
            var isMuted = muted.any((element) => element.username == post.profile!.username);

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: Get.height * 0.37,
                      floating: false,
                      pinned: true,
                      flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
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
                                            (post.profile!.coverImage as String?).toString(),
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
                                                imgUrl: (post.profile!.avatar as String?).toString(),
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
                                                  "user_id": post.profile!.userId,
                                                  "username": post.profile!.username,
                                                };
                                                if(!isFollowing){
                                                  var response = await controller.postData(body, "wayagram-service/graph/friend/follow");
                                                  if(response.isSuccessful){
                                                    await controller.getFollowing;
                                                    await controller.getPosts;
                                                    controller.update(['post_profile_page']);
                                                  }
                                                }else{
                                                  var response = await controller.postData(body, "wayagram-service/graph/friend/unfollow");
                                                  if(response.isSuccessful){
                                                    await controller.getFollowing;
                                                    await controller.getPosts;
                                                    controller.update(['post_profile_page']);
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
                                          '${post.profile!.displayName}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: Get.width*0.04,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "@${post.profile!.username}",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Get.width*0.035,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        if(post.profile!.bio != "null")
                                          SizedBox(
                                            width: Get.width,
                                            child: Text(
                                              post.profile!.bio.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Get.width*0.04,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                                (post.profile!.followers!.toInt()).toString(),
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
                                                (post.profile!.followings!.toInt()).toString(),
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
                                          (post.profile!.posts!.toInt()).toString(),
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
                                ],
                              ),
                            );
                          }
                      ),
                      leading: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              width: Get.width * 0.1,
                              height: Get.width * 0.1,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: animation2.value,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        PopupMenuButton(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.5,right: 5),
                              child: Column(
                                children: [
                                  Container(
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onSelected: (value) {
                              if (value == 0) {
                                Get.to(() => const Muted());
                              } else if (value == 1) {
                                Get.to(() => const Blocked());
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
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: innerBoxIsScrolled ? 1.0 : 0.0,
                        child: Text(
                          '${post.profile!.displayName}',
                          style: AppTextStyle.subtitle1.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: innerBoxIsScrolled ? AppColors.background : Colors.transparent,
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
                                opacity: innerBoxIsScrolled ? 1.0 : 0.0,
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
