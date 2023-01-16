import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/ActivityLogsModel.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/current_location_model.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/last_login_response.dart';
import '../../../data/model/login_history.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/app_refresher.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/overlays.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/group_view.dart';
import '../../home/widgets/notification_view.dart';
import '../../search/search.dart';
import 'package:http/http.dart' as http;

class LoginInformation extends StatefulWidget {
  LoginInformation({Key? key}) : super(key: key);

  @override
  State<LoginInformation> createState() => _LoginInformationState();
}

class _LoginInformationState extends State<LoginInformation> {
  var controller = Get.find<HomeControllerWayagram>();
  String location = 'Unknown';
  String backupLocation = 'Unknown';
  String device = 'Unknown';
  String time = 'Unknown';

  List<LogInHistory> allPosts = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    var savedLoginTime = ReadWriteValue('wayagram_login_information_last_login', '', MyPref.box);
    var savedCustomLocationInfo = ReadWriteValue('wayagram_saved_custom_location_info', '', MyPref.box);
    if(savedLoginTime.val.isNotEmpty){
      LastLoginResponse lastLoginResponse = LastLoginResponse.fromJson(jsonDecode(savedLoginTime.val));
      location = "${lastLoginResponse.city}, ${lastLoginResponse.country}";
      backupLocation = "${lastLoginResponse.city}, ${lastLoginResponse.country}";
      device = lastLoginResponse.device.toString();
      if(lastLoginResponse.loginDate != null){
        time = "${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(lastLoginResponse.loginDate!.toInt()))} at ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(lastLoginResponse.loginDate!.toInt()))}";
      }
    }

    if(savedCustomLocationInfo.val.isNotEmpty){
      CurrentLocationModel currentLocationModel = CurrentLocationModel.fromJson(json.decode(savedCustomLocationInfo.val));
      if(currentLocationModel.regionName == currentLocationModel.city){
        location = "${currentLocationModel.regionName}, ${currentLocationModel.country}";
      }else{
        location = "${currentLocationModel.city}, ${currentLocationModel.regionName}, ${currentLocationModel.country}";
      }
    }

    controller.getData("/auth-service/api/v1/history/my-last-login", false).then((value){
      if(value.isSuccessful){
        LastLoginResponse lastLoginResponse = LastLoginResponse.fromJson(value.data);
        savedLoginTime.val = jsonEncode(value.data);
        backupLocation = "${lastLoginResponse.city}, ${lastLoginResponse.country}";
        device = lastLoginResponse.device.toString();
        if(lastLoginResponse.loginDate != null){
          time = "${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(lastLoginResponse.loginDate!.toInt()))} at ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(lastLoginResponse.loginDate!.toInt()))}";
        }
        controller.update();
      }else{

      }
    });

