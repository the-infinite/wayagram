import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../bindings/wayagram_binding.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';
import '../home/widgets/group_view.dart';
import '../search/search.dart';

class GroupsAndPages extends StatefulWidget{
  const GroupsAndPages({Key? key}) : super(key: key);

  static const route = '/groupsAndPages';

  @override
  State<GroupsAndPages> createState() => _GroupsAndPagesState();
}

class _GroupsAndPagesState extends State<GroupsAndPages> with TickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();
    var page = 0;

    var groupsTextController = TextEditingController(text: "0");
    var pagesTextController = TextEditingController(text: "0");

    var personalGroupTextController = TextEditingController(text: "0");
    var personalPagesTextController = TextEditingController(text: "0");

    return  GetBuilder<HomeControllerWayagram>(
      builder: (controller){
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: getAppColor(AppColors.background),
            title: Text('Groups & Pages', style: AppTextStyle.subtitle1.copyWith(
              color: getAppColor(Colors.black),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: getAppColor(Colors.black),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: IconButton(
                    icon: ImageHelper.normalImage(
                      'assets/images/search.png',
                      color: getAppColor(AppColors.onBackground),
                      width: Get.width*0.05,
                      height: Get.width*0.05,
                    ),
                    onPressed: () {
                      var pos = 0;
                      if(tabController.index == 0){
                        pos = 3;
                      }else if(tabController.index == 1){
                        pos = 4;
                      }
                      controller.defaultSearchPos = pos;
                      controller.defaultSearchValue = "";
                      Get.to(() => const Search(),binding: WayagramBinding());
                    },
                    color: getAppColor(AppColors.background),
                  ),
                ),
              )
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: getAppColor(AppColors.background),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                TabBar(
                  controller: tabController,
                  padding: EdgeInsets.zero,
                  labelColor: getAppColor(Colors.black),
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
                    Tab(text: 'Groups',iconMargin: EdgeInsets.zero,),
                    Tab(text: 'Pages',iconMargin: EdgeInsets.zero,),
                  ],
                  onTap: (index) {

                  },
                ),
                const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10
                              ),
                              child: Container(
                                color: getAppColor(Colors.blue.shade50),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'My Created Groups',
                                  style: AppTextStyle.headline4.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            FutureBuilder<ApiResponse>(
                                future: controller.getData("/wayagram-service/main/group/get-all-user-created-groups?pageNumber=1&userId=${fullProfile.id}", true),
                                builder: (context, snapshot) {
                                  //var savedPosts = MyPref.suggestedGroups.val;
                                  var savedPosts = ReadWriteValue('wayagram_created_groups', '', MyPref.box);
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                    final posts = GroupModelEntity.getService(snapshot.data!.groups);
                                    savedPosts.val = jsonEncode(posts);
                                    return GroupView(
                                        posts: posts,
                                        isJoined: true
                                    );
                                  } else if(savedPosts.val.isNotEmpty){
                                    var posts = GroupModelEntity.getService(jsonDecode(savedPosts.val));
                                    return GroupView(posts: posts,isJoined: true);
                                  }else{
                                    return const GroupView(isLoading: true,isJoined: true);
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10
                              ),
                              child: Container(
                                color: getAppColor(Colors.blue.shade50),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Joined Groups',
                                  style: AppTextStyle.headline4.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            FutureBuilder<ApiResponse>(
                                future: controller.getData("/wayagram-service/main/group/get-user-groups?pageNumber=1&userId=${fullProfile.id}", true),
                                builder: (context, snapshot) {
                                  //var savedPosts = MyPref.suggestedGroups.val;
                                  var savedPosts = ReadWriteValue('wayagram_joined_groups', '', MyPref.box);
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data?.isSuccessful == true) {
                                    //final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                    final posts = GroupModelEntity.getService2(snapshot.data!.data);
                                    savedPosts.val = jsonEncode(posts);
                                    return GroupView(
                                        posts: posts,
                                        isJoined: true
                                    );
                                  } else if(savedPosts.val.isNotEmpty){
                                    var posts = GroupModelEntity.getService(jsonDecode(savedPosts.val));
                                    return GroupView(posts: posts,isJoined: true);
                                  }else{
                                    return const GroupView(isLoading: true,isJoined: true);
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10
                              ),
                              child: Container(
                                color: getAppColor(Colors.blue.shade50),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Groups To Join',
                                  style: AppTextStyle.headline4.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            FutureBuilder<ApiResponse>(
                                future: controller.getSuggestedGroups,
                                builder: (context, snapshot) {
                                  var savedPosts = MyPref.suggestedGroups.val;
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                    MyPref.suggestedGroups.val = jsonEncode(posts);
                                    return GroupView(posts: posts,onButtonClick: (group) async {
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
                                        controller.update();
                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                      }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                    },minimum: 5);
                                  } else if(savedPosts.isNotEmpty){
                                    var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                                    return GroupView(posts: posts,onButtonClick: (group) async {
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
                                        controller.update();
                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                      }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                    },minimum: 5,);
                                  }else{
                                    return const GroupView(isLoading: true);
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10
                              ),
                              child: Container(
                                color: getAppColor(Colors.blue.shade50),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'All Groups',
                                  style: AppTextStyle.headline4.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            FutureBuilder<ApiResponse>(
                                future: controller.getData("/wayagram-service/main/group/get-all-groups?pageNumber=1&userId=${fullProfile.id}", true),
                                builder: (context, snapshot) {
                                  var savedPosts = MyPref.groups.val;
                                  var otherSavedPosts = ReadWriteValue('wayagram_created_groups', '', MyPref.box);
                                  var joinedSavedPosts = ReadWriteValue('wayagram_joined_groups', '', MyPref.box);
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    final posts = GroupModelEntity.getService(snapshot.data!.data);
                                    MyPref.groups.val = jsonEncode(posts);
                                    if(otherSavedPosts.val.isNotEmpty){
                                      var otherPosts = GroupModelEntity.getService(jsonDecode(otherSavedPosts.val));
                                      for (var element in otherPosts) {
                                        posts.removeWhere((element2) => element2.id == element.id);
                                      }
                                    }
                                    if(joinedSavedPosts.val.isNotEmpty){
                                      var joinedPosts = GroupModelEntity.getService(jsonDecode(joinedSavedPosts.val));
                                      for (var element in joinedPosts) {
                                        posts.removeWhere((element2) => element2.id == element.id);
                                      }
                                    }
                                    return GroupView(posts: posts,onButtonClick: (group) async {
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
                                        controller.update();
                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                      }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                    });
                                  } else if(savedPosts.isNotEmpty){
                                    var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                                    return GroupView(posts: posts,onButtonClick: (group) async {
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
                                        controller.update();
                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                      }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                    });
                                  }else{
                                    return const GroupView(isLoading: true);
                                  }
                                }),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10
                              ),
                              child: Container(
                                color: getAppColor(Colors.blue.shade50),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'My Pages',
                                  style: AppTextStyle.headline4.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            FutureBuilder<ApiResponse>(
                                future: controller.getPagesFollowed,
                                builder: (context, snapshot) {
                                  var savedPosts = MyPref.pagesFollowed.val;
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    final posts = snapshot.data!.data as List<GroupModelEntity>;
                                    return GroupView(posts: posts,isGroup: false,isJoined: true);
                                  } else if(savedPosts.isNotEmpty){
                                    var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                                    return GroupView(posts: posts,isGroup: false,isJoined: true);
                                  }else{
                                    if(snapshot.connectionState == ConnectionState.done){
                                      return const SizedBox.shrink();
                                    }
                                    return const GroupView(isLoading: true);
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10
                              ),
                              child: Container(
                                color: getAppColor(Colors.blue.shade50),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Pages To Follow',
                                  style: AppTextStyle.headline4.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            FutureBuilder<ApiResponse>(
                                future: controller.getSuggestedPages,
                                builder: (context, snapshot) {
                                  var savedPosts = MyPref.suggestedPages.val;
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    final posts = snapshot.data!.suggestion as List<GroupModelEntity>;
                                    return GroupView(posts: posts,isGroup: false,
                                        onButtonClick: (group) async {
                                      var body = {
                                        "pageId": group.id,
                                        "userId": fullProfile.id,
                                      };
                                      var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                                      if(response.isSuccessful){
                                        await controller.getSuggestedPages;
                                        await controller.getPagesFollowed;
                                        controller.update();
                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                      }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                    },minimum: 5);
                                  } else if(savedPosts.isNotEmpty){
                                    var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                                    return GroupView(posts: posts,isGroup: false,onButtonClick: (group) async {
                                      var body = {
                                        "pageId": group.id,
                                        "userId": fullProfile.id,
                                      };
                                      var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                                      if(response.isSuccessful){
                                        await controller.getSuggestedPages;
                                        await controller.getPagesFollowed;
                                        controller.update();
                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                      }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                    },minimum: 5);
                                  }else{
                                    if(snapshot.connectionState == ConnectionState.done){
                                      return const SizedBox.shrink();
                                    }
                                    return const GroupView(isLoading: true,isGroup: false,);
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 10
                              ),
                              child: Container(
                                color: getAppColor(Colors.blue.shade50),
                                width: Get.width,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'All Pages',
                                  style: AppTextStyle.headline4.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            //https://services.staging.wayagram.ng/wayagram-service/main/page/get-all-pages?pageNumber=1&userId=c6812b92-b6f8-4953-a9f2-45ef15b15ec7&sso_id=313
                            FutureBuilder<ApiResponse>(
                                future: controller.getData("/wayagram-service/main/page/get-all-pages?pageNumber=1&userId=${fullProfile.id}", true),
                                builder: (context, snapshot) {
                                  var savedPosts = MyPref.allPages.val;
                                  var otherSavedPosts = MyPref.pagesFollowed.val;
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    final posts = GroupModelEntity.getService(snapshot.data!.data);
                                    MyPref.allPages.val = jsonEncode(posts);
                                    if(otherSavedPosts.isNotEmpty){
                                      var otherPosts = GroupModelEntity.getService(jsonDecode(otherSavedPosts));
                                      for (var e in otherPosts) {
                                        posts.removeWhere((element) => element.id == e.id);
                                      }
                                    }
                                    return GroupView(posts: posts,isGroup: false,
                                        onButtonClick: (group) async {
                                          var body = {
                                            "pageId": group.id,
                                            "userId": fullProfile.id,
                                          };
                                          var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                                          if(response.isSuccessful){
                                            await controller.getSuggestedPages;
                                            await controller.getPagesFollowed;
                                            controller.update();
                                            Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                          }else{
                                            Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                          }
                                        });
                                  } else if(savedPosts.isNotEmpty){
                                    var posts = GroupModelEntity.getService(jsonDecode(savedPosts));
                                    return GroupView(posts: posts,isGroup: false,onButtonClick: (group) async {
                                      var body = {
                                        "pageId": group.id,
                                        "userId": fullProfile.id,
                                      };
                                      var response = await controller.putData(body, "/wayagram-service/main/page/follow-or-un-follow");
                                      if(response.isSuccessful){
                                        await controller.getSuggestedPages;
                                        await controller.getPagesFollowed;
                                        controller.update();
                                        Get.snackbar("Success", response.message == null ? "Success" : response.message.toString(),backgroundColor: Colors.green, colorText: Colors.white);
                                      }else{
                                        Get.snackbar("Error", response.message == null ? "Something went wrong" : response.message.toString(),backgroundColor: Colors.red, colorText: Colors.white);
                                      }
                                    });
                                  }else{
                                    if(snapshot.connectionState == ConnectionState.done){
                                      return const SizedBox.shrink();
                                    }
                                    return const GroupView(isLoading: true,isGroup: false,);
                                  }
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}

