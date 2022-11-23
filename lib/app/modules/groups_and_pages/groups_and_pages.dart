import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../data/model/blocked_accounts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/notification_view.dart';
import '../profile/profile.dart';
import '../profile/update_profile.dart';

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

    return  GetBuilder<HomeController>(
      builder: (controller){
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Groups & Pages', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Column(
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
                              color: Colors.blue.shade50,
                              width: Get.width,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'My Groups',
                                style: AppTextStyle.headline4.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          FutureBuilder<ApiResponse>(
                            //https://services.wayagram.ng/wayagram-service/main/page/get-all-user-pages?userId=4cf05f02-f5f6-42d9-84e4-4ab7a234fbbd
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
                              color: Colors.blue.shade50,
                              width: Get.width,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Groups To Join',
                                style: AppTextStyle.headline4.copyWith(
                                  color: Colors.black,
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
                              color: Colors.blue.shade50,
                              width: Get.width,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'My Pages',
                                style: AppTextStyle.headline4.copyWith(
                                  color: Colors.black,
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
                              color: Colors.blue.shade50,
                              width: Get.width,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Pages To Follow',
                                style: AppTextStyle.headline4.copyWith(
                                  color: Colors.black,
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

