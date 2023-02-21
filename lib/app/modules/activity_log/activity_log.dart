import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/ActivityLogsModel.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';


import '../../global_widgets/app_refresher.dart';
import '../../global_widgets/overlays.dart';
import '../home/widgets/group_view.dart';
import '../search/search.dart';

class ActivityLog extends StatefulWidget {
  const ActivityLog({Key? key}) : super(key: key);

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<ActivityLogsModel> allPosts = [];
    RefreshController refreshController = RefreshController(initialRefresh: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "activity_log",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var savedPosts = ReadWriteValue('wayagram_activity_logs', '', MyPref.box);
        var currentPage = ReadWriteValue('wayagram_activity_logs_current_page', 1, MyPref.box);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Activity Log",
              style: TextStyle(
                color: getAppColor(const Color(0xff4F4F4F)),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black))
            ),
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 0.5),
                child: const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: getAppColor(AppColors.background),
            child: AppRefresher(
              onRefresh: () async {
                var response = await controller.getData("/wayagram-service/main/get-user-activity-logs?profile_id=${fullProfile.id}&page=${1}&limit=1", true);
                final posts = ActivityLogsModel.fromJsonList(response.data['data']);
                if(posts.isNotEmpty){
                  if(allPosts.isNotEmpty){
                    var firstPost = allPosts.first;
                    var currentFirstPost = posts.first;
                    if(firstPost.id != currentFirstPost.id){
                      var newList = posts + allPosts;
                      allPosts = newList;
                      savedPosts.val = jsonEncode(allPosts);
                    }
                  }else{
                    allPosts = posts;
                  }
                }
                refreshController.refreshCompleted();
                controller.update(["activity_log"]);
              },
              onLoading: () async {
                var response = await controller.getData("/wayagram-service/main/get-user-activity-logs?profile_id=${fullProfile.id}&page=${currentPage.val}&limit=10", true);
                final posts = ActivityLogsModel.fromJsonList(response.data['data']);
                allPosts.addAll(posts);
                savedPosts.val = jsonEncode(allPosts);
                currentPage.val = currentPage.val + 1;
                refreshController.loadComplete();
                controller.update(["activity_log"]);
              },
              controller: refreshController,
              child: SingleChildScrollView(
                child: FutureBuilder<ApiResponse>(
                  ///wayagram-service/main/get-user-activity-logs?profile_id=bc63e326-7619-45da-9aab-0876d5e96956&page=1&limit=40&sso_id=639
                    future: controller.getData("/wayagram-service/main/get-user-activity-logs?profile_id=${fullProfile.id}&page=1&limit=40", true),
                    builder: (context, snapshot) {

                      if(allPosts.isNotEmpty){
                        return ListView.builder(
                          itemCount: allPosts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var post = allPosts[index];
                            return InkWell(
                              onTap: (){

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: Get.height*0.04,
                                      width: Get.height*0.04,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Icon(Icons.access_time_filled_outlined, color: Colors.white, size: Get.height*0.02,),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width*0.7,
                                          child: HashTagText(text: post.activity.toString(), decoratedStyle: TextStyle(
                                            color: Colors.blue,
                                            fontSize: Get.textScaleFactor * 17,
                                            fontWeight: FontWeight.w500,
                                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                            color: getAppColor(Colors.black),
                                            fontSize: Get.textScaleFactor * 17,
                                            fontWeight: FontWeight.w500,),
                                            softWrap: true,
                                            onTap: (text) {
                                            controller.defaultSearchValue = text;
                                            Get.to(() => const Search());
                                            },
                                            decorateAtSign: true,
                                          ),
                                        ),
                                        Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Get.textScaleFactor * 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () {
                                          var body = {
                                            "activity_id": post.id,
                                          };
                                          controller.deleteData(body, "/wayagram-service/main/delete-activity-log?profile_id=${fullProfile.id}", updatePages: false).then((value){
                                            if(value.isSuccessful){
                                              AppOverlay.showSuccessSnackBar(content: "Activity Log Deleted Successfully");
                                              allPosts.removeWhere((element) => element.id == post.id);
                                              controller.update(["activity_log"]);
                                            }else{
                                              AppOverlay.showErrorSnackBar(content: "Failed to Delete Activity Log, Please try again");
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.delete, color: AppColors.primary,)
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                        final posts = ActivityLogsModel.fromJsonList(snapshot.data!.data['data']);
                        if(posts.isEmpty){
                          return SizedBox(
                            width: Get.width,
                            height: Get.height,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: Get.height*0.2,),
                                  Icon(Icons.access_time_filled_outlined, color: AppColors.primary, size: Get.height*0.1,),
                                  const SizedBox(height: 20,),
                                  Text("No Activity Yet", style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Get.textScaleFactor * 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                ],
                              ),
                            ),
                          );
                        }
                        savedPosts.val = jsonEncode(posts);
                        allPosts.addAll(posts);
                        currentPage.val = 2;
                        return ListView.builder(
                          itemCount: allPosts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var post = allPosts[index];
                            return InkWell(
                              onTap: (){

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: Get.height*0.04,
                                      width: Get.height*0.04,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Icon(Icons.access_time_filled_outlined, color: Colors.white, size: Get.height*0.02,),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width*0.7,
                                          child: HashTagText(text: post.activity.toString(), decoratedStyle: TextStyle(
                                            color: Colors.blue,
                                            fontSize: Get.textScaleFactor * 17,
                                            fontWeight: FontWeight.w500,
                                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                            color: getAppColor(Colors.black),
                                            fontSize: Get.textScaleFactor * 17,
                                            fontWeight: FontWeight.w500,),
                                            softWrap: true,
                                            onTap: (text) {
                                              controller.defaultSearchValue = text;
                                              Get.to(() => const Search());
                                            },
                                            decorateAtSign: true,
                                          ),
                                        ),
                                        Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Get.textScaleFactor * 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () {
                                          var body = {
                                            "activity_id": post.id,
                                          };
                                          controller.deleteData(body, "/wayagram-service/main/delete-activity-log?profile_id=${fullProfile.id}", updatePages: false).then((value){
                                            if(value.isSuccessful){
                                              AppOverlay.showSuccessSnackBar(content: "Activity Log Deleted Successfully");
                                              allPosts.removeWhere((element) => element.id == post.id);
                                              controller.update(["activity_log"]);
                                            }else{
                                              AppOverlay.showErrorSnackBar(content: "Failed to Delete Activity Log, Please try again");
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.delete, color: AppColors.primary,)
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if(savedPosts.val.isNotEmpty){
                        var posts = ActivityLogsModel.fromJsonList(jsonDecode(savedPosts.val));
                        if(posts.isEmpty){
                          return SizedBox(
                            width: Get.width,
                            height: Get.height,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: Get.height*0.2,),
                                  Icon(Icons.access_time_filled_outlined, color: AppColors.primary, size: Get.height*0.1,),
                                  const SizedBox(height: 20,),
                                  Text("No Activity Yet", style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Get.textScaleFactor * 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var post = posts[index];
                            return InkWell(
                              onTap: (){

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Get.width*0.025, vertical: Get.height*0.01),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: Get.height*0.04,
                                      width: Get.height*0.04,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Icon(Icons.access_time_filled_outlined, color: Colors.white, size: Get.height*0.02,),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width*0.7,
                                          child: HashTagText(text: post.activity.toString(), decoratedStyle: TextStyle(
                                            color: Colors.blue,
                                            fontSize: Get.textScaleFactor * 17,
                                            fontWeight: FontWeight.w500,
                                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                            color: getAppColor(Colors.black),
                                            fontSize: Get.textScaleFactor * 17,
                                            fontWeight: FontWeight.w500,),
                                            softWrap: true,
                                            onTap: (text) {
                                              controller.defaultSearchValue = text;
                                              Get.to(() => const Search());
                                            },
                                            decorateAtSign: true,
                                          ),
                                        ),
                                        Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Get.textScaleFactor * 15,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () {
                                          var body = {
                                            "activity_id": post.id,
                                          };
                                          controller.deleteData(body, "/wayagram-service/main/delete-activity-log?profile_id=${fullProfile.id}", updatePages: false).then((value){
                                            if(value.isSuccessful){
                                              AppOverlay.showSuccessSnackBar(content: "Activity Log Deleted Successfully");
                                              allPosts.removeWhere((element) => element.id == post.id);
                                              controller.update(["activity_log"]);
                                            }else{
                                              AppOverlay.showErrorSnackBar(content: "Failed to Delete Activity Log, Please try again");
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.delete, color: AppColors.primary,)
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }else{
                        if(snapshot.connectionState == ConnectionState.done){
                          return SizedBox(
                            width: Get.width,
                            height: Get.height,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(height: Get.height*0.2,),
                                  Icon(Icons.access_time_filled_outlined, color: AppColors.primary, size: Get.height*0.1,),
                                  const SizedBox(height: 20,),
                                  Text("No Activity Yet", style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Get.textScaleFactor * 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                ],
                              ),
                            ),
                          );
                        }
                        return const GroupView(isLoading: true);
                      }
                    }),
              ),
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
  }
}