import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/app/modules/home/widgets/bottom_sheet.dart';
import 'package:wayagram/app/modules/profile/inner_pages/blocked.dart';
import 'package:wayagram/app/modules/profile/inner_pages/muted.dart';
import 'package:wayagram/app/modules/profile/update_profile.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/GroupMediaModel.dart';
import '../../data/model/GroupMembersModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/followers_model_entity.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/friends_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/model/log_in_model_entity.dart';
import '../../data/model/products_model_entity.dart';
import '../../data/model/profile_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_drawer.dart';
import '../../global_widgets/gallery_view.dart';
import '../../global_widgets/page_input.dart';
import '../../global_widgets/person_view.dart';
import '../create_posts/normal_posts.dart';
import '../home/widgets/notification_view.dart';
import '../home/widgets/posts_view.dart';
import '../home/widgets/product_view.dart';
import '../profile/inner_pages/followers.dart';
import '../profile/inner_pages/following.dart';
import '../profile/report_user.dart';
import '../setup/interests.dart';
import '../sign_up/sign_up.dart';
import 'edit/edit_group.dart';
import 'invite/invite_to_group_or_pages.dart';

class Group extends StatefulWidget {
  Group({Key? key, required this.group,this.joined = false}) : super(key: key);

  final GroupModelEntity group;
  final bool joined;

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> with TickerProviderStateMixin{
  late TabController tabController;
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var top = 0.0;
    var group = widget.group;
    var groupRequestSent = false;
    var groupJoined = false;

    var savedMutedGroups = ReadWriteValue('wayagram_muted_groups', '', MyPref.box);
    List<String> mutedGroups = [];
    if(savedMutedGroups.val.isNotEmpty){
      mutedGroups = savedMutedGroups.val.split(',');
    }

    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(
          id: 'group_screen',
          builder: (controller) {
            var buttonText = 'Join Group';

            var memberCount = 0;
            var isForUser = false;
            var isUserAMember = false;
            var isUserAAdmin = false;
            var isPublic = false;
            var muted = false;
            var userMuted = false;
            var allowMemberPost = false;

            if(group.numberOfMembers != null) {
              memberCount = group.numberOfMembers!.toInt();
            }
            isUserAAdmin = group.isUserAdmin == true;
            isUserAMember = group.isUserAMember == true;
            isPublic = group.isPublic == true;
            muted = group.mute == true;
            userMuted = group.isUserOnMute == true;
            allowMemberPost = group.allowMemberPost == true;
            if(groupJoined){
              isUserAMember = true;
            }
            if(isUserAMember || widget.joined) {
              if(isUserAAdmin) {
                buttonText = 'Edit';
              } else {
                buttonText = '';
              }
            }else{
              if(isPublic) {
                buttonText = 'Join Group';
              } else {
                buttonText = 'Send Request';
              }
            }

            var savedPosts = ReadWriteValue('wayagram_created_groups', '', MyPref.box);
            if(savedPosts.val.isNotEmpty){
              var allGroups = GroupModelEntity.getService(jsonDecode(savedPosts.val));
              for(var i = 0; i < allGroups.length; i++){
                var element = allGroups[i];
                if(element.id == group.id){
                  group = element;
                  isForUser = true;
                  buttonText = 'Edit';
                  isUserAAdmin = element.isUserAdmin == true;
                  isUserAAdmin = element.isUserAdmin == true;
                  isUserAMember = element.isUserAMember == true;
                  isPublic = element.isPublic == true;
                  muted = element.mute == true;
                  userMuted = element.isUserOnMute == true;
                  allowMemberPost = element.allowMemberPost == true;
                  break;
                }
              }
            }

            if(fullProfile.id == group.userId){
              isForUser = true;
              buttonText = 'Edit';
            }

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverLayoutBuilder(
                      builder: (BuildContext context, constraints) {
                        final scrolled = constraints.scrollOffset >= ((Get.height * 0.20));
                        return SliverAppBar(
                          expandedHeight: Get.height * 0.32,
                          floating: false,
                          pinned: true,
                          flexibleSpace: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                return FlexibleSpaceBar(
                                  stretchModes: [
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
                                                group.headerImageUrl.toString(),
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
                                                    imgUrl: group.imageUrl.toString(),
                                                    isGroup: true,
                                                  ),
                                                  onPressed: () {

                                                  },
                                                ),
                                              ),
                                            ),

                                            if(buttonText.isNotEmpty)
                                              Positioned(
                                              bottom: 0,
                                              right: 20,
                                              child: SizedBox(
                                                width: Get.width*0.3,
                                                child: AppButton(
                                                  title: buttonText,
                                                  onPressed: () async {
                                                    controller.imagePaths.clear();
                                                    controller.image1 = "";
                                                    controller.image2 = "";
                                                    if(buttonText == "Edit"){
                                                      Get.to(() => EditGroup(editInfo: group));
                                                    }else{
                                                      var body = {
                                                        "groupId": group.id,
                                                        "userId": fullProfile.id,
                                                      };

                                                      var response = await controller.postData(body, "/wayagram-service/main/group/join-group");
                                                      if(response.isSuccessful){
                                                        var newRes = await controller.getData("/wayagram-service/main/group/get-all-user-created-groups?pageNumber=1&userId=${fullProfile.id}", true);
                                                        if(newRes.isSuccessful){
                                                          var savedPosts = ReadWriteValue('wayagram_created_groups', '', MyPref.box);
                                                          final posts = GroupModelEntity.getService(response.groups);
                                                          savedPosts.val = jsonEncode(posts);
                                                        }
                                                        if(buttonText == "Join Group") {
                                                          groupJoined = true;
                                                        } else {
                                                          groupRequestSent = true;
                                                        }
                                                        controller.update(['group_screen']);
                                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                                      }else{
                                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                                      }
                                                    }
                                                  },
                                                  borderRadius: 10,
                                                  fontColor: AppColors.primary,
                                                  bckgrndColor: getAppColor(AppColors.background),
                                                  border: Border.all(color: AppColors.primary, width: 1),
                                                  padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: 5),
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
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${group.name}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Get.width*0.04,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: Get.height*0.002),
                                            if(group.description.toString() != "null")
                                              Text(
                                                group.description.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: Get.width*0.04,
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
                                      color: Colors.black,
                                    ),
                                    onPressed: (){
                                      Get.back();
                                    },
                                    iconSize: Get.width * 0.06,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            PopupMenuButton(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.5,right: 5),
                                  child: Column(
                                    children: [
                                      Container(
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
                                            color: Colors.black,
                                          ),
                                          onPressed: null,
                                          iconSize: Get.width * 0.06,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onSelected: (value) async {
                                  if (value == 0) {
                                    Get.to(() => InviteToGroupOrPage(group: group,isGroup: true));
                                  }
                                  else if (value == 1) {
                                    await Share.share('Join me on this wayagram group https://app.staging.wayagram.ng/wayagram-group/${group.id}?from=shared', subject: 'Wayagram Group');
                                  }
                                  else if (value == 2) {
                                    AppOverlay.showDeviceDialog(
                                      title: "Mute Group",
                                      content: "Are you sure you want to mute this group?",
                                      onPositivePressed: (){
                                        var body = {
                                          "groupId": group.id,
                                          "userId": fullProfile.id
                                        };
                                        controller.putData(body, "/wayagram-service/main/group/mute-group-from-user-end",updatePages: false).then((value){
                                          if(value.isSuccessful){
                                            if(value.message.toString().trim().toLowerCase() == "mute success"){
                                              mutedGroups.add(group.id.toString());
                                              savedMutedGroups.val = mutedGroups.join(",");
                                              AppOverlay.showSuccessSnackBar(content: "Group muted successfully");
                                            }else{
                                              mutedGroups.remove(group.id.toString());
                                              savedMutedGroups.val = mutedGroups.join(",");
                                              AppOverlay.showSuccessSnackBar(content: "Group un-muted successfully");
                                            }
                                            controller.update(['group_screen']);
                                          }else{
                                            AppOverlay.showErrorSnackBar(content: "An Error Occurred while muting group, please try again later");
                                          }
                                        });
                                      }
                                    );
                                  }
                                  else if (value == 3) {
                                    var person = Person(
                                      displayName: group.name.toString(),
                                      username: group.name.toString(),
                                      profilePic: group.imageUrl.toString(),
                                      bio:group.description.toString(),
                                      userID: group.id.toString(),
                                      id: group.id.toString(),
                                      followersCount: "0",
                                      followingCount: "0",
                                      coverImage: group.headerImageUrl.toString(),
                                    );
                                    Get.to(() => ReportUser(person: person,group: group,isGroup: true,));
                                  }
                                  else if (value == 4) {
                                    AppOverlay.showDeviceDialog(
                                        title: isForUser? "Delete Group":"Exit Group",
                                        content: isForUser? "Are you sure you want to delete this group?": "Are you sure you want to leave this group?",
                                        onPositivePressed: (){
                                          var body = {
                                            "groupId": group.id,
                                            "userId": fullProfile.id
                                          };
                                          controller.putData(body, "/wayagram-service/main/group/leave-and-delete-group",updatePages: false).then((value){
                                            if(value.isSuccessful){
                                              if(Get.currentRoute == "/Group"){
                                                Get.back();
                                              }
                                              controller.update();
                                              if(isForUser){
                                                AppOverlay.showSuccessSnackBar(content: "${group.name} Group deleted successfully");
                                              }else{
                                                AppOverlay.showSuccessSnackBar(content: "${group.name} Group left successfully");
                                              }
                                            }else{
                                              AppOverlay.showErrorSnackBar(content: "An Error Occurred, please try again later");
                                            }
                                          });
                                        }
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  if(isUserAMember || isForUser || widget.joined)
                                    PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      "Invite",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      "Share",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if(isUserAMember || isForUser|| widget.joined)
                                    PopupMenuItem(
                                    value: 2,
                                    child: Text(
                                      (muted || mutedGroups.contains(group.id.toString())) ? "UnMute" : "Mute",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if(isUserAMember || isForUser || widget.joined)
                                    PopupMenuItem(
                                    value: 3,
                                    child: Text(
                                      "Report",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if(isUserAMember || isForUser || widget.joined)
                                    PopupMenuItem(
                                    value: 4,
                                    child: Text(
                                      isForUser ? "Delete":"Exit",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                          title: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: scrolled ? 1.0 : 0.0,
                            child: Text(
                              group.name.toString(),
                              style: AppTextStyle.subtitle1.copyWith(
                                color: getAppColor(Color(0xff4F4F4F)),
                                fontWeight: FontWeight.bold,
                                fontSize: Get.textScaleFactor * 18,
                              ),
                            ),
                          ),
                          backgroundColor: getAppColor(AppColors.background),
                          systemOverlayStyle: SystemUiOverlayStyle(
                              statusBarColor: scrolled ? getAppColor(AppColors.background) : Colors.transparent,
                              statusBarIconBrightness: getAppBrightness(),
                              statusBarBrightness: getAppBrightness(),
                              systemNavigationBarColor: getAppColor(AppColors.background),
                              systemNavigationBarIconBrightness: getAppBrightness()
                          ),
                          bottom: PreferredSize(
                              preferredSize: Size(Get.width, Get.height * 0.06),
                              child: Column(
                                children: [
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: scrolled ? 1.0 : 0.0,
                                    child: Divider(
                                      height: 0.5,
                                      thickness: 0.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.05,
                                    child: TabBar(
                                      controller: tabController,
                                      padding: EdgeInsets.zero,
                                      labelColor: Colors.black,
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
                                      tabs: [
                                        Tab(text: 'Posts',iconMargin: EdgeInsets.zero,),
                                        Tab(text: 'Media',iconMargin: EdgeInsets.zero,),
                                        Tab(text: "Members",iconMargin: EdgeInsets.zero,),
                                      ],
                                      onTap: (index) {
                                        //pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                        //controller.update(['profile_page']);
                                      },
                                    ),
                                  ),
                                  Divider(
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
                    FutureBuilder<ApiResponse>(
                        future: controller.getData("/wayagram-service/all-posts/group-posts?profile_id=${fullProfile.id}&group_id=${group.id}", true),
                        builder: (context, snapshot) {
                          var savedPosts = ReadWriteValue('wayagram_group_${group.id}', '', MyPref.box);
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                            final posts = AllPostsEntity.getService(snapshot.data!.data['data']);
                            savedPosts.val = jsonEncode(posts);
                            return PostsView(posts: posts,userID: fullProfile.userId);
                          } else if(savedPosts.val.isNotEmpty){
                            var posts = AllPostsEntity.getService(jsonDecode(savedPosts.val));
                            return PostsView(posts: posts,userID: fullProfile.userId);
                          }else{
                            if(snapshot.connectionState == ConnectionState.done){
                              return SizedBox.shrink();
                            }
                            return PostsView(isLoading: true);
                          }
                        }),
                    FutureBuilder<ApiResponse>(
                        future: controller.getData("/wayagram-service/main/group/get-media-files-by-group-id?group_id=${group.id}", true),
                        builder: (context, snapshot) {
                          var savedPosts = ReadWriteValue('wayagram_group_images_${group.id}', '', MyPref.box);
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                            final posts = GroupMediaModel.listFromJson(snapshot.data!.data);
                            savedPosts.val = jsonEncode(posts);
                            return GalleryView(
                                key: ValueKey("group_gallery"),
                                imageUrlList: posts.map((e) => e.fileUrl.toString()).toList()
                            );
                          } else if(savedPosts.val.isNotEmpty){
                            var posts = GroupMediaModel.listFromJson(jsonDecode(savedPosts.val));
                            return GalleryView(
                                key: ValueKey("group_gallery"),
                                imageUrlList: posts.map((e) => e.fileUrl.toString()).toList()
                            );
                          }else{
                            if(snapshot.connectionState == ConnectionState.done){
                              return SizedBox.shrink();
                            }
                            return PostsView(isLoading: true);
                          }
                        }),
                    FutureBuilder<ApiResponse>(
                        future: controller.getData("/wayagram-service/main/group/see-all-members-in-group?groupId=${group.id}", true),
                        builder: (context, snapshot) {
                          var savedPosts = ReadWriteValue('wayagram_group_followers_${group.id}', '', MyPref.box);
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                            final posts = GroupMembersModel.listFromJson(snapshot.data!.data);
                            savedPosts.val = jsonEncode(posts);
                            //final posts = snapshot.data!.data as FollowersModelEntity;

                            var names = posts.map((e) => e.profile!.displayName.toString()).toList();
                            var username = posts.map((e) => e.profile!.username.toString()).toList();
                            var profile = posts.map((e) => e.profile!.avatar.toString()).toList();
                            var userIds = posts.map((e) => e.profile!.userId.toString()).toList();
                            var ids = posts.map((e) => e.profile!.id.toString()).toList();

                            return PersonView(
                              name: names,
                              username: username,
                              profilePic: profile,
                              length: posts.length,
                              userIDs: userIds,
                              iDs: ids,
                              showReport: true,
                              onReportClick: (value) {
                                controller.pageToPost = null;
                                controller.groupToPost = group;
                                Get.to(() => ReportUser(
                                  person: value,
                                  group: group,
                                ));
                              },
                            );
                          } else if(savedPosts.val.isNotEmpty){
                            var posts = GroupMembersModel.listFromJson(jsonDecode(savedPosts.val));
                            var names = posts.map((e) => e.profile!.displayName.toString()).toList();
                            var username = posts.map((e) => e.profile!.username.toString()).toList();
                            var profile = posts.map((e) => e.profile!.avatar.toString()).toList();
                            var userIds = posts.map((e) => e.profile!.userId.toString()).toList();
                            var ids = posts.map((e) => e.profile!.id.toString()).toList();

                            return PersonView(
                              name: names,
                              username: username,
                              profilePic: profile,
                              length: posts.length,
                              userIDs: userIds,
                              iDs: ids,
                              showReport: true,
                              onReportClick: (value) {
                                controller.pageToPost = null;
                                controller.groupToPost = group;
                                Get.to(() => ReportUser(
                                  person: value,
                                  group: group,
                                ));
                              },
                            );
                          }else{
                            return NotificationView(isLoading: true);
                          }
                        }),
                  ],
                ),
              ),
              floatingActionButton: ((isUserAMember && allowMemberPost) || isForUser || widget.joined) ? FloatingActionButton(
              onPressed: () {
                controller.isProductPost = false;
                controller.pageToPost = null;
                controller.groupToPost = group;
                controller.imagePaths.clear();
                //Get.to(() => CreatePosts());
                Get.bottomSheet(
                    GroupAndPageBottomSheet(
                      isChat: controller.currentBottomNavPage.value == 4,
                    ),
                    isScrollControlled: true
                );
              },
              backgroundColor: AppColors.primary,
              child: Icon(Icons.add,color: Colors.white),
            ) : null,
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
