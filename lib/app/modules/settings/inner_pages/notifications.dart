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
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/horizontal_item_tile.dart';
import '../../../global_widgets/person_view.dart';
import '../../home/widgets/notification_view.dart';

class NotificationsSettings extends StatelessWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Notification Settings', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
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
              actions: [
                Center(
                  child: SizedBox(
                    child: AppButton(
                      title: 'Save',
                      onPressed: () async {

                      },
                      borderRadius: 10,
                      fontColor: AppColors.primary,
                      bckgrndColor: AppColors.background,
                      border: Border.all(color: AppColors.background, width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    ),
                  ),
                )
              ]
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Push Notifications",
                  onChanged: (val){

                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "SMS Notifications",
                  onChanged: (val){

                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Push Notifications",
                  onChanged: (val){

                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "New Notifications",
                  onChanged: (val){

                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Messages",
                  onChanged: (val){

                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Post Performance Updates",
                  onChanged: (val){

                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Products and Updates",
                  onChanged: (val){

                  },
                ),
                SizedBox(height: Get.height*0.02),
                _SwitchButton(
                  text: "Interest Recommendations",
                  onChanged: (val){

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}