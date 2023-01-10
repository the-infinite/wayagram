import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/ActivityLogsModel.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/InterestsModel.dart';
import '../../data/model/NewInterestModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/promotion_analytics_model.dart';
import '../../data/model/promotion_list_model.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/app_input.dart';
import '../../global_widgets/app_refresher.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/group_view.dart';
import '../home/widgets/posts_view.dart';
import '../search/search.dart';

class PromotionAnalytics extends StatefulWidget {
  PromotionAnalytics({Key? key}) : super(key: key);

  @override
  State<PromotionAnalytics> createState() => _PromotionAnalyticsState();
}

class _PromotionAnalyticsState extends State<PromotionAnalytics> with TickerProviderStateMixin {
  late TabController tabController;
  var controller = Get.find<HomeControllerWayagram>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<PromotionListModel> allPosts = [];
    String created = "0";
    String ended = "0";
    String live = "0";
    String spent = "0";
    RefreshController refreshController = RefreshController(initialRefresh: false);
    var savedAnalytics = ReadWriteValue('wayagram_post_promotion_overview', '', MyPref.box);
    if(savedAnalytics.val.isNotEmpty){
      PromotionAnalyticsModel model = PromotionAnalyticsModel.fromJson(jsonDecode(savedAnalytics.val));
      savedAnalytics.val = jsonEncode(model);
      created = model.totalPromotionCount.toString();
      ended = model.totalPromotionEnded.toString();
      live = model.totalPromotionLive.toString();
      if(model.totalAmountSpent != null){
        spent = model.totalAmountSpent!.sumTotal.toString();
      }
    }
    controller.getData("wayagram-service/all-posts/get-promotion-stats", true).then((value){
      if(value.isSuccessful){
        PromotionAnalyticsModel model = PromotionAnalyticsModel.fromJson(value.data);
        savedAnalytics.val = jsonEncode(model);
        created = model.totalPromotionCount.toString();
        ended = model.totalPromotionEnded.toString();
        live = model.totalPromotionLive.toString();
        if(model.totalAmountSpent != null){
          spent = model.totalAmountSpent!.sumTotal.toString();
        }
        controller.update(["promotion_analytics_log"]);
      }else{
        if(savedAnalytics.val.isNotEmpty){
          PromotionAnalyticsModel model = PromotionAnalyticsModel.fromJson(jsonDecode(savedAnalytics.val));
          savedAnalytics.val = jsonEncode(model);
          created = model.totalPromotionCount.toString();
          ended = model.totalPromotionEnded.toString();
          live = model.totalPromotionLive.toString();
          if(model.totalAmountSpent != null){
            spent = model.totalAmountSpent!.sumTotal.toString();
          }
          controller.update(["promotion_analytics_log"]);
        }
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
      child: GetBuilder<HomeControllerWayagram>(id: "promotion_analytics_log",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var savedPosts = ReadWriteValue('wayagram_promotion_analytics_log', '', MyPref.box);
        var currentPage = ReadWriteValue('wayagram_promotion_analytics_log_current_page', 1, MyPref.box);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text(
              "Post Promotion Analytics",
              style: TextStyle(
                color: getAppColor(Color(0xff4F4F4F)),
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
                child: Divider(
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
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.22,
                      decoration: BoxDecoration(
                        color: getAppColor(AppColors.background),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Created",
                            style: TextStyle(
                              color: getAppColor(Color(0xff4F4F4F)),
                              fontSize: Get.textScaleFactor * 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            created,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.22,
                      decoration: BoxDecoration(
                        color: getAppColor(AppColors.background),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ended",
                            style: TextStyle(
                              color: getAppColor(Color(0xff4F4F4F)),
                              fontSize: Get.textScaleFactor * 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ended,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.22,
                      decoration: BoxDecoration(
                        color: getAppColor(AppColors.background),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Live",
                            style: TextStyle(
                              color: getAppColor(Color(0xff4F4F4F)),
                              fontSize: Get.textScaleFactor * 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            live,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Get.height * 0.06,
                      width: Get.width * 0.22,
                      decoration: BoxDecoration(
                        color: getAppColor(AppColors.background),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Spent(NGN)",
                            style: TextStyle(
                              color: getAppColor(Color(0xff4F4F4F)),
                              fontSize: Get.textScaleFactor * 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            shortenCount(spent),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: Get.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: AppRefresher(
                    onRefresh: () async {
                      //https://services.staging.wayagram.ng/wayagram-service/all-posts/get-user-promotions?page=1&limit=20?&sso_id=121
                      var response = await controller.getData("/wayagram-service/all-posts/get-user-promotions?page=${1}&limit=1", true);
                      if(response.isSuccessful){
                        final posts = PromotionListModel.fromJsonList(response.data['data']);
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
                        controller.update(["promotion_analytics_log"]);
                      }
                    },
                    onLoading: () async {
                      var response = await controller.getData("/wayagram-service/all-posts/get-user-promotions?page=${currentPage.val}&limit=10", true);
                      if(response.isSuccessful){
                        final posts = PromotionListModel.fromJsonList(response.data['data']);
                        allPosts.addAll(posts);
                        savedPosts.val = jsonEncode(allPosts);
                        currentPage.val = currentPage.val + 1;
                        refreshController.loadComplete();
                        controller.update(["promotion_analytics_log"]);
                      }
                    },
                    controller: refreshController,
                    child: SingleChildScrollView(
                      child: FutureBuilder<ApiResponse>(
                          future: controller.getData("/wayagram-service/all-posts/get-user-promotions?page=1&limit=40", true),
                          builder: (context, snapshot) {
                            if(allPosts.isNotEmpty){
                              return ListView.builder(
                                itemCount: allPosts.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
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
                                            child: Icon(Icons.analytics_rounded, color: Colors.white, size: Get.height*0.02,),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: Get.width*0.7,
                                                child: HashTagText(text: post.description.toString(), decoratedStyle: TextStyle(
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
                                                    Get.to(() => Search());
                                                  },
                                                  decorateAtSign: true,
                                                ),
                                              ),
                                              Text("NGN ${post.userBudget}", style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: Get.textScaleFactor * 15,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                              Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Get.textScaleFactor * 15,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                              final posts = PromotionListModel.fromJsonList(snapshot.data!.data['data']);
                              savedPosts.val = jsonEncode(posts);
                              allPosts.addAll(posts);
                              currentPage.val = 2;
                              if(posts.isEmpty){
                                return SizedBox(
                                  width: Get.width,
                                  height: Get.height,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: Get.height*0.2,),
                                        Icon(Icons.analytics_rounded, color: AppColors.primary, size: Get.height*0.1,),
                                        SizedBox(height: 20,),
                                        Text("No Promoted Posts Yet", style: TextStyle(
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
                                itemCount: allPosts.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
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
                                            child: Icon(Icons.analytics_rounded, color: Colors.white, size: Get.height*0.02,),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: Get.width*0.7,
                                                child: HashTagText(text: post.description.toString(), decoratedStyle: TextStyle(
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
                                                    Get.to(() => Search());
                                                  },
                                                  decorateAtSign: true,
                                                ),
                                              ),
                                              Text("NGN ${post.userBudget}", style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: Get.textScaleFactor * 15,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                              Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Get.textScaleFactor * 15,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if(savedPosts.val.isNotEmpty){
                              var posts = PromotionListModel.fromJsonList(jsonDecode(savedPosts.val));
                              if(posts.isEmpty){
                                return SizedBox(
                                  width: Get.width,
                                  height: Get.height,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: Get.height*0.2,),
                                        Icon(Icons.analytics_rounded, color: AppColors.primary, size: Get.height*0.1,),
                                        SizedBox(height: 20,),
                                        Text("No Promoted Posts Yet", style: TextStyle(
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
                                physics: NeverScrollableScrollPhysics(),
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
                                            child: Icon(Icons.analytics_rounded, color: Colors.white, size: Get.height*0.02,),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: Get.width*0.7,
                                                child: HashTagText(text: post.description.toString(), decoratedStyle: TextStyle(
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
                                                    Get.to(() => Search());
                                                  },
                                                  decorateAtSign: true,
                                                ),
                                              ),
                                              Text("NGN ${post.userBudget}", style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: Get.textScaleFactor * 15,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                              Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post.createdAt.toString())), style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: Get.textScaleFactor * 15,
                                                fontWeight: FontWeight.w500,
                                              ),),
                                            ],
                                          ),
                                          Spacer(),
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
                                        Icon(Icons.analytics_rounded, color: AppColors.primary, size: Get.height*0.1,),
                                        SizedBox(height: 20,),
                                        Text("No Promoted Posts Yet", style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Get.textScaleFactor * 17,
                                          fontWeight: FontWeight.w500,
                                        ),),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return GroupView(isLoading: true);
                            }
                          }),
                    ),
                  ),
                ),
              ],
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

String shortenCount(String amount){
  if(amount == "null" || amount.isEmpty){
    return "0";
  }
  if(amount.length > 6){
    return "${amount.substring(0, amount.length-6)}M";
  }
  if(amount.length > 3) {
    var first = amount.substring(0, amount.length - 3);
    var last = amount.substring(amount.length - 1, amount.length);
    return "$first.$last K";
  }
  return amount;
}