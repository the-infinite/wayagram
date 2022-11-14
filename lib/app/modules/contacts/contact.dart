import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/app_refresher.dart';
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
    RefreshController refreshController = RefreshController(initialRefresh: false);

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
            body: Column(
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
                      controller.hasContactPermission ? 'No Contacts Found' : 'Please allow access to your contacts',
                      style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.5),fontSize: Get.width * 0.045),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: Get.height * 0.06,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Get.width * 0.04, right: Get.width * 0.04),
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
                                    style: AppTextStyle.subtitle1.copyWith(color: Colors.black,fontSize: Get.width * 0.045,fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(height: Get.height*0.005),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width * 0.03),
                                  child: Text(
                                    'Import your contact on Wayagram',
                                    style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.5),fontSize: Get.width * 0.03),
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
                                      await controller.checkPermissionStatus();
                                      controller.update(['contact']);
                                    }
                                  },
                                  borderRadius: 10,
                                  fontColor: AppColors.background,
                                  bckgrndColor: AppColors.primary,
                                  border: Border.all(color: AppColors.primary, width: 1),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  fontSize: Get.width * 0.04,
                                  width: Get.width * 0.25,
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
                if(controller.contactToShow.isNotEmpty)
                  Expanded(
                    child: AppRefresher(
                      onRefresh: () async {
                        await controller.checkPermissionStatus();
                        refreshController.refreshCompleted();
                      },
                      onLoading: () async {
                        await controller.updateContactList();
                        refreshController.loadComplete();
                      },
                      controller: refreshController,
                      child: ListView.builder(
                        itemCount: controller.contactToShow.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var person = controller.contactToShow[index];
                          return Container(
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
                                      isContact: true,
                                      contactName: person.displayName,
                                    ),
                                    onPressed: null,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      person.displayName,
                                      style: const TextStyle(
                                        color: Colors.black ,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if(person.phones.isNotEmpty)
                                      SizedBox(
                                      width: Get.width*0.5,
                                      child: Text(
                                        person.phones.first.normalizedNumber,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Get.width * 0.035,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if(person.phones.isEmpty && person.emails.isNotEmpty)
                                      SizedBox(
                                        width: Get.width*0.5,
                                        child: Text(
                                          person.emails.first.address,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Get.width * 0.035,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    if(person.phones.isEmpty && person.emails.isEmpty)
                                      SizedBox(
                                        width: Get.width*0.5,
                                        child: Text(
                                          person.displayName,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: Get.width * 0.035,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppButton(
                                        title: 'Invite',
                                        onPressed: () async {

                                        },
                                        borderRadius: 5,
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        bckgrndColor: AppColors.background,
                                        fontColor: AppColors.primary,
                                        border: Border.all(color: AppColors.primary),
                                        fontSize: Get.width*0.04,
                                        width: Get.width*0.25,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
              ],
            ),
          );
        }
    );
  }
}
