import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../profile/profile.dart';

class Settings extends GetView<HomeController>{
  const Settings({Key? key}) : super(key: key);

  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeController>(
      builder: (controller){
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Settings', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
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
              Center(
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
                      imgUrl: (fullProfile.avatar as String?).toString(),
                    ),
                    onPressed: () {
                      Get.toNamed(Profile.route);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${fullProfile.displayName}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Get.width*0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "@${fullProfile.username}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: Get.width*0.035,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: Get.height*0.05),
              _TextButton(
                  text: "Edit Profile",
                  subtitle: "Update your profile",
                  onPressed: (){

                  }
              )
            ],
          ),
        );
      },
    );
  }
}

class _TextButton extends StatelessWidget {
  final String text;
  final String subtitle;
  final Function() onPressed;
  const _TextButton({required this.text, required this.onPressed, required this.subtitle});

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
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width*0.8,
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
                      style: AppTextStyle.subtitle1.copyWith(color: Colors.black,fontSize: Get.width*0.04,fontWeight: FontWeight.w600),
                    ),
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                        Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppTextStyle.subtitle1.copyWith(color: Colors.black),
                    ),
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                      ]
                  ),
                ),
              ),

              IconButton(
                  onPressed: onPressed,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,)
              )
            ],
          ),
        ),
      ),
    );
  }
}

