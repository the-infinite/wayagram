import 'dart:convert';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/app/controllers/home_controller.dart';
import 'package:wayagram/app/global_widgets/app_button.dart';
import 'package:wayagram/app/modules/home/home.dart';
import 'package:wayagram/app/modules/settings/inner_pages/notifications.dart';
import 'package:wayagram/app/modules/settings/inner_pages/payment_settings.dart';
import 'package:wayagram/app/modules/settings/inner_pages/privacy.dart';
import 'package:wayagram/app/modules/settings/inner_pages/security.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../core/theme/app_styles.dart';
import '../../controllers/auth_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../profile/profile.dart';
import '../profile/update_profile.dart';

class Support extends GetView<HomeControllerWayagram>{
  const Support({Key? key}) : super(key: key);

  static const route = '/support';

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeControllerWayagram>(
      id: 'support',
      builder: (controller){
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: getAppColor(AppColors.background),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
            title: Text('Support', style: AppTextStyle.subtitle1.copyWith(
              color:getAppColor(Color(0xff4F4F4F)),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: getAppColor(Colors.black),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 0.5),
                child: const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                )),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: getAppColor(AppColors.background),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.02),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _TextButton(
                            leading: Icon(Icons.messenger_rounded, color: getAppColor(Colors.black).withOpacity(0.5)),
                            text: "Send us a message",
                            subtitle: "Talk to a customer service representative",
                            onPressed: () async {
                              const url = "https://wa.me/2348066252349?text=Hi, I'm a Wayagram user and i have a complaint";
                              var encoded = Uri.encodeFull(url);
                              Uri uri = Uri.parse(url);
                              controller.launchURL(encoded);
                            }
                        ),
                        SizedBox(height: Get.height*0.02),
                        _TextButton(
                            leading: Icon(Icons.call_rounded, color: getAppColor(Colors.black).withOpacity(0.5)),
                            text: "Make a phone call",
                            subtitle: "Call customer service directly",
                            onPressed: () async {
                              var phone = "tel:+2348066252349";
                              Uri uri = Uri.parse(phone);
                              if(await canLaunchUrl(uri)){
                              launchUrl(uri);
                              }
                            }
                        ),
                        SizedBox(height: Get.height*0.02),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TextButton extends StatelessWidget {
  final Widget leading;
  final String text;
  final String subtitle;
  final Function() onPressed;
  const _TextButton({required this.text, required this.onPressed, required this.subtitle,required this.leading});

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
            border: Border.all(color: getAppColor(Colors.white), width: 1),
            color: getAppColor(Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: Get.width*0.02),
              leading,
              SizedBox(
                width: Get.width*0.7,
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

              IconButton(
                  onPressed: onPressed,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_forward_ios_rounded, color: getAppColor(Colors.black), size: Get.width*0.04,)
              )
            ],
          ),
        ),
      ),
    );
  }
}

