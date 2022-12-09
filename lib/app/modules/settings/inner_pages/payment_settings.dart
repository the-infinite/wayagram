import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_avatar.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/notification_view.dart';

class PaymentSettings extends StatelessWidget {
  const PaymentSettings({Key? key}) : super(key: key);

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
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.background,
              title: Text('Payment Settings', style: AppTextStyle.subtitle1.copyWith(
                color: const Color(0xff4F4F4F),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              )),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(FeatherIcons.arrowLeft, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: AppColors.background,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.dark,
                  systemNavigationBarColor: AppColors.background,
                  systemNavigationBarIconBrightness: Brightness.dark
              ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
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

                      },
                    ),
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
                    title: MyPref.referenceCode.val,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: MyPref.referenceCode.val)).then((_){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Referral copied to clipboard",),backgroundColor: AppColors.primary));
                      });
                    },
                    borderRadius: 10,
                    fontColor: Colors.blue,
                    fontSize: Get.width*0.04,
                    bckgrndColor: AppColors.background,
                    border: Border.all(color: AppColors.background, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(Icons.copy, color: Colors.blue, size: Get.width*0.04),
                  ),
                ),
                const SizedBox(height: 20),
                _TextButton(
                    text: "Dispute Resolution",
                    subtitle: "View and file disputes",
                    onPressed: (){

                    }
                ),
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Manage Card",
                    subtitle: "View and manage your cards",
                    onPressed: (){

                    }
                ),
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Manage Banks",
                    subtitle: "View and manage your bank accounts",
                    onPressed: (){

                    }
                ),
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Referrals",
                    subtitle: "View your referrals and bonuses",
                    onPressed: (){

                    }
                ),
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
                  icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: Get.width*0.04,)
              )
            ],
          ),
        ),
      ),
    );
  }
}