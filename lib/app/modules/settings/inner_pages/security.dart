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
import 'package:wayagram/app/global_widgets/overlays.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../bindings/wayagram_binding.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/person_view.dart';
import '../../../repository/user_repo.dart';
import '../../change_password/enter_email.dart';
import '../../home/widgets/notification_view.dart';
import '../../multiplexor/multiplexor.dart';

class SecuritySettings extends StatelessWidget {
  SecuritySettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: getAppColor(AppColors.background),
              title: Text('Security Settings', style: AppTextStyle.subtitle1.copyWith(
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Change Password",
                    subtitle: "Change your password",
                    onPressed: (){
                      Get.to(() => EnterEmail(controller.profile.email, controller.profile.phone));
                    }
                ),
                /*SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Reset PIN",
                    subtitle: "Reset your transaction PIN",
                    onPressed: (){

                    }
                ),*/
                SizedBox(height: Get.height*0.02),
                _TextButton(
                    text: "Delete Account",
                    subtitle: "Delete your account from Wayagram",
                    onPressed: (){
                      AppOverlay.showDeviceDialog(
                        title: "Delete Account",
                        content: "Are you sure you want to delete your account?",
                        onPositivePressed: () async {
                          ApiResponse response = await controller.deleteData({}, "/auth-service/api/v1/user/delete/${controller.profile.userId}");
                          if(response.isSuccessful){
                            AppOverlay.showSuccessSnackBar(content: "Account deleted successfully");
                            if(MyPref.uniqueID.val.isNotEmpty){
                              var body = {
                                "device_token_id": MyPref.uniqueID.val,
                              };
                              controller.deleteData(body, "/wayagram-service/notification/delete-device-token");
                            }
                            controller.userRepo.api.disconnect();
                            Get.back();
                            MyPref.clearBoxes();
                            Get.offAll(() => Multiplexor(),binding: WayagramBinding());
                          }else{
                            AppOverlay.showErrorSnackBar(content: response.message?? "Error deleting account");
                          }
                        },
                      );
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