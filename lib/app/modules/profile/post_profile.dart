import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/app/modules/profile/inner_pages/blocked.dart';
import 'package:wayagram/app/modules/profile/inner_pages/muted.dart';
import 'package:wayagram/app/modules/profile/report_user.dart';
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
import '../../global_widgets/person_view.dart';
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
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
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
      child: GetBuilder<HomeControllerWayagram>(
          id: 'post_profile_page',
          builder: (controller) {
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

            var postListID = post.profile!.id;
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
                                                          if(response.message.toString().toLowerCase().contains("request")){
                                                            AppOverlay.showSuccessSnackBar(content :"Friend request sent successfully");
                                                          }
                                                          await controller.getFollowing;
                                                          //await controller.getPosts;
                                                          controller.update(['post_profile_page']);
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
                                      Person person = Person(
                                        displayName: post.profile!.displayName.toString(),
                                        username: post.profile!.username.toString(),
                                        userID: post.profile!.userId.toString(),
                                        followersCount: post.profile!.followers!.toInt().toString(),
                                        followingCount: post.profile!.followings!.toInt().toString(),
                                        profilePic: post.profile!.avatar.toString(),
                                        bio: post.profile!.bio.toString(),
                                        coverImage: post.profile!.coverImage.toString(),
                                        id: post.profile!.id.toString(),
                                      );
                                      controller.pageToReportIn = null;
                                      controller.groupToReportIn = null;
                                      Get.to(() => ReportUser(person: person));
                                    } else if (value == 1) {
                                      showPlatformDialog(
                                        context: context,
                                        builder: (context) => BasicDialogAlert(
                                          title: Text(
                                            isMuted ? "UnMute @${post.profile!.username}" : "Mute @${post.profile!.username}",
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
                                                  "user_id": post.profile!.userId,
                                                  "username": post.profile!.username,
                                                };
                                                controller.putData(body, "/wayagram-service/graph/friend/mute-or-unmute-friend").then((value){
                                                  if(value.isSuccessful){
                                                    AppOverlay.showSuccessSnackBar(content: isMuted ? "User un-muted successfully" : "User muted successfully");
                                                    controller.getMuted.then((value){
                                                      controller.update(["post_profile_page"]);
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
                                            isBlocked ? "UnBlock @${post.profile!.username}" : "Block @${post.profile!.username}",
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
                                                  "user_id": post.profile!.userId,
                                                  "username": post.profile!.username,
                                                };
                                                if(isBlocked){
                                                  controller.postData(body, "/wayagram-service/graph/friend/unblock").then((value){
                                                    if(value.isSuccessful){
                                                      AppOverlay.showSuccessSnackBar(content: "User un-blocked successfully");
                                                      controller.getBlocked.then((value){
                                                        controller.update(["post_profile_page"]);
                                                      });
                                                    }else {
                                                      AppOverlay.showErrorSnackBar(content: "Something went wrong, Please try again later");
                                                    }
                                                  });
                                                }else{
                                                  controller.postData(body, "/wayagram-service/graph/friend/block").then((value){
                                                    if(value.isSuccessful){
                                                      AppOverlay.showSuccessSnackBar(content:  "User blocked successfully");
                                                      controller.getBlocked.then((value){
                                                        controller.update(["post_profile_page"]);
                                                      });
                                                    }else {
                                                      var message = "Something went wrong, Please try again later";
                                                      if(value.message.toString().contains("You can only block active friends")){
                                                        message = "You can only block active friends";
                                                      }
                                                      AppOverlay.showErrorSnackBar(content: message);
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
                                  '${post.profile!.displayName}',
                                  style: AppTextStyle.subtitle1.copyWith(
                                    color: const Color(0xff4F4F4F),
                                    fontSize: Get.textScaleFactor * 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            titleSpacing: 0,
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
