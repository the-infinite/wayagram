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

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
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
import 'edit/edit_page.dart';
import 'invite/invite_to_group_or_pages.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({Key? key, required this.page}) : super(key: key);

  final GroupModelEntity page;

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> with TickerProviderStateMixin{
  late TabController tabController;
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var top = 0.0;
    var page = widget.page;
    var pageFollowed = false;

    var savedMutedPages = ReadWriteValue('wayagram_muted_pages', '', MyPref.box);
    List<String> mutedPages = [];
    if(savedMutedPages.val.isNotEmpty){
      mutedPages = savedMutedPages.val.split(',');
    }

    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(
          id: 'page_screen',
          builder: (controller) {
            var memberCount = 0;
            var buttonText = 'Follow Page';
            var isForUser = false;
            var isUserAMember = false;
            var isUserAAdmin = false;
            var isPublic = false;
            var muted = false;
            var userMuted = false;
            var allowMemberPost = true;
            if(page.numberOfMembers != null) {
              memberCount = page.numberOfMembers!.toInt();
              isUserAAdmin = page.isUserAdmin == true;
              isUserAMember = page.isUserAMember == true;
              isPublic = page.isPublic == true;
              muted = page.mute == true;
              userMuted = page.isUserOnMute == true;
              allowMemberPost = page.allowMemberPost == true;
              if(isUserAMember) {
                if(isUserAAdmin) {
                  buttonText = 'Edit';
                } else {
                  buttonText = '';
                }
              }else{
                if(isPublic) {
                  buttonText = 'Follow Page';
                } else {
                  buttonText = 'Send Request';
                }
              }
            }

            var savedPosts = MyPref.pagesFollowed;
            if(savedPosts.val.isNotEmpty){
              var allGroups = GroupModelEntity.getService(jsonDecode(savedPosts.val));
              for(var i = 0; i < allGroups.length; i++){
                var element = allGroups[i];
                if(element.id == page.id){
                  page = element;
                  buttonText = 'Unfollow Page';
                  isUserAAdmin = element.isUserAdmin == true;
                  isUserAAdmin = element.isUserAdmin == true;
                  isUserAMember = true;
                  isPublic = element.isPublic == true;
                  muted = element.mute == true;
                  userMuted = element.isUserOnMute == true;
                  allowMemberPost = element.allowMemberPost == true;
                  break;
                }
              }
            }

            if(fullProfile.id == page.userId){
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
                                                page.headerImageUrl.toString(),
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
                                                    imgUrl: page.imageUrl.toString(),
                                                    isPage: true,
                                                  ),
                                                  onPressed: () {

                                                  },
                                                ),
                                              ),
                                            ),
                                            //Edit Profile
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
                                                        Get.to(() => EditPage(editInfo: page));
                                                      }else{
                                                        var body = {
                                                          "pageId": page.id,
                                                          "userId": fullProfile.id,
                                                        };

                                                        var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                                                        if(response.isSuccessful){
                                                          await controller.getPagesFollowed;
                                                          await controller.getSuggestedPages;
                                                          if(buttonText == "Follow Page") {
                                                            //pageFollowed = true;
                                                          }
                                                          controller.update(['page_screen']);
                                                          controller.update();
                                                          Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                                        }else{
                                                          Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                                        }
                                                      }
                                                    },
                                                    borderRadius: 10,
                                                    fontColor: AppColors.primary,
                                                    bckgrndColor: AppColors.background,
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
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${page.name}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Get.width*0.04,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: Get.height*0.002),
                                            if(page.description.toString() != "null")
                                              Text(
                                                page.description.toString(),
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
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  width: Get.width * 0.1,
                                  height: Get.width * 0.1,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
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
                                    ],
                                  ),
                                ),
                                onSelected: (value) async {
                                  if (value == 0) {
                                    Get.to(() => InviteToGroupOrPage(page: page,isPage: true));
                                  }
                                  else if (value == 1) {
                                    await Share.share('Join me on wayagram to follow this page https://app.staging.wayagram.ng/wayagram-page/${page.id}?from=shared', subject: 'Wayagram Page');
                                  }
                                  else if (value == 2) {
                                    var person = Person(
                                      displayName: page.name.toString(),
                                      username: page.name.toString(),
                                      profilePic: page.imageUrl.toString(),
                                      bio:page.description.toString(),
                                      userID: page.id.toString(),
                                      id: page.id.toString(),
                                      followersCount: "0",
                                      followingCount: "0",
                                      coverImage: page.headerImageUrl.toString(),
                                    );
                                    Get.to(() => ReportUser(person: person,page: page,isPage: true,));
                                  }
                                  else if (value == 3) {
                                    AppOverlay.showDeviceDialog(
                                        title: "Delete Group",
                                        content: "Are you sure you want to delete this group?",
                                        onPositivePressed: (){
                                          var body = {
                                            "pageId": page.id,
                                            "userId": fullProfile.id
                                          };
                                          controller.deleteData(body, "/wayagram-service/main/page/admin-delete-page",updatePages: false).then((value){
                                            if(value.isSuccessful){
                                              if(Get.currentRoute == "/PageScreen"){
                                                Get.back();
                                              }
                                              controller.update();
                                              AppOverlay.showSuccessSnackBar(content: "${page.name} Page deleted successfully");
                                            }else{
                                              AppOverlay.showErrorSnackBar(content: "An Error Occurred, please try again later");
                                            }
                                          });
                                        }
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  if(isForUser)
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
                                  PopupMenuItem(
                                    value: 2,
                                    child: Text(
                                      "Report",
                                      style: AppTextStyle.bodyText1.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if(isForUser)
                                    PopupMenuItem(
                                      value: 3,
                                      child: Text(
                                        "Delete",
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
                            opacity: scrolled ? 1.0 : 0.0,
                            child: Text(
                              '${page.name}',
                              style: AppTextStyle.subtitle1.copyWith(
                                color: const Color(0xff4F4F4F),
                                fontSize: Get.textScaleFactor * 18,
                                fontWeight: FontWeight.bold,
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
                                      Tab(text: "Followers",iconMargin: EdgeInsets.zero,),
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
                    FutureBuilder<ApiResponse>(
                        future: controller.getData("/wayagram-service/all-posts/page-posts?profile_id=${fullProfile.id}&page_id=${page.id}", true),
                        builder: (context, snapshot) {
                          var savedPosts = ReadWriteValue('wayagram_page_${page.id}', '', MyPref.box);
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                            final posts = AllPostsEntity.getService(snapshot.data!.data['data']);
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
                    FutureBuilder<ApiResponse>(
                        future: controller.getData("/wayagram-service/main/page/get-all-page-followers?pageId=${page.id}", true),
                        builder: (context, snapshot) {
                          var savedPosts = ReadWriteValue('wayagram_page_followers_${page.id}', '', MyPref.box);
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                            final posts = GroupMembersModel.listFromJson(snapshot.data!.data);
                            savedPosts.val = jsonEncode(posts);
                            //final posts = snapshot.data!.data as FollowersModelEntity;
                            var names = List<String>.empty(growable: true);
                            var username = List<String>.empty(growable: true);
                            var profile = List<String>.empty(growable: true);
                            var userIds = List<String>.empty(growable: true);
                            var ids = List<String>.empty(growable: true);

                            for (var element in posts) {
                              if(element.profile != null){
                                names.add(element.profile!.displayName.toString());
                                username.add(element.profile!.username.toString());
                                profile.add(element.profile!.avatar.toString());
                                userIds.add(element.profile!.userId.toString());
                                ids.add(element.profile!.id.toString());
                              }
                            }

                            return PersonView(
                              name: names,
                              username: username,
                              profilePic: profile,
                              length: names.length,
                              userIDs: userIds,
                              iDs: ids,
                              showReport: true,
                              onReportClick: (value) {
                                controller.pageToPost = page;
                                controller.groupToPost = null;
                                Get.to(() => ReportUser(
                                  person: value,
                                  page: page,
                                ));
                              },
                            );
                          } else if(savedPosts.val.isNotEmpty){
                            var posts = GroupMembersModel.listFromJson(jsonDecode(savedPosts.val));
                            var names = List<String>.empty(growable: true);
                            var username = List<String>.empty(growable: true);
                            var profile = List<String>.empty(growable: true);
                            var userIds = List<String>.empty(growable: true);
                            var ids = List<String>.empty(growable: true);

                            for (var element in posts) {
                              if(element.profile != null){
                                names.add(element.profile!.displayName.toString());
                                username.add(element.profile!.username.toString());
                                profile.add(element.profile!.avatar.toString());
                                userIds.add(element.profile!.userId.toString());
                                ids.add(element.profile!.id.toString());
                              }
                            }

                            return PersonView(
                              name: names,
                              username: username,
                              profilePic: profile,
                              length: names.length,
                              userIDs: userIds,
                              iDs: ids,
                              showReport: true,
                              onReportClick: (value) {
                                controller.pageToPost = page;
                                controller.groupToPost = null;
                                Get.to(() => ReportUser(
                                  person: value,
                                  page: page,
                                ));
                              },
                            );
                          }else{
                            return const NotificationView(isLoading: true);
                          }
                        }),
                  ],
                ),
              ),
              floatingActionButton: ((isUserAMember) || isForUser) ? FloatingActionButton(
                onPressed: () {
                  controller.isProductPost = false;
                  controller.groupToPost = null;
                  controller.pageToPost = page;
                  controller.imagePaths.clear();
                  //Get.to(() => const CreatePosts());
                  Get.bottomSheet(
                      GroupAndPageBottomSheet(
                        isChat: controller.currentBottomNavPage.value == 4,
                      ),
                      isScrollControlled: true
                  );
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add,color: Colors.white),
              ) : null,
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
