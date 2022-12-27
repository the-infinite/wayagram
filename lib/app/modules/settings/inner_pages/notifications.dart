import 'dart:convert';

import 'package:flutter/foundation.dart';
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
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/model/sms_notification_response.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/overlays.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/notification_view.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeControllerWayagram>();
    final pushNotification = ReadWriteValue('wayagram_settings_push_notification', false, MyPref.box);
    final smsNotification = ReadWriteValue('wayagram_settings_sms_notification', false, MyPref.box);
    final emailNotification = ReadWriteValue('wayagram_settings_email_notification', false, MyPref.box);
    final messagesNotification = ReadWriteValue('wayagram_settings_messages_notification', false, MyPref.box);
    final postPerformanceNotification = ReadWriteValue('wayagram_settings_post_performance_notification', false, MyPref.box);
    final productsAndUpdatesNotification = ReadWriteValue('wayagram_settings_products_and_updates_notification', false, MyPref.box);
    final interestRecommendationNotification = ReadWriteValue('wayagram_settings_interest_recommendations_notification', false, MyPref.box);
    
    controller.getData("/auth-service/api/v1/profile/sms-alert/status/${controller.profile.phone.toString()}", false).then((value){
      if(value.isSuccessful){
        SmsNotificationResponse smsNotificationResponse = SmsNotificationResponse.fromJson(value.data);
        smsNotification.val = smsNotificationResponse.active == true;
        if(mounted) setState(() {});
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(
        id: 'notifications_settings', builder: (controller) {
       // final pushNotification = ReadWriteValue('wayagram_settings_push_notification', "wayagram", MyPref.box);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Notification Settings', style: AppTextStyle.subtitle1.copyWith(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Push Notifications",
                  value: pushNotification.val,
                  onChanged: (val){
                    pushNotification.val = val;
                    if(mounted) setState(() {});
                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "SMS Notifications",
                  value: smsNotification.val,
                  onChanged: (val){
                    var body = {
                      "phoneNumber": controller.profile.phone.toString(),
                    };
                    controller.postData(body, "/auth-service/api/v1/profile/sms-alert").then((value){
                      if(value.isSuccessful){
                        SmsNotificationResponse smsNotificationResponse = SmsNotificationResponse.fromJson(value.data);
                        smsNotification.val = smsNotificationResponse.active == true;
                        if(mounted) setState(() {});
                      }else{
                        AppOverlay.showErrorSnackBar();
                      }
                    });
                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Email Notifications",
                  value: emailNotification.val,
                  onChanged: (val){
                    emailNotification.val = val;
                    if(mounted) setState(() {});
                  },
                ),

                /*SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "New Notifications",
                  onChanged: (val){

                  },
                ),*/

                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Messages",
                  value: messagesNotification.val,
                  onChanged: (val){
                    messagesNotification.val = val;
                    if(mounted) setState(() {});
                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Post Performance Updates",
                  value: postPerformanceNotification.val,
                  onChanged: (val){
                    postPerformanceNotification.val = val;
                    if(mounted) setState(() {});
                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Products and Updates",
                  value: productsAndUpdatesNotification.val,
                  onChanged: (val){
                    productsAndUpdatesNotification.val = val;
                    if(mounted) setState(() {});
                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Interest Recommendations",
                  value: interestRecommendationNotification.val,
                  onChanged: (val){
                    interestRecommendationNotification.val = val;
                    if(mounted) setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _SwitchButton extends StatefulWidget {
  final String text;
  final bool value;
  final Function(bool)? onChanged;
  const _SwitchButton({required this.text, this.value = false, Key? key, this.onChanged}) : super(key: key);

  @override
  State<_SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<_SwitchButton> {
  bool value = false;

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
        onTap: (){
          setState(() {
            value = !value;
          });
          widget.onChanged!(value);
        },
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
                          widget.text,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: AppTextStyle.subtitle1.copyWith(color: value ? Colors.black : Colors.black.withOpacity(.5),fontSize: Get.width*0.038,fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: Get.height*0.01,
                        ),
                      ]
                  ),
                ),
              ),

              Switch(
                value: value,
                onChanged: (v) {
                   setState(() {
                     value = v;
                   });
                  if(widget.onChanged != null){
                    widget.onChanged!(v);
                  }
                },
                activeTrackColor: AppColors.primary.withOpacity(0.5),
                activeColor: AppColors.primary,
                inactiveTrackColor: Colors.grey.withOpacity(0.5),
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}