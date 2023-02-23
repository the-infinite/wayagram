import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/app/modules/profile/inner_pages/blocked.dart';
import 'package:wayagram/app/modules/profile/inner_pages/muted.dart';
import 'package:wayagram/app/modules/profile/update_profile.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../bindings/wayagram_binding.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/followers_model_entity.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/products_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../home/widgets/posts_view.dart';
import '../home/widgets/product_view.dart';
import 'inner_pages/followers.dart';
import 'inner_pages/following.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  static const route = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin{
  var controller = Get.find<HomeControllerWayagram>();
  late TabController tabController;
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  var page = 0;

  var pos = 0;
  bool showName = false;
  bool showTab = false;

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
          statusBarColor: getAppColor(AppColors.background).withOpacity(0.0),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
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

            if (kDebugMode) {
              print("Profile ID ${fullProfile.id}");
              print("User ID ${fullProfile.userId}");
            }
            return Scaffold(
              backgroundColor: getAppColor(AppColors.background),
              body:Stack(
                alignment: Alignment.topCenter,
                children: [
                  ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: kToolbarHeight,
                          ),
                          SizedBox(
                            height: Get.height * 0.25,
                            child: Stack(
                              children: [
                                VisibilityDetector(
                                  key: const Key('cover_picture'),
                                  onVisibilityChanged: (visibilityInfo) {
                                    var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                    if(visiblePercentage <= 0.1){
                                      setState(() {
                                        showName = true;
                                      });
                                    }else{
                                      setState(() {
                                        showName = false;
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    height: Get.height * 0.2,
                                    width: Get.width,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageViewer(
                                              imageUrls: [fullProfile.coverImage.toString()],
                                              initialPage: 0,
                                              heroTags: [fullProfile.coverImage.toString()],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: fullProfile.coverImage.toString(),
                                        child: CachedNetworkImage(
                                          imageUrl: fullProfile.coverImage.toString(),
                                          placeholder: (context, url) => Container(
                                            color: Colors.grey.shade200,
                                            child: Icon(Icons.image_rounded,color: Colors.grey,size: Get.height*0.05),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                              color: Colors.grey.shade200,
                                              child: Icon(Icons.broken_image_rounded,color: Colors.grey,size: Get.height*0.05)
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
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
                                      border: Border.all(color: getAppColor(Colors.white), width: 2),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Hero(
                                        tag: fullProfile.avatar.toString(),
                                        child: AppAvatar(
                                          imgUrl: fullProfile.avatar.toString(),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageViewer(
                                              imageUrls: [fullProfile.avatar.toString()],
                                              initialPage: 0,
                                              heroTags: [fullProfile.avatar.toString()],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                //Edit Button
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
                                      bckgrndColor: getAppColor(AppColors.background),
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
                                VisibilityDetector(
                                  key: const Key('profile_picture'),
                                  onVisibilityChanged: (visibilityInfo) {
                                    var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                    if(visiblePercentage <= 0.1){
                                      setState(() {
                                        showTab= true;
                                      });
                                    }else{
                                      setState(() {
                                        showTab = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    '${fullProfile.displayName}',
                                    style: TextStyle(
                                      color: getAppColor(Colors.black),
                                      fontSize: Get.width*0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "@${fullProfile.username}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Get.width*0.035,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if(fullProfile.bio != null && fullProfile.bio!.isNotEmpty)
                                  const SizedBox(height: 2),
                                if(fullProfile.bio != null && fullProfile.bio!.isNotEmpty)
                                  SizedBox(
                                    width: Get.width,
                                    child: Text(
                                      fullProfile.bio.toString(),
                                      style: TextStyle(
                                        color: getAppColor(Colors.black),
                                        fontSize: Get.width*0.035,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 4,
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
                                    Get.to(() => const Followers());
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        shortenCount(followersCount.toString()),
                                        style: TextStyle(
                                          color: getAppColor(Colors.black),
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
                                        shortenCount(followingCount.toString()),
                                        style: TextStyle(
                                          color: getAppColor(Colors.black),
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
                                  shortenCount(fullProfile.posts.toString()),
                                  style: TextStyle(
                                    color: getAppColor(Colors.black),
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
                          TabBar(
                              controller: tabController,
                              padding: EdgeInsets.zero,
                              labelColor: AppColors.primary,
                              unselectedLabelColor: const Color(0xff9A9A9A),
                              indicatorColor: AppColors.primary,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: TextStyle(
                                  fontSize: Get.width*0.035,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary
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
                                //pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                setState(() {
                                  pos = index;
                                });
                              },
                            ),
                          const Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                        ],
                      ),
                      IndexedStack(
                          index: pos,
                          children: [
                            Visibility(
                              maintainState: true,
                              visible: pos == 0,
                              child: SingleChildScrollView(
                                key: const ValueKey('posts'),
                                physics: const NeverScrollableScrollPhysics(),
                                child: FutureBuilder<ApiResponse>(
                                  //&page=1&limit=40
                                    future: controller.getData("/wayagram-service/all-posts/user-posts?profile_id=$postListID", true),
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
                            ),

                            Visibility(
                              maintainState: true,
                              visible: pos == 1,
                              child: SingleChildScrollView(
                                key: const ValueKey('products'),
                                physics: const NeverScrollableScrollPhysics(),
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
                            ),

                            Visibility(
                              maintainState: true,
                              visible: pos == 2,
                              child: SingleChildScrollView(
                                key: const ValueKey('polls'),
                                physics: const NeverScrollableScrollPhysics(),
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
                            ),

                            Visibility(
                              maintainState: true,
                              visible: pos == 3,
                              child: SingleChildScrollView(
                                key: const ValueKey('donations'),
                                physics: const NeverScrollableScrollPhysics(),
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
                            ),
                          ],
                        )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 100,
                        child: AppBar(
                          backgroundColor: getAppColor(AppColors.background),
                          title: Text(
                            'Profile',
                            style: AppTextStyle.subtitle1.copyWith(
                              color: getAppColor(getAppColor(const Color(0xff4F4F4F))),
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          centerTitle: true,
                          leading: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              FeatherIcons.arrowLeft,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            iconSize: Get.width * 0.06,
                          ),
                          actions: [
                            PopupMenuButton(
                                color: getAppColor(Colors.white),
                                iconSize: Get.width * 0.2,
                                onSelected: (value) {
                                  if (value == 0) {
                                    Get.to(() => const Muted());
                                  } else if (value == 1) {
                                    Get.to(() => const Blocked());
                                  } else if (value == 2) {
                                    //Get.to(() => Followers());
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      "View Muted Users",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      "View Blocked Users",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                 /* PopupMenuItem(
                                    value: 2,
                                    child: Text(
                                      "Share",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),*/
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.5,right: 5),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: null,
                                    iconSize: Get.width * 0.06,
                                  ),
                                ))
                          ],
                          bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(1.0),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: showName ? 1.0 : 0.0,
                                child: Container(
                                  color: const Color(0xffEDEAEA),
                                  height: 1.0,
                                ),
                              )),
                          systemOverlayStyle: SystemUiOverlayStyle(
                              statusBarColor: showName ? getAppColor(AppColors.background) : Colors.transparent,
                              statusBarIconBrightness: getAppBrightness(),
                              statusBarBrightness: getAppBrightness(),
                              systemNavigationBarColor: showName ? getAppColor(AppColors.background) : Colors.transparent,
                              systemNavigationBarIconBrightness: getAppBrightness()
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: showTab && Get.currentRoute == "/Profile" ? 1.0 : 0.0,
                        child: Container(
                          color: getAppColor(AppColors.background),
                          child: TabBar(
                            controller: tabController,
                            padding: EdgeInsets.zero,
                            labelColor: AppColors.primary,
                            unselectedLabelColor: const Color(0xff9A9A9A),
                            indicatorColor: AppColors.primary,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: TextStyle(
                                fontSize: Get.width*0.035,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary
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
                              //pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
                              setState(() {
                                pos = index;
                              });
                            },
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: showTab && Get.currentRoute == "/Profile" ? 1.0 : 0.0,
                        child: const  Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
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

  String shortenCount(String amount){
    if(amount == "null" || amount.isEmpty || int.tryParse(amount) == null){
      return "0";
    }
    if(num.parse(amount) >= 1000000000){
      return "${(num.parse(amount) / 1000000000).toStringAsFixed(1)}B";
    }
    if(amount.length > 6 && amount.length <= 9){
      return "${(int.parse(amount) / 1000000).toStringAsFixed(1)}M";
    }
    if(amount.length > 4 && amount.length <= 6){
      return "${(int.parse(amount) / 1000).toStringAsFixed(1)}K";
    }
    return amount;
  }
}
