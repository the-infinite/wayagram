import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/create_posts/go_live.dart';
import 'package:wayagram/app/modules/create_posts/groups.dart';
import 'package:wayagram/app/modules/create_posts/normal_posts.dart';
import 'package:wayagram/app/modules/create_posts/pages.dart';
import 'package:wayagram/app/modules/create_posts/products.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/following_model_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/model/wallet_model.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_refresher.dart';
import '../../../global_widgets/helpers/dark_mode_helper.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/person_view.dart';
import '../../chats/new_chat.dart';
import '../../chats/new_group_chat.dart';
import '../../create_posts/donations.dart';
import '../../create_posts/events.dart';
import '../../create_posts/polls.dart';
import '../widgets/moments_view.dart';
import '../widgets/posts_view.dart';
import 'notification_view.dart';

class WayaBottomSheet extends StatelessWidget {
  WayaBottomSheet({Key? key, this.isChat = false}) : super(key: key);

  final bool isChat;
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        return Container(
          //height: Get.height * 0.65,
          decoration: BoxDecoration(
            color: getAppColor(AppColors.background),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              //Create text
              if(!isChat)
                Padding(
                padding: EdgeInsets.only(top: Get.height * 0.020, left: Get.width*0.15, right: 20,bottom: Get.height * 0.015),
                child: Text(
                  'Create',
                  style: AppTextStyle.subtitle1.copyWith(
                    color: getAppColor(Colors.black),
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.045,
                  ),
                ),
              ),
              if(!isChat)
                Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomSheetButton(
                      icon: Icons.post_add_rounded,
                      title: "POST",
                      subtitle: "Share a post or write what is on your mind",
                      onTap: () {
                        controller.isProductPost = false;
                        controller.pageToPost = null;
                        controller.groupToPost = null;
                        controller.postToQuote = null;
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(() => CreatePosts());
                      }
                  ),
                  BottomSheetButton(
                      icon: Icons.poll,
                      title: "POLLS",
                      subtitle: "Create paid or free polls for users",
                      onTap: () {
                        controller.imagePaths.clear();
                        controller.pageToPost = null;
                        controller.groupToPost = null;
                        Get.back();
                        Get.to(() => CreatePoll());
                      }
                  ),
                  BottomSheetButton(
                      icon: Icons.book_rounded,
                      title: "PAGES",
                      subtitle: "Create a page for your business or brand",
                      onTap: () {
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(() => CreatePage());
                      }
                  ),

                  SizedBox(
                    height: Get.height * 0.015,
                  ),

                  BottomSheetButton(
                      icon: Icons.people_alt_rounded,
                      title: "GROUP",
                      subtitle: "Create a private or public group of interest",
                      onTap: () {
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(() => CreateGroup());
                      }
                  ),
                  BottomSheetButton(
                      icon: Icons.calendar_today_rounded,
                      title: "EVENTS",
                      subtitle: "Bring people together with public or private events",
                      onTap: () {
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(() => CreateEvent());
                      }
                  ),
                  BottomSheetButton(
                      icon: Icons.people_alt_rounded,
                      title: "DONATION",
                      subtitle: "Create a donation page for a cause",
                      onTap: () {
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(() => CreateDonation());
                      }
                  ),

                  SizedBox(
                    height: Get.height * 0.015,
                  ),
                  BottomSheetButton(
                      icon: Icons.shopping_cart,
                      title: "PRODUCT",
                      subtitle: "Create and online display products for users to purchase",
                      onTap: () {
                        controller.isProductPost = true;
                        controller.pageToPost = null;
                        controller.groupToPost = null;
                        controller.postToQuote = null;
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(() => CreatePosts());
                      }
                  ),
                ],
              ),
              /*BottomSheetButton(
                  icon: Icons.video_camera_back_rounded,
                  title: "GO LIVE",
                  subtitle: "Go live on Wayagram",
                  onTap: () {
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => CreateLiveVideo());
                  }
              ),*/

