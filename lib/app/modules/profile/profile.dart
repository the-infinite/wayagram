import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
import '../../bindings/wayagram_binding.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/all_posts_entity.dart';
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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  static const route = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin{
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
    var height = 0.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: AppColors.background.withOpacity(0.0),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(
          id: 'profile_page',
          builder: (controller) {
            //
            //var following = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
            //var friends = FriendsModelEntity.fromJson(jsonDecode(MyPref.friends.val));
            var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

            var followersCount = 0;
            var followingCount = 0;
            if(MyPref.followers.val.isNotEmpty) {
              var followers = FollowersModelEntity.fromJson(jsonDecode(MyPref.followers.val));
              followersCount = followers.followers!.length;
            }

            if(MyPref.following.val.isNotEmpty) {
              var following = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
              followingCount = following.following!.length;
            }

            if(MyPref.friends.val.isNotEmpty){
              //var friends = FriendsModelEntity.fromJson(jsonDecode(MyPref.friends.val));
              //followersCount = friends.followers!;
              //followingCount = friends.following!;
            }

            var postListID = fullProfile.id;
            var tabs = [
              SingleChildScrollView(
                key: const ValueKey('posts'),
                child: FutureBuilder<ApiResponse>(
                    future: controller.getData("/wayagram-service/all-posts/user-posts?profile_id=$postListID&page=1&limit=40", true),
                    builder: (context, snapshot) {
                      var savedPosts = ReadWriteValue('wayagram_posts_$postListID', '', MyPref.box);
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts =  AllPostsEntity.getService(snapshot.data!.data['data']);
                        savedPosts.val = jsonEncode(posts);
                        return PostsView(posts: posts);
                      } else if(savedPosts.val.isNotEmpty){
                        var posts = AllPostsEntity.getService(jsonDecode(savedPosts.val));
                        return PostsView(posts: posts);
                      }else{
                        if(snapshot.connectionState == ConnectionState.done){
                          return const SizedBox.shrink();
                        }
                        return const PostsView(isLoading: true);
                      }
                    }),
              ),
              SingleChildScrollView(
                key: const ValueKey('products'),
                child: FutureBuilder<ApiResponse>(
                    future: controller.getData("/wayagram-service/all-posts/get-user-products?page=1&limit=40&profile_id=$postListID", true),
                    builder: (context, snapshot) {
                      var savedPosts = ReadWriteValue('wayagram_products_$postListID', '', MyPref.box);
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts = ProductsModelEntity.fromJson(snapshot.data!.data);
                        savedPosts.val = jsonEncode(posts);
                        return ProductView(posts: posts.data!);
                      } else if(savedPosts.val.isNotEmpty){
                        var posts = ProductsModelEntity.fromJson(jsonDecode(savedPosts.val));
                        return ProductView(posts: posts.data!);
                      }else{
                        if(snapshot.connectionState == ConnectionState.done){
                          return const SizedBox.shrink();
                        }
                        return const ProductView(isLoading: true);
                      }
                    }),
              ),
              SingleChildScrollView(
                key: const ValueKey('polls'),
                child: FutureBuilder<ApiResponse>(
                    future: controller.getData("/wayagram-service/all-posts/user-posts?profile_id=$postListID&page=1&limit=40", true),
                    builder: (context, snapshot) {
                      var savedPosts = ReadWriteValue('wayagram_posts_$postListID', '', MyPref.box);
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts =  AllPostsEntity.getService(snapshot.data!.data['data']);
                        savedPosts.val = jsonEncode(posts);
                        return PostsView(posts: posts,userID: fullProfile.userId,isPoll: true);
                      } else if(savedPosts.val.isNotEmpty){
                        var posts = AllPostsEntity.getService(jsonDecode(savedPosts.val));
                        return PostsView(posts: posts,userID: fullProfile.userId,isPoll: true);
                      }else{
                        if(snapshot.connectionState == ConnectionState.done){
                          return const SizedBox.shrink();
                        }
                        return const PostsView(isLoading: true);
                      }
                    }),
              ),
              SingleChildScrollView(
                key: const ValueKey('donations'),
                child: FutureBuilder<ApiResponse>(
                    future: controller.getData("/wayagram-service/all-posts/user-posts?profile_id=$postListID&page=1&limit=40", true),
                    builder: (context, snapshot) {
                      var savedPosts = ReadWriteValue('wayagram_posts_$postListID', '', MyPref.box);
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts =  AllPostsEntity.getService(snapshot.data!.data['data']);
                        savedPosts.val = jsonEncode(posts);
                        return PostsView(posts: posts,userID: fullProfile.userId,isDonation: true);
                      } else if(savedPosts.val.isNotEmpty){
                        var posts = AllPostsEntity.getService(jsonDecode(savedPosts.val));
                        return PostsView(posts: posts,userID: fullProfile.userId,isDonation: true);
                      }else{
                        if(snapshot.connectionState == ConnectionState.done){
                          return const SizedBox.shrink();
                        }
                        return const PostsView(isLoading: true);
                      }
                    }),
              ),
            ];

            if (kDebugMode) {
              print("Profile ID ${fullProfile.id}");
              print("User ID ${fullProfile.userId}");
            }
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverLayoutBuilder(
                        builder: (BuildContext context, constraints) {
                          final scrolled = constraints.scrollOffset >= ((Get.height * 0.20));
                          return SliverAppBar(
                            expandedHeight: Get.height * 0.39,
                            floating: false,
                            pinned: true,
                            flexibleSpace: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  top = constraints.biggest.height;
                                  return FlexibleSpaceBar(
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
                                                    (fullProfile.coverImage as String?).toString(),
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
                                                        imgUrl: (fullProfile.avatar as String?).toString(),
                                                      ),
                                                      onPressed: () {

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
                                                      title: 'Edit',
                                                      onPressed: () {
                                                        controller.imagePaths.clear();
                                                        Get.to(() => const UpdateProfile(),binding: WayagramBinding());
                                                      },
                                                      borderRadius: 10,
                                                      fontColor: AppColors.primary,
                                                      bckgrndColor: AppColors.background,
                                                      border: Border.all(color: AppColors.primary, width: 1),
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                      fontSize: Get.width * 0.04,
                                                      width: Get.width * 0.2,
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
                                                  '${fullProfile.displayName}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Get.width*0.04,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: Get.height*0.002),
                                                Text(
                                                  "@${fullProfile.username}",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: Get.width*0.035,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: Get.height*0.002),
                                                if(fullProfile.bio.toString() != "null")
                                                  Text(
                                                    fullProfile.bio.toString(),
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
                                                    Get.to(() => const Followers());
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        followersCount.toString(),
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
                                                    Get.to(() => const Following());
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        followingCount.toString(),
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
                                                  fullProfile.posts.toString(),
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
                                      stretchModes: const [
                                        StretchMode.zoomBackground,
                                        StretchMode.blurBackground,
                                      ],
                                      collapseMode: CollapseMode.pin
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
                                  iconSize: Get.width * 0.2,
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
                                        "View Muted Users",
                                        style: AppTextStyle.bodyText1.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "View Blocked Users",
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
                                  ],
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
                                  ))
                            ],
                            title: Center(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: scrolled ? 1.0 : 0.0,
                                child: Text(
                                  '${controller.logInDetails.user!.firstName!.capitalizeFirst} ${controller.logInDetails.user!.lastName!.capitalizeFirst}',
                                  style: AppTextStyle.subtitle1.copyWith(
                                    color: const Color(0xff4F4F4F),
                                    fontSize: Get.textScaleFactor * 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            titleSpacing: 0,
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
                                        Tab(text: 'Polls',iconMargin: EdgeInsets.zero,),
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
                    ),
                  ];
                },
                body: TabBarView(
                  controller: tabController,
                  children: tabs.map((widget) {
                    return SafeArea(
                      top: false,
                      bottom: false,
                      child: Builder(
                        builder: (BuildContext context) {
                          return CustomScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            key: PageStorageKey<String>(widget.key.toString()),
                            slivers: <Widget>[
                              SliverOverlapInjector(
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              ),
                              SliverToBoxAdapter(
                                  child: widget
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.bottomSheet(const WayaBottomSheet(),isScrollControlled: true);
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add,color: Colors.white),
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
