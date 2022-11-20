import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/all_posts_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
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

class ViewPost extends StatelessWidget {
  const ViewPost({Key? key,required this.post}) : super(key: key);

  final AllPostsEntity post;
  @override
  Widget build(BuildContext context) {
    final ImagePicker _imagePicker = ImagePicker();
    var commentController = TextEditingController();
    List<String> images = [];
    var postID = "";

    /*images.removeAt(index);
     controller.update();*/
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              "Post",
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
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.008, vertical: Get.height*0.005),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Post(
                    post: post,
                    fullProfile: fullProfile,
                    homeController: controller,
                    //hasBorder: false,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: const Color(0xffEDEAEA),
                  height: 1.0,
                ),
                SizedBox(height: Get.height*0.008),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Get.width*0.02),
                      child: SizedBox(
                        width: Get.width * 0.8,
                        child: AppInput(
                          hintText: 'Write a message...',
                          controller: commentController,
                          borderRadius: 100,
                          filledColor: Colors.grey.shade300,
                          borderSide: BorderSide.none,
                          hintColor: Colors.grey.shade500,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    AppButton(
                      title: 'Send',
                      onPressed: () async {

                      },
                      borderRadius: 10,
                      fontColor: AppColors.button,
                      bckgrndColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      width: Get.width * 0.15,
                      fontSize: Get.textScaleFactor * 18,
                    )
                  ],
                ),
                SizedBox(height: Get.height*0.008)
              ],
            ),
          ),
          resizeToAvoidBottomInset: true,
        );
      }),
    );
  }
}