              if(isChat)
                Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  BottomSheetButton(
                      icon: Icons.person_rounded,
                      title: "NEW CHAT",
                      subtitle: "Start a chat with a wayagram user",
                      onTap: () {
                        controller.isProductPost = false;
                        controller.pageToPost = null;
                        controller.groupToPost = null;
                        controller.postToQuote = null;
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(()=> NewChat());
                      }
                  ),
                  BottomSheetButton(
                      icon: Icons.group_rounded,
                      title: "NEW GROUP",
                      subtitle: "Start a group chat with multiple wayagram users",
                      onTap: () {
                        controller.imagePaths.clear();
                        Get.back();
                        Get.to(()=> const NewGroupChat());
                      }
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class GroupAndPageBottomSheet extends StatelessWidget {
  GroupAndPageBottomSheet({Key? key, this.isChat = false}) : super(key: key);

  final bool isChat;
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        return Container(
          //height: Get.height * 0.65,
          decoration: BoxDecoration(
            color: getAppColor(AppColors.background),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.020, left: Get.width*0.15, right: 20,bottom: Get.height * 0.015),
                  child: Text(
                    'Create',
                    style: AppTextStyle.subtitle1.copyWith(
                      color: getAppColor(Colors.black),
                      fontWeight: FontWeight.w600,
                      fontSize: Get.width * 0.045,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BottomSheetButton(
                        icon: Icons.post_add_rounded,
                        title: "POST",
                        subtitle: "Share a post or write what is on your mind",
                        onTap: () {
                          controller.isProductPost = false;
                          controller.postToQuote = null;
                          controller.imagePaths.clear();
                          Get.back();
                          Get.to(() => CreatePosts());
                        }
                    ),
                    BottomSheetButton(
                        icon: Icons.poll,
                        title: "POLLS",
                        subtitle: "Create paid or free polls for users",
                        onTap: () {
                          controller.imagePaths.clear();
                          Get.back();
                          Get.to(() => CreatePoll());
                        }
                    ),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}

class RepostBottomSheet extends StatelessWidget {
  RepostBottomSheet({Key? key, required this.post,this.undo = false}) : super(key: key);
  final AllPostsEntity post;
  final bool undo;
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        return Container(
          //height: Get.height * 0.65,
          decoration: BoxDecoration(
            color: getAppColor(AppColors.background),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Get.height * 0.01,
              ),
              if(!undo)
                BottomSheetButton(
                  icon: FeatherIcons.repeat,
                  title: "REPOST",
                  subtitle: "Share this post on your timeline",
                  onTap: () {
                    controller.imagePaths.clear();
                    Get.back();
                    var body = {
                      "original_post_id": post.id,
                      "reposter_profile_id": controller.profile.id,
                      //"repost_comment_desc": textController.text,
                    };
                    controller.postData(body, "/wayagram-service/all-posts/repost-post").then((value) async {
                      if(value.isSuccessful){
                        await controller.getPosts;
                        controller.update(['profile_page','home_tab','home']);
                        AppOverlay.showSuccessSnackBar(content: "Post reposted successfully");
                      }else{
                        AppOverlay.showErrorSnackBar(content: "Error reposting post");
                      }
                    });
                  }
              ),
              if(undo)
                BottomSheetButton(
                    icon: FeatherIcons.repeat,
                    title: "UNDO REPOST",
                    subtitle: "Remove this re-post from your timeline",
                    onTap: () {
                      controller.imagePaths.clear();
                      Get.back();
                      var body = {
                        "post_id": post.id,
                      };
                      controller.deleteData(body, "/wayagram-service/all-posts/delete?profile_id=${controller.profile.id}",updatePages: true).then((value) async {
                        if(value.isSuccessful){
                          await controller.getPosts;
                          controller.update(['profile_page','home_tab','home']);
                          if(Get.currentRoute == "/ViewPost"){
                            Get.back();
                          }
                          AppOverlay.showSuccessSnackBar(title: "Undo Repost",content: "Undo Repost successfully");
                        }else{
                          AppOverlay.showErrorSnackBar(title: "Undo Repost",content: value.message != null ? value.message.toString() : "Something went wrong");
                        }
                      });
                    }
                ),
              BottomSheetButton(
                  icon: FeatherIcons.edit,
                  title: "QUOTE POST",
                  subtitle: "Share your opinion on this post",
                  onTap: () {
                    controller.isProductPost = false;
                    controller.pageToPost = null;
                    controller.groupToPost = null;
                    controller.postToQuote = post;
                    controller.imagePaths.clear();
                    Get.back();
                    Get.to(() => CreatePosts());
                  }
              ),
            ],
          ),
        );
      }),
    );
  }
}

class WalletBottomSheet extends StatelessWidget {
  WalletBottomSheet({Key? key,this.title = "Wallet List",this.onTap}) : super(key: key);