    try {
      http.get(Uri.parse('http://ip-api.com/json')).then((value) {
        savedCustomLocationInfo.val = value.body;
        CurrentLocationModel currentLocationModel = CurrentLocationModel.fromJson(json.decode(value.body));
        if(currentLocationModel.regionName == currentLocationModel.city){
          location = "${currentLocationModel.regionName}, ${currentLocationModel.country}";
        }else{
          location = "${currentLocationModel.city}, ${currentLocationModel.regionName}, ${currentLocationModel.country}";
        }
        controller.update();
      });
    } catch (err) {
      if(savedCustomLocationInfo.val.isNotEmpty){
        CurrentLocationModel currentLocationModel = CurrentLocationModel.fromJson(json.decode(savedCustomLocationInfo.val));
        if(currentLocationModel.regionName == currentLocationModel.city){
          location = "${currentLocationModel.regionName}, ${currentLocationModel.country}";
        }else{
          location = "${currentLocationModel.city}, ${currentLocationModel.regionName}, ${currentLocationModel.country}";
        }
        controller.update();
      }else{
        location = backupLocation;
        controller.update();
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var savedPosts = ReadWriteValue('wayagram_login_history', '', MyPref.box);
        return Scaffold(
          appBar: AppBar(
              backgroundColor: getAppColor(AppColors.background),
              title: Text('Login Information', style: AppTextStyle.subtitle1.copyWith(
                color: getAppColor(Color(0xff4F4F4F)),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              )),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black)),
                onPressed: () => Navigator.pop(context),
              ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Location",
                    subtitle: location,
                    onPressed: (){
                      controller.imagePaths.clear();
                    }
                ),
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Device",
                    subtitle: Platform.isAndroid ? "Android" : "iOS",
                    onPressed: (){
                      controller.imagePaths.clear();
                    }
                ),
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Time",
                    subtitle: time,
                    onPressed: (){
                      controller.imagePaths.clear();
                    }
                ),
                SizedBox(height: Get.height*0.02),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: Get.width*0.025,right: Get.width*0.025,bottom: Get.height*0.02),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: getAppColor(Colors.grey).withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        border: Border.all(color: getAppColor(Colors.white), width: 1),
                        color: getAppColor(Colors.white),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height*0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.025),
                            child: Text(
                              "Time Log",
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: AppTextStyle.subtitle1.copyWith(color: getAppColor(Colors.black),fontSize: Get.width*0.04,fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: Get.height*0.01,
                          ),
                          Expanded(
                            child: AppRefresher(
                              onRefresh: () async {
                                var response = await controller.getData("/auth-service/api/v1/history/my-history", false);
                                final posts = LogInHistory.fromJsonList(response.data);
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
                                controller.update();
                              },
                              onLoading: () async {

                              },
                              enablePullUp: false,
                              controller: refreshController,
                              child: SingleChildScrollView(
                                child: FutureBuilder<ApiResponse>(
                                    future: controller.getData("/auth-service/api/v1/history/my-history", false),
                                    builder: (context, snapshot){
                                      if(allPosts.isNotEmpty){
                                        return ListView.builder(
                                          itemCount: allPosts.length,
                                          shrinkWrap: true,
                                          reverse: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var post = allPosts[index];
                                            String title = "Logged In";
                                            String time = "${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(post.loginDate!.toInt()))} at ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(post.loginDate!.toInt()))}";
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
                                                    SizedBox(width: 10,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: Get.width*0.7,
                                                          child: HashTagText(text: title, decoratedStyle: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: Get.textScaleFactor * 17,
                                                            fontWeight: FontWeight.w500,
                                                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                            color: getAppColor(Colors.black),
                                                            fontSize: Get.textScaleFactor * 17,
                                                            fontWeight: FontWeight.w500,),
                                                            softWrap: true,
                                                            onTap: (text) {
                                                              //controller.defaultSearchValue = text;
                                                              //Get.to(() => Search());
                                                            },
                                                            decorateAtSign: true,
                                                          ),
                                                        ),
                                                        Text(time, style: TextStyle(
                                                          color: getAppColor(Colors.grey),
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
                                        final posts = LogInHistory.fromJsonList(snapshot.data!.data);
                                        savedPosts.val = jsonEncode(posts);
                                        allPosts.addAll(posts);
                                        if(posts.isEmpty){
                                          return SizedBox(
                                            width: Get.width,
                                            height: Get.height * 0.5,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: Get.height*0.2,),
                                                  Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: Get.height*0.1,),
                                                  SizedBox(height: 20,),
                                                  Text("Nothing Here Yet", style: TextStyle(
                                                    color: getAppColor(Colors.grey),
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
                                          reverse: true,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var post = posts[index];
                                            String title = "Logged In";
                                            String time = "${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(post.loginDate!.toInt()))} at ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(post.loginDate!.toInt()))}";
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
                                                    SizedBox(width: 10,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: Get.width*0.7,
                                                          child: HashTagText(text: title, decoratedStyle: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: Get.textScaleFactor * 17,
                                                            fontWeight: FontWeight.w500,
                                                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                            color: getAppColor(Colors.black),
                                                            fontSize: Get.textScaleFactor * 17,
                                                            fontWeight: FontWeight.w500,),
                                                            softWrap: true,
                                                            onTap: (text) {
                                                              //controller.defaultSearchValue = text;
                                                              //Get.to(() => Search());
                                                            },
                                                            decorateAtSign: true,
                                                          ),
                                                        ),
                                                        Text(time, style: TextStyle(
                                                          color: getAppColor(Colors.grey),
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
                                        final posts = LogInHistory.fromJsonList(jsonDecode(savedPosts.val));
                                        if(posts.isEmpty){
                                          return SizedBox(
                                            width: Get.width,
                                            height: Get.height * 0.5,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: Get.height*0.2,),
                                                  Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: Get.height*0.1,),
                                                  SizedBox(height: 20,),
                                                  Text("Nothing Here Yet", style: TextStyle(
                                                    color: getAppColor(Colors.grey),
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
                                          reverse: true,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var post = posts[index];
                                            String title = "Logged In";
                                            String time = "${DateFormat.yMMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch(post.loginDate!.toInt()))} at ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(post.loginDate!.toInt()))}";
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
                                                    SizedBox(width: 10,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: Get.width*0.7,
                                                          child: HashTagText(text: title, decoratedStyle: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: Get.textScaleFactor * 17,
                                                            fontWeight: FontWeight.w500,
                                                          ),basicStyle: AppTextStyle.bodyText1.copyWith(
                                                            color: getAppColor(Colors.black),
                                                            fontSize: Get.textScaleFactor * 17,
                                                            fontWeight: FontWeight.w500,),
                                                            softWrap: true,
                                                            onTap: (text) {
                                                              //controller.defaultSearchValue = text;
                                                              //Get.to(() => Search());
                                                            },
                                                            decorateAtSign: true,
                                                          ),
                                                        ),
                                                        Text(time, style: TextStyle(
                                                          color: getAppColor(Colors.grey),
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
                                            height: Get.height * 0.5,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: Get.height*0.2,),
                                                  Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: Get.height*0.1,),
                                                  SizedBox(height: 20,),
                                                  Text("Nothing Here Yet", style: TextStyle(
                                                    color: getAppColor(Colors.grey),
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
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String text;
  final String subtitle;
  final Function() onPressed;
  _TextButton({required this.text, required this.onPressed, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(left: Get.width*0.025,right: Get.width*0.025),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: getAppColor(Colors.grey).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(color: getAppColor(Colors.white), width: 1),
            color: getAppColor(Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width*0.9,
                child: Padding(
                  padding: EdgeInsets.only(left: Get.width*0.025),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                        Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: AppTextStyle.subtitle1.copyWith(color: getAppColor(Colors.black),fontSize: Get.width*0.04,fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: AppTextStyle.subtitle1.copyWith(color: getAppColor(Colors.black)),
                        ),
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}