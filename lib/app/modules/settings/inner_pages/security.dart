import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
import '../../../data/model/authentication_information.dart';
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

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({Key? key}) : super(key: key);

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  var controller = Get.find<HomeControllerWayagram>();
  final twoFactorAuth = ReadWriteValue('wayagram_two_factor_auth', false, MyPref.box);

  @override
  void initState() {
    super.initState();
    controller.getData("/auth-service/api/v1/auth/status-check-2fa/${controller.profile.userId.toString()}", false).then((value){
      if(value.isSuccessful){
        AuthenticationInformation authenticationInformation = AuthenticationInformation.fromJson(value.data);
        twoFactorAuth.val = authenticationInformation.fa == true;
        if(mounted) setState(() {});
      }
    });
  }
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
                color: getAppColor(const Color(0xff4F4F4F)),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height*0.02),
                  _SwitchButton(
                    text: "2FA Authentication",
                    value: twoFactorAuth.val,
                    subtitle: "Enable/Disable 2FA authentication",
                    onChanged: (val,onChanged) async {
                      var response = await controller.postData(null,"/auth-service/api/v1/auth/toggle-2fa?userId=${controller.profile.userId.toString()}");
                      if(response.isSuccessful){
                        var res = await controller.getData("/auth-service/api/v1/auth/status-check-2fa/${controller.profile.userId.toString()}", false);
                        if(res.isSuccessful){
                          AuthenticationInformation authenticationInformation = AuthenticationInformation.fromJson(res.data);
                          twoFactorAuth.val = authenticationInformation.fa == true;
                          if(onChanged != null){
                            onChanged(twoFactorAuth.val);
                          }
                        }else{
                          twoFactorAuth.val = !twoFactorAuth.val;
                          if(onChanged != null){
                            onChanged(twoFactorAuth.val);
                          }
                        }
                      }else{
                        AppOverlay.showErrorSnackBar(content: "Something went wrong, please try again later");
                        if(onChanged != null){
                          onChanged(false);
                        }
                      }
                    },
                  ),
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
                              Get.offAll(() => const Multiplexor(),binding: WayagramBinding());
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
                color: getAppColor(Colors.grey).withOpacity(0.2),
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

class _SwitchButton extends StatefulWidget {
  final String text;
  final bool value;
  final String subtitle;
  final Function(bool,Function(bool)?)? onChanged;
  const _SwitchButton({required this.text, this.value = false, Key? key, this.onChanged, required this.subtitle}) : super(key: key);

  @override
  State<_SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<_SwitchButton> {
  bool value = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Get.width*0.025,right: Get.width*0.025),
      child: InkWell(
        onTap: () async {
          callback(bool val) async {
            await Future.delayed(const Duration(milliseconds: 500));
            setState(() {
              value = val;
            });
          }

          setState(() {
            loading = true;
          });

          if(widget.onChanged != null){
            await widget.onChanged!(!value,callback);
          }

          setState(() {
            loading = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: getAppColor(Colors.grey).withOpacity(0.2),
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
                          widget.text,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: AppTextStyle.subtitle1.copyWith(color: getAppColor(Colors.black),fontSize: Get.width*0.04,fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                        Text(
                          widget.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: AppTextStyle.subtitle1.copyWith(color: value ? getAppColor(Colors.black) : getAppColor(Colors.black).withOpacity(.5)),
                        ),
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                      ]
                  ),
                ),
              ),

              Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: loading ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SizedBox(
                          width: Get.width*0.05,
                          height: Get.width*0.05,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ),
                    ) :  Switch(
                      value: value,
                      onChanged: (v) async {
                        callback(bool val) async {
                          await Future.delayed(const Duration(milliseconds: 500));
                          setState(() {
                            value = val;
                          });
                        }

                        setState(() {
                          loading = true;
                        });

                        if(widget.onChanged != null){
                          await widget.onChanged!(v,callback);
                        }

                        setState(() {
                          loading = false;
                        });
                      },
                      activeTrackColor: AppColors.primary.withOpacity(0.5),
                      activeColor: AppColors.primary,
                      inactiveTrackColor: getAppColor(Colors.grey).withOpacity(0.5),
                      inactiveThumbColor: getAppColor(Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}