  final Function(WalletModel wallet)? onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id:"wallet_bottom_sheet",builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color: getAppColor(AppColors.background),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.020, bottom: Get.height * 0.015),
                child: Text(
                  title,
                  style: AppTextStyle.subtitle1.copyWith(
                    color: getAppColor(Colors.black),
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.045,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.50,
                ),
                child: FutureBuilder<ApiResponse>(
                    future: controller.getData("temporal-service/api/v1/wallet/accounts/${controller.profile.userId}", true),
                    builder: (context, snapshot) {
                      var savedPosts = ReadWriteValue('wayagram_wallets', '', MyPref.box);
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts = WalletModel.listFromJson(snapshot.data!.data);
                        savedPosts.val = jsonEncode(posts);
                        if(posts.isEmpty){
                          return SizedBox(
                              height: Get.height*0.3,
                              child: Center(child: Text('No Wallets Available'),));
                        }
                        return ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var post = posts[index];
                            return BottomSheetButton(
                                icon: Icons.money_rounded,
                                title: post.accountNo.toString(),
                                subtitle: "${post.acctCrncyCode} ${post.clrBalAmt}",
                                onTap: () {
                                  if(onTap != null){
                                    Get.back();
                                    onTap!(post);
                                  }
                                }
                            );
                          },
                        );
                      }
                      else if(savedPosts.val.isNotEmpty){
                        var posts = WalletModel.listFromJson(jsonDecode(savedPosts.val));
                        if(posts.isEmpty){
                          return SizedBox(
                              height: Get.height*0.3,
                              child: Center(child: Text('No Wallets Available'),));
                        }
                        return ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var post = posts[index];
                            return BottomSheetButton(
                                icon: Icons.money_rounded,
                                title: post.accountNo.toString(),
                                subtitle: "${post.acctCrncyCode} ${post.clrBalAmt}",
                                onTap: () {
                                  if(onTap != null){
                                    Get.back();
                                    onTap!(post);
                                  }
                                }
                            );
                          },
                        );
                      }else{
                        if(snapshot.connectionState == ConnectionState.done){
                          return SizedBox(
                              height: Get.height*0.3,
                              child: Center(child: Text('No Wallets Available'),));
                        }
                        return NotificationView(isLoading: true);
                      }
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BottomSheetButton extends StatelessWidget {
  BottomSheetButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.only(left: Get.width*0.025, right: Get.width*0.025, top: Get.height*0.01, bottom: Get.height*0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Get.width*0.030),
              decoration: BoxDecoration(
                color: AppColors.fadedBlue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: AppColors.purple,
                size: Get.width*0.040,
              ),
            ),
            SizedBox(width: Get.width*0.025),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.subtitle1.copyWith(
                    color: getAppColor(Colors.black),
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.04,
                  ),
                ),
                SizedBox(
                  width: Get.width*0.80,
                  child: Text(
                    subtitle,
                    style: AppTextStyle.subtitle1.copyWith(
                      color: Colors.grey,
                      fontSize: Get.width*0.035,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PersonBottomSheet extends StatelessWidget {
  const PersonBottomSheet({Key? key,this.title = "Friends",this.buttonText = "Message",this.onTap}) : super(key: key);

  final Function(Person person)? onTap;
  final String title;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController(initialRefresh: false);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id:"friends_screen",builder: (controller) {
        var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var currentPage = ReadWriteValue('wayagram_following_current_page', 1, MyPref.box);
        var savedPosts = MyPref.following.val;
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Container(
          decoration: BoxDecoration(
            color: getAppColor(AppColors.background),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.020, bottom: Get.height * 0.015),
                child: Text(
                  title,
                  style: AppTextStyle.subtitle1.copyWith(
                    color: getAppColor(Colors.black),
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.045,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.50,
                ),
                child: AppRefresher(
                  onRefresh: () async {
                    final response = await controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=1',true);
                    if(response.isSuccessful){
                      var posts = FollowingModelEntity.fromJson(response.data);
                      if(posts.following != null){
                        if(posts.following!.isNotEmpty && savedPosts.isNotEmpty){
                          var saved = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                          if(saved.following!.isNotEmpty){
                            var first = saved.following!.first;
                            var current = posts.following!.first;
                            if(first.id != current.id){
                              posts.following = saved.following! + posts.following!;
                              MyPref.following.val = jsonEncode(posts);
                            }
                          }else{
                            MyPref.following.val = jsonEncode(response.data);
                          }
                        }
                      }
                    }
                    refreshController.refreshCompleted();
                    controller.update();
                  },
                  onLoading: () async {
                    final response = await controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=${currentPage.val}',true);
                    if(response.isSuccessful){
                      var posts = FollowingModelEntity.fromJson(response.data);
                      var saved = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                      for (var element in posts.following!) {
                        saved.following!.removeWhere((e) => e.id == element.id);
                      }
                      saved.following!.addAll(posts.following!);
                      MyPref.following.val = jsonEncode(saved);
                      if(posts.following!.isNotEmpty){
                        currentPage.val = currentPage.val + 1;
                      }
                    }
                    refreshController.loadComplete();
                    controller.update();
                  },
                  controller: refreshController,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<ApiResponse>(
                            future: controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=1',true),
                            builder: (context, snapshot) {
                              var savedPosts = MyPref.following.val;
                              if(savedPosts.isNotEmpty){
                                var posts = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                                var names = posts.following!.map((e) => e.displayName.toString()).toList();
                                var username = posts.following!.map((e) => e.username.toString()).toList();
                                var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                                var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                                return PersonView(
                                  name: names,
                                  username: username,
                                  profilePic: profile,
                                  length: posts.following == null ? 0 : posts.following!.length,
                                  userIDs: userIds,
                                  following: posts.following,
                                  showButton: true,
                                  buttonName: buttonText,
                                  onButtonClick: (person) async{
                                    if(onTap != null){
                                      onTap!(person);
                                    }
                                  },
                                );
                              }else{
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                  var posts = FollowingModelEntity.fromJson(snapshot.data!.data);
                                  var names = posts.following!.map((e) => e.displayName.toString()).toList();
                                  var username = posts.following!.map((e) => e.username.toString()).toList();
                                  var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                                  var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                                  MyPref.following.val = jsonEncode(posts);
                                  currentPage.val = 2;
                                  return PersonView(
                                    name: names,
                                    username: username,
                                    profilePic: profile,
                                    length: posts.following == null ? 0 : posts.following!.length,
                                    userIDs: userIds,
                                    following: posts.following,
                                    showButton: true,
                                    buttonName: buttonText,
                                    onButtonClick: (person) async{
                                      if(onTap != null){
                                        onTap!(person);
                                      }
                                    },
                                  );
                                }
                                return NotificationView(isLoading: true);
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class MomentViewBottomSheet extends StatelessWidget {
  const MomentViewBottomSheet({Key? key,this.title = "Friends",this.buttonText = "Message",this.onTap, required this.momentId}) : super(key: key);

  final Function(Person person)? onTap;
  final String title;
  final String buttonText;
  final String momentId;
  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController(initialRefresh: false);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id:"friends_screen",builder: (controller) {
        var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var savedPosts = ReadWriteValue('wayagram_moments_views_$momentId', "", MyPref.box);

        return Container(
          decoration: BoxDecoration(
            color: getAppColor(AppColors.background),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.020, bottom: Get.height * 0.015),
                child: Text(
                  title,
                  style: AppTextStyle.subtitle1.copyWith(
                    color: getAppColor(Colors.black),
                    fontWeight: FontWeight.w600,
                    fontSize: Get.width * 0.045,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.50,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<ApiResponse>(
                          future: controller.getData('wayagram-service/all-posts/get-moment-viewers?profile_id=${profile.id}&moment_id=$momentId',true),
                          builder: (context, snapshot) {
                            if(savedPosts.val.isNotEmpty){
                              var listToUse = jsonDecode(savedPosts.val) as List;
                              List<String> names = [];
                              List<String> username = [];
                              List<String> profile = [];
                              List<String> userIds = [];
                              for (var element in listToUse) {
                                var posts = FullUserProfileEntity.fromJson(element['Profile']);
                                names.add(posts.displayName.toString());
                                username.add(posts.username.toString());
                                profile.add(posts.avatar.toString());
                                userIds.add(posts.userId.toString());
                              }
                              return PersonView(
                                name: names,
                                username: username,
                                profilePic: profile,
                                length: listToUse.length,
                                userIDs: userIds,
                                showButton: false,
                                buttonName: buttonText,
                                onButtonClick: (person) async{
                                  if(onTap != null){
                                    onTap!(person);
                                  }
                                },
                              );
                            }else{
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                var listToUse = snapshot.data!.data['MomentViews'] as List;
                                List<String> names = [];
                                List<String> username = [];
                                List<String> profile = [];
                                List<String> userIds = [];
                                for (var element in listToUse) {
                                  var posts = FullUserProfileEntity.fromJson(element['Profile']);
                                  names.add(posts.displayName.toString());
                                  username.add(posts.username.toString());
                                  profile.add(posts.avatar.toString());
                                  userIds.add(posts.userId.toString());
                                }
                                savedPosts.val = jsonEncode(listToUse);

                                return PersonView(
                                  name: names,
                                  username: username,
                                  profilePic: profile,
                                  length: listToUse.length,
                                  userIDs: userIds,
                                  showButton: false,
                                  buttonName: buttonText,
                                  onButtonClick: (person) async{
                                    if(onTap != null){
                                      onTap!(person);
                                    }
                                  },
                                );
                              }
                              return NotificationView(isLoading: true);
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}