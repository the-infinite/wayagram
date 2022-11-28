import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/app/global_widgets/person_view.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/CommentModel.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/group_model_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/app_input.dart';
import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_input.dart';
import '../home/widgets/posts_view.dart';

class ReportUser extends StatefulWidget {
  const ReportUser({Key? key, required this.person, this.group, this.page,this.isGroup = false, this.isPage = false}) : super(key: key);

  final Person person;
  final GroupModelEntity? group;
  final GroupModelEntity? page;
  final bool isGroup;
  final bool isPage;

  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  String _reason = "Inappropriate Contents";
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var title = widget.isGroup ? "Report Group" : widget.isPage ? "Report Page" : "Report User";
    var subtitle = widget.isGroup ? "Why are you reporting this group?" : widget.isPage ? "Why are you reporting this page?" : "Why are you reporting this profile?";
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(id: "report_profile_page",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              title,
              style: TextStyle(
                color: const Color(0xff4F4F4F),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(FeatherIcons.arrowLeft, color: Colors.black)
            ),
            actions: [
              Center(
                child: SizedBox(
                  child: AppButton(
                    title: 'Submit',
                    onPressed: () async {
                      if(widget.isGroup || widget.isPage){
                        var reason = _reason;
                        if(_reason == "Other"){
                          reason = _controller.text;
                        }
                        if(widget.isGroup){
                          var newBody = {
                            "groupId": widget.group!.id,
                            "reportingUserId": fullProfile.id,
                            "reportedUserId": widget.group!.id,
                            "reportType": "group",
                            "report": _reason
                          };
                          var response = await controller.postData(newBody, "/wayagram-service/main/group/report",updatePages: false);
                          if(response.isSuccessful){
                            if(Get.currentRoute == "/ReportUser"){
                              Get.back();
                            }
                            AppOverlay.showSuccessSnackBar(content: "${widget.group!.name} Group reported successfully");
                          }else{
                            AppOverlay.showErrorSnackBar(content: "An error occurred reporting ${widget.group!.name} group");
                          }
                        }else {
                          var newBody = {
                            "reportingUserId": fullProfile.id,
                            "pageId": widget.page!.id,
                            "reportedUserId": widget.page!.id,
                            "reportType": "page",
                            "report": _reason
                          };
                          var response = await controller.postData(newBody, "/wayagram-service/main/page/page-report",updatePages: false);
                          if(response.isSuccessful){
                            if(Get.currentRoute == "/ReportUser"){
                              Get.back();
                            }
                            AppOverlay.showSuccessSnackBar(content: "${widget.page!.name} Page reported successfully");
                          }else{
                            AppOverlay.showErrorSnackBar(content: "An error occurred reporting ${widget.page!.name} page");
                          }
                        }
                      }else {
                        if(_reason == "Other"){
                          if(_controller.text.isNotEmpty){
                            var body = {
                              "profile_id": fullProfile.id,
                              "reported_id": widget.person.id,
                              "reason": _controller.text,
                            };
                            ApiResponse? response;
                            //print(widget.page!.id);
                            if(widget.group == null && widget.page == null){
                              response = await controller.postData(body, "/wayagram-service/main/profile/report",updatePages: false);
                            }else{
                              if(widget.group != null){
                                var newBody = {
                                  "groupId": widget.group!.id,
                                  "reportingUserId": fullProfile.id,
                                  "reportedUserId": widget.person.id,
                                  "reportType": "member",
                                  "report": _controller.text
                                };
                                response = await controller.postData(newBody, "/wayagram-service/main/group/report",updatePages: false);
                              }else if(widget.page != null){
                                var newBody = {
                                  "reportingUserId": fullProfile.id,
                                  "pageId": widget.page!.id,
                                  "reportedUserId": widget.person.id,
                                  "reportType": "follower",
                                  "report": _controller.text
                                };
                                response = await controller.postData(newBody, "/wayagram-service/main/page/page-report",updatePages: false);
                              }
                            }
                            print(widget.page!.id);
                            if(response!.isSuccessful || response.message == "WAYAGram user reported"){
                              Get.back();
                              if(widget.group != null){
                                AppOverlay.showSuccessSnackBar(content: "User Reported To Group Admin");
                              }else if(widget.page != null){
                                AppOverlay.showSuccessSnackBar(content: "User Reported To Page Admin");
                              }else{
                                AppOverlay.showSuccessSnackBar(content: "Account Reported Successfully");
                              }
                            }else{
                              AppOverlay.showErrorSnackBar(content: "Failed to Report Account, Please try again later");
                            }
                          }
                        }
                        else{
                          var body = {
                            "profile_id": fullProfile.id,
                            "reported_id": widget.person.id,
                            "reason": _reason,
                          };
                          ApiResponse? response;
                          if(widget.group == null && widget.page == null){
                            response = await controller.postData(body, "/wayagram-service/main/profile/report",updatePages: false);
                          }else{
                            if(widget.group != null){
                              var newBody = {
                                "groupId": widget.group!.id,
                                "reportingUserId": fullProfile.id,
                                "reportedUserId": widget.person.id,
                                "reportType": "member",
                                "report": _reason
                              };
                              response = await controller.postData(newBody, "/wayagram-service/main/group/report",updatePages: false);
                            }else if(widget.page != null){
                              var newBody = {
                                "reportingUserId": fullProfile.id,
                                "pageId": widget.page!.id,
                                "reportedUserId": widget.person.id,
                                "reportType": "follower",
                                "report": _reason
                              };
                              response = await controller.postData(newBody, "/wayagram-service/main/page/page-report",updatePages: false);
                            }
                          }
                          if(response!.isSuccessful || response.message == "WAYAGram user reported"){
                            Get.back();
                            if(widget.group != null){
                              AppOverlay.showSuccessSnackBar(content: "User Reported To Group Admin");
                            }else if(widget.page != null){
                              AppOverlay.showSuccessSnackBar(content: "User Reported To Page Admin");
                            }else{
                              AppOverlay.showSuccessSnackBar(content: "Account Reported Successfully");
                            }
                          }else{
                            AppOverlay.showErrorSnackBar(content: "Failed to Report Account, Please try again later");
                          }
                        }
                      }
                    },
                    borderRadius: 10,
                    fontColor: AppColors.button,
                    bckgrndColor: AppColors.background,
                    border: Border.all(color: AppColors.background, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    width: Get.width * 0.2,
                    fontSize: Get.textScaleFactor * 18,
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: const Color(0xffEDEAEA),
                  height: 1.0,
                )),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: Get.width*0.008,right: Get.width*0.008),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            icon: AppAvatar(
                              imgUrl: widget.person.profilePic,
                              radius: 50,
                            ),
                            onPressed: null,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.person.displayName,
                              style: const TextStyle(
                                color: Colors.black ,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: Get.width*0.8,
                              child: Text(
                                "@${widget.person.username}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Get.textScaleFactor * 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    RadioGroup<String>.builder(
                      groupValue: _reason,
                      onChanged: (value) => setState(() {
                        _reason = value.toString();
                      }),
                      items: const ["Inappropriate Contents", "Promoting HateFul Conducts", "Abusive", "Fraud", "Other"],
                      itemBuilder: (item) => RadioButtonBuilder(
                        item,
                      ),
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 10,),
                    if(_reason == "Other")
                      Padding(
                        padding: EdgeInsets.only(left: Get.width*0.02,right: Get.width*0.02),
                        child: AppInput(
                          label: "",
                          controller: _controller,
                          hintText: 'Enter your reason',
                          maxLines: 5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}