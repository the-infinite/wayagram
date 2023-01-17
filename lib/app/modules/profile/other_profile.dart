import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/app/modules/profile/inner_pages/blocked.dart';
import 'package:wayagram/app/modules/profile/inner_pages/muted.dart';
import 'package:wayagram/app/modules/profile/report_user.dart';
import 'package:wayagram/app/modules/profile/update_profile.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

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
import '../../global_widgets/app_drawer.dart';
import '../../global_widgets/page_input.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/posts_view.dart';
import '../home/widgets/product_view.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';
import 'inner_pages/followers.dart';
import 'inner_pages/following.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({Key? key,required this.info,this.post}) : super(key: key);

  static const route = '/otherProfile';

  final List<String> info;
  final AllPostsEntity? post;
  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> with TickerProviderStateMixin{
  List<String> savedFollowingList = [];
  var controller = Get.find<HomeControllerWayagram>();
  var page = 0;

  var pos = 0;
  bool showName = false;
  bool showTab = false;

  late TabController tabController;
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final savedFollowing = ReadWriteValue('wayagram_saved_following', "", MyPref.box);
    if(savedFollowing.val.isNotEmpty){
      savedFollowingList = savedFollowing.val.split(",");
    }
    var top = 0.0;
    var arguments = widget.info;
    var userId = arguments[3];
    var userName = arguments[1];
    var userImage = arguments[2];
    var userBio = arguments[4];
    var userFollowers = arguments[6];
    var userFollowing = arguments[7];
    var userPosts = arguments[5];
    var displayName = arguments[0];
    var coverImage = arguments[8];
    var id = "";
    var privateUser = false;
    if(arguments.length > 9){
      id = arguments[9];
    }
    if(arguments.length > 10){
      privateUser = arguments[10] == "true";
    }

    var followersCount = 0;
    var followingCount = 0;
    var postsCount = 0;

    if(widget.post != null){
      followersCount = widget.post!.profile!.followers!.toInt();
      followingCount = widget.post!.profile!.followings!.toInt();
      postsCount = widget.post!.profile!.posts!.toInt();
    }

    final userDetails = ReadWriteValue('wayagram_user_details$userId$id', "", MyPref.box);
    if(userDetails.val.isNotEmpty){
      var model = FullUserProfileEntity.fromJson(jsonDecode(userDetails.val));
      followingCount = model.followings ?? 0;
      followersCount = model.followers ?? 0;
      postsCount = model.posts ?? 0;
    }
    controller.getData("/wayagram-service/main/profile/get-by-user-id?user_id=$userId", true).then((value){
      if(value.isSuccessful){
        userDetails.val = jsonEncode(value.data);
        var model = FullUserProfileEntity.fromJson(value.data);

        followingCount = model.followings ?? 0;
        followersCount = model.followers ?? 0;
        postsCount = model.posts ?? 0;
        controller.update(['other_profile_page']);
      }else{
       /* AppOverlay.showErrorSnackBar(content: "Unable To Get Profile, Pls Try Again");*/
      }
    });
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(
          id: 'other_profile_page',
          builder: (controller) {
            var followers = FollowersModelEntity.fromJson(jsonDecode(MyPref.followers.val));
            var following = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
            var blocked = BlockedAccountsEntity.getService(jsonDecode(MyPref.restrictedAccounts.val));
            var muted = BlockedAccountsEntity.getService(jsonDecode(MyPref.mutedAccounts.val));

            var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

            var isAFollower = followers.followers!.any((element) => element.username == userName);
            var isFollowing = following.following!.any((element) => element.username == userName) || savedFollowingList.contains(id);
            var isBlocked = blocked.any((element) => element.username == userName);
            var isMuted = muted.any((element) => element.username == userName);

            if(isFollowing){
              if(!savedFollowingList.contains(id)){
                savedFollowingList.add(id);
                savedFollowing.val = savedFollowingList.join(",");
              }
            }else{
              if(savedFollowingList.contains(id)){
                isFollowing = true;
              }else{
                isFollowing = false;
              }
            }

            var postListID = id;

            //https://services.staging.wayagram.ng/wayagram-service/main/profile/get-by-user-id?user_id=8&sso_id=313
            return Scaffold(
              body:Stack(
                alignment: Alignment.topCenter,
                children: [
                  ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    child: Image.network(
                                      coverImage.toString(),
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
                                      icon: AppAvatar(
                                        imgUrl: userImage.toString(),
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
                                      title: isFollowing ? 'Following' : privateUser ? 'Send Request' : 'Follow',
                                      onPressed: () async {
                                        var body = {
                                          "user_id": userId,
                                          "username": userName
                                        };
                                        if(!isFollowing){
                                          var response = await controller.postData(body, "wayagram-service/graph/friend/follow");
                                          if(response.isSuccessful){
                                            if(response.message.toString().toLowerCase().contains("request")){
                                              AppOverlay.showSuccessSnackBar(content :"Follow request sent successfully");
                                            }else{
                                              AppOverlay.showSuccessSnackBar(content :"User Followed successfully");
                                              savedFollowingList.add(id);
                                              savedFollowing.val = savedFollowingList.join(",");
                                              controller.getFollowing;
                                              controller.update(['other_profile_page']);
                                              setState(() {

                                              });
                                            }
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
                                            following.following!.removeWhere((element) => element.userId == userId);
                                            MyPref.following.val = jsonEncode(following);
                                            savedFollowingList.remove(id);
                                            savedFollowing.val = savedFollowingList.join(",");
                                            controller.getFollowing;
                                            controller.update(['other_profile_page']);
                                            setState(() {

                                            });
                                          }else{
                                            AppOverlay.showErrorSnackBar();
                                          }
                                        }
                                      },
                                      borderRadius: 10,
                                      fontColor: isFollowing ? AppColors.primary : getAppColor(AppColors.background),
                                      bckgrndColor: isFollowing ? getAppColor(AppColors.background) : AppColors.primary,
                                      border: Border.all(color: isFollowing ? AppColors.primary : getAppColor(AppColors.background), width: 1),
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                      fontSize: Get.width * 0.04,
                                      width: Get.width * 0.32,
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
                                    displayName,
                                    style: TextStyle(
                                      color: getAppColor(Colors.black),
                                      fontSize: Get.width*0.04,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                if(userBio != "null" && userBio.isNotEmpty)
                                  const SizedBox(height: 2),
                                if(userBio != "null" && userBio.isNotEmpty)
                                  SizedBox(
                                    width: Get.width,
                                    child: Text(
                                      userBio,
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
                                    //Get.to(() => Followers());
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        followersCount.toString(),
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
                                    //Get.to(() => Following());
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        followingCount.toString(),
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
                                  postsCount.toString(),
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
                          if(!privateUser || isFollowing)
                            TabBar(
                              controller: tabController,
                              padding: EdgeInsets.zero,
                              labelColor: getAppColor(Colors.black),
                              unselectedLabelColor: Color(0xff9A9A9A),
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
                                //pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                setState(() {
                                  pos = index;
                                });
                              },
                            ),
                          if(!privateUser || isFollowing)
                            const Divider(
                              height: 0.5,
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                        ],
                      ),
                      if((privateUser && !isFollowing))
                        SizedBox(
                          width: Get.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: Get.height*0.25,),
                              Icon(Icons.lock,size: Get.width*0.2,color: Colors.grey,),
                              SizedBox(height: Get.height*0.02,),
                              Text("This profile is private",style: AppTextStyle.bodyText1.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: Get.textScaleFactor*18,
                              ),),
                            ],
                          ),
                        ),
                      if(!(privateUser && !isFollowing))
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
                                          return SizedBox.shrink();
                                        }
                                        return PostsView(isLoading: true);
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
                                          return SizedBox.shrink();
                                        }
                                        return ProductView(isLoading: true);
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
                                          return SizedBox.shrink();
                                        }
                                        return PostsView(isLoading: true);
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
                                          return SizedBox.shrink();
                                        }
                                        return PostsView(isLoading: true);
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
                          backgroundColor: showName ? getAppColor(AppColors.background) : Colors.transparent,
                          title: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: showName ? 1.0 : 0.0,
                              child: Text(
                                displayName,
                                style: AppTextStyle.subtitle1.copyWith(
                                  color: getAppColor(getAppColor(Color(0xff4F4F4F))),
                                  fontSize: Get.textScaleFactor * 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          leading: Center(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Container(
                                width: Get.width * 0.1,
                                height: Get.width * 0.1,
                                decoration: BoxDecoration(
                                  color: getAppColor(AppColors.background),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    FeatherIcons.arrowLeft,
                                    color: getAppColor(Colors.black),
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
                                color: getAppColor(Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.5,right: 5),
                                  child: Center(
                                    child: Container(
                                      width: Get.width * 0.1,
                                      height: Get.width * 0.1,
                                      decoration: BoxDecoration(
                                        color: getAppColor(AppColors.background),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: getAppColor(Colors.black),
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
                                        displayName: displayName,
                                        username: userName,
                                        userID: userId,
                                        followersCount: userFollowers,
                                        followingCount: userFollowing,
                                        profilePic: userImage,
                                        bio: userBio,
                                        coverImage: coverImage,
                                        id: id
                                    );
                                    controller.pageToReportIn = null;
                                    controller.groupToReportIn = null;
                                    Get.to(() => ReportUser(person: person));
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
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      isMuted ? "Unmute User" : "Mute User",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Text(
                                      isBlocked ? "Unblock User" : "Block User",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: getAppColor(Colors.black),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                          bottom: PreferredSize(
                              preferredSize: Size.fromHeight(1.0),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: showName ? 1.0 : 0.0,
                                child: Container(
                                  color: Color(0xffEDEAEA),
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
                      if(!privateUser || isFollowing)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: showTab ? 1.0 : 0.0,
                          child: Container(
                            color: getAppColor(AppColors.background),
                            child: TabBar(
                              controller: tabController,
                              padding: EdgeInsets.zero,
                              labelColor: getAppColor(Colors.black),
                              unselectedLabelColor: Color(0xff9A9A9A),
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
                                //pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                setState(() {
                                  pos = index;
                                });
                              },
                            ),
                          ),
                        ),
                      if(!privateUser || isFollowing)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: showTab ? 1.0 : 0.0,
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
}
