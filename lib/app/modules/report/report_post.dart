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

class ReportPost extends StatefulWidget {
  const ReportPost({Key? key, this.post, this.group, this.page,this.isGroup = false, this.isPage = false,this.isPost = false,this.isProfile = false}) : super(key: key);

  final AllPostsEntity? post;
  final GroupModelEntity? group;
  final GroupModelEntity? page;
  final bool isGroup;
  final bool isPage;
  final bool isPost;
  final bool isProfile;

  @override
  State<ReportPost> createState() => _ReportPostState();
}

class _ReportPostState extends State<ReportPost> {
  String _reason = "Inappropriate Contents";
  var formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var title = "Report Post";
    var subtitle = "Why are you reporting this post?";
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(id: "report_user_post",builder: (controller) {
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
                      if(_reason == "Other"){
                        if(formKey.currentState!.validate()){
                          await Future.delayed(const Duration(seconds: 5));
                          AppOverlay.showSuccessSnackBar(content: "Post Reported Successfully");
                          if(Get.currentRoute == "/ReportPost"){
                            Navigator.pop(context);
                          }
                        }
                      } else{
                        await Future.delayed(const Duration(seconds: 5));
                        AppOverlay.showSuccessSnackBar(content: "Post Reported Successfully");
                        if(Get.currentRoute == "/ReportPost"){
                          Navigator.pop(context);
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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if(widget.isPost)
                        Post(
                          post: widget.post!,
                          fullProfile: fullProfile,
                          homeController: controller,
                          showActions: false,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xffEDEAEA), width: 1),
                          ),
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
                            validator: (value){
                              if(value!.isEmpty){
                                return "Please enter your reason";
                              }
                              return null;
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}