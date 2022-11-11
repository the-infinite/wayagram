import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import 'package:dio/dio.dart' as dio;

class Contact extends GetView<HomeController> {
  const Contact({Key? key}) : super(key: key);

  static const route = '/contact';

  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    return  GetBuilder<HomeController>(
        id: 'contact',
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              title: Text('Your Contacts', style: AppTextStyle.subtitle1.copyWith(
                color: Colors.black,
              )),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if(controller.contacts.isEmpty)
                    Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: Get.height * 0.1,
                      ),
                      Text(
                        'Your contacts are not here yet!',
                        style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.5),fontSize: Get.textScaleFactor*18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Get.height * 0.06,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Get.width * 0.06, right: Get.width * 0.06),
                        child: Container(
                          height: Get.height*0.08,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: Get.width * 0.03),
                                    child: Text(
                                      'Contacts on Wayagram',
                                      style: AppTextStyle.subtitle1.copyWith(color: Colors.black,fontSize: Get.textScaleFactor*16,fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(height: Get.height*0.005),
                                  Padding(
                                    padding: EdgeInsets.only(left: Get.width * 0.03),
                                    child: Text(
                                      'Import your contact on Wayagram',
                                      style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.5),fontSize: Get.textScaleFactor*14),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: Get.width * 0.03),
                                child: SizedBox(
                                  child: AppButton(
                                    title: 'Import',
                                    onPressed: () async {
                                      if (await FlutterContacts.requestPermission()) {
                                        var contacts = await FlutterContacts.getContacts(withProperties: true,withThumbnail: true,withPhoto: true);
                                        controller.contacts = contacts;
                                        controller.update(['contact']);
                                      }
                                    },
                                    borderRadius: 10,
                                    fontColor: AppColors.background,
                                    bckgrndColor: AppColors.primary,
                                    border: Border.all(color: AppColors.primary, width: 1),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/invite_image.png',height: Get.height*0.3,width: Get.width*0.8,fit: BoxFit.cover,),
                        ],
                      ),
                    ],
                  ),
                  if(controller.contacts.isNotEmpty)
                    ListView.builder(
                      itemCount: controller.contacts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var person = controller.contacts[index];
                        return InkWell(
                          onTap: (){

                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: AppAvatar(
                                      bytes: person.photoOrThumbnail,
                                      radius: 50,
                                    ),
                                    onPressed: null,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      person.displayName,
                                      style: const TextStyle(
                                        color: Colors.black ,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width*0.8,
                                      child: Text(
                                        person.phones.isNotEmpty ? person.phones.first.normalizedNumber : '',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            ),
          );
        }
    );
  }
}
