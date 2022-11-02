import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

class CreatePosts extends StatelessWidget {
  const CreatePosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title: Text('Create Post', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Center(
                child: SizedBox(
                  child: AppButton(
                    title: 'Create',
                    onPressed: () {

                    },
                    borderRadius: 10,
                    fontColor: AppColors.primary,
                    bckgrndColor: AppColors.background,
                    border: Border.all(color: AppColors.background, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  ),
                ),
              )
            ],
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
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width*0.15,
                    height: Get.width*0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: AppAvatar(
                        imgUrl: (fullProfile.avatar as String?).toString(),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width*0.75,
                    height: double.infinity,
                    child: HashTagTextField(
                      decoratedStyle: AppTextStyle.subtitle1.copyWith(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                      basicStyle: AppTextStyle.subtitle1.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      decoration: InputDecoration(
                        hintText: 'Create New Post',
                        hintStyle: AppTextStyle.subtitle1.copyWith(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              SizedBox(
                height: Get.height*0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width*0.025,
                        ),
                        IconButton(
                          icon: const Icon(Icons.image, color: Colors.black),
                          onPressed: () {

                          },
                        ),
                        SizedBox(
                          width: Get.width*0.025,
                        ),
                        IconButton(
                          icon: const Icon(Icons.video_camera_back_rounded, color: Colors.black),
                          onPressed: () {

                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: Get.width*0.025),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_rounded, color: Colors.black),
                        onPressed: () {

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}