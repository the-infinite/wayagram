import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/app/modules/settings/inner_pages/notifications.dart';
import 'package:wayagram/app/modules/settings/inner_pages/payment_settings.dart';
import 'package:wayagram/app/modules/settings/inner_pages/privacy.dart';
import 'package:wayagram/app/modules/settings/inner_pages/security.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../profile/profile.dart';
import '../profile/update_profile.dart';
import 'inner_pages/login_information.dart';

class Settings extends GetView<HomeController>{
  const Settings({Key? key}) : super(key: key);

  static const route = '/settings';

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeController>(
      id: 'settings',
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
              const SizedBox(height: 10),
              Text(
                "Your Referral Code:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Get.width*0.035,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: Get.width*0.5,
                child: AppButton(
                  title: controller.logInDetails.user!.referenceCode.toString(),
                  onPressed: () {

                  },
                  borderRadius: 10,
                  fontColor: Colors.blue,
                  bckgrndColor: AppColors.background,
                  border: Border.all(color: AppColors.background, width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: Get.width*0.4,
                child: AppButton(
                  title: 'Wallet Balance',
                  onPressed: () {

                  },
                  borderRadius: 10,
                  fontColor: Colors.white,
                  bckgrndColor: AppColors.primary,
                  border: Border.all(color: AppColors.primary, width: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              SizedBox(height: Get.height*0.05),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _TextButton(
                          text: "Edit Profile",
                          subtitle: "Update your profile",
                          onPressed: (){
                            controller.imagePaths.clear();
                            Get.toNamed(UpdateProfile.route);
                          }
                      ),
                      SizedBox(height: Get.height*0.02),
                      _TextButton(
                          text: "Notifications",
                          subtitle: "Manage your notifications",
                          onPressed: (){
                            Get.to(() => const NotificationsSettings());
                          }
                      ),
                      SizedBox(height: Get.height*0.02),
                      _TextButton(
                          text: "Security",
                          subtitle: "Manage your security settings",
                          onPressed: (){
                            Get.to(() => const SecuritySettings());
                          }
                      ),
                      SizedBox(height: Get.height*0.02),
                      _TextButton(
                          text: "Payment Settings",
                          subtitle: "Manage your payments settings",
                          onPressed: (){
                            Get.to(() => const PaymentSettings());
                          }
                      ),
                      SizedBox(height: Get.height*0.02),
                      _TextButton(
                          text: "Privacy Settings",
                          subtitle: "Manage your privacy settings",
                          onPressed: (){
                            Get.to(() => const PrivacySettings());
                          }
                      ),
                      SizedBox(height: Get.height*0.02),
                      _TextButton(
                          text: "Login Information",
                          subtitle: "Location, device, time Of login",
                          onPressed: (){
                            Get.to(() => const LoginInformation());
                          }
                      ),
                    ],
                  ),
                ),
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

