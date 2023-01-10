import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../core/theme/app_styles.dart';
import '../../../core/theme/app_themes.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/SearchPeopleResponse.dart';
import '../../data/model/followers_model_entity.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/app_refresher.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import 'package:dio/dio.dart' as dio;

import '../../global_widgets/wayagram_images_helpers/wayagram_image_helper.dart';

class Contact extends StatefulWidget {
  Contact({Key? key}) : super(key: key);

  static const route = '/contact';

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  @override
  Widget build(BuildContext context) {
    //
    RefreshController refreshController = RefreshController(initialRefresh: false);

    return  GetBuilder<HomeControllerWayagram>(
        id: 'contact',
        builder: (controller) {
          var followers = FollowersModelEntity.fromJson(jsonDecode(MyPref.followers.val));
          var following = FollowingModelEntity.fromJson(jsonDecode(MyPref.following.val));
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
              leading: IconButton(
                icon: Icon(
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
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: getAppColor(AppColors.background),
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
                                offset: Offset(0, 1), // changes position of shadow
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
                                    fontColor: getAppColor(AppColors.background),
                                    bckgrndColor: AppColors.primary,
                                    border: Border.all(color: AppColors.primary, width: 1),
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          ImageHelper.normalImage(
                            'assets/images/invite_image.png',height: Get.height*0.3,width: Get.width*0.8,fit: BoxFit.cover,
                          )
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
                            SearchPeopleResponse? user;
                            var person = controller.contactToShow[index];
                            var isOnWayagram = false;
                            var isFollowing = false;
                            var buttonText = "Invite";
                            var backgroundColor = getAppColor(AppColors.background);
                            var fontColor = AppColors.primary;
                            if(person.phones.isEmpty && person.emails.isNotEmpty){
                              isOnWayagram = controller.searchPeopleResponse.any((element) => element.email == person.emails.first.address);
                              if(isOnWayagram){
                                user = controller.searchPeopleResponse.firstWhere((element) => element.email == person.emails.first.address);
                                if(user!.email == fullProfile.email || user!.phoneNumber == fullProfile.phone){
                                  return Container();
                                }
                                buttonText = "Follow";
                                isFollowing = following.following!.any((element) => (element.email == user!.email) || (element.phone == user.phoneNumber) || (element.id == user.id));
                                if(isFollowing){
                                  buttonText = "Following";
                                }
                                backgroundColor = AppColors.primary;
                                fontColor = getAppColor(AppColors.background);
                              }else{
                                isFollowing = false;
                              }
                            }else if(person.phones.isNotEmpty){
                              isOnWayagram = controller.searchPeopleResponse.any((element) => element.phoneNumber == person.phones.first.normalizedNumber.replaceAll("+",""));
                              if(isOnWayagram){
                                user = controller.searchPeopleResponse.firstWhere((element) => element.phoneNumber == person.phones.first.normalizedNumber.replaceAll("+",""));
                                if(user!.email == fullProfile.email || user!.phoneNumber == fullProfile.phone){
                                  return Container();
                                }
                                buttonText = "Follow";
                                isFollowing = following.following!.any((element) => (element.email == user!.email) || (element.phone == user.phoneNumber) || (element.id == user.id));
                                if(isFollowing){
                                  buttonText = "Following";

                                }
                                backgroundColor = AppColors.primary;
                                fontColor = getAppColor(AppColors.background);
                              }else{
                                isFollowing = false;
                              }
                            }else{
                              return Container();
                            }
                            return Container(
                              margin: EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
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
                                      SizedBox(
                                        width: Get.width*0.5,
                                        child: Text(
                                          person.displayName,
                                          style: TextStyle(
                                            color: Colors.black ,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if(person.phones.isNotEmpty)
                                        SizedBox(
                                        width: Get.width*0.5,
                                        child: Text(
                                          person.phones.first.normalizedNumber.isNotEmpty ? person.phones.first.normalizedNumber : person.phones.first.number,
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
                                  if(person.phones.isNotEmpty || person.emails.isNotEmpty)
                                    Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AppButton(
                                          title: buttonText,
                                          onPressed: () async {
                                            if(isOnWayagram){
                                              var body = {
                                                "user_id": user!.userId.toString(),
                                                "username": person.displayName
                                              };

                                              if(!isFollowing){
                                                var response = await controller.postData(body, "wayagram-service/graph/friend/follow");
                                                if(response.isSuccessful){
                                                  await controller.getFollowing;
                                                  await controller.getPosts;
                                                  setState(() {

                                                  });
                                                }
                                              }else{
                                                var response = await controller.postData(body, "wayagram-service/graph/friend/unfollow");
                                                if(response.isSuccessful){
                                                  await controller.getFollowing;
                                                  await controller.getPosts;
                                                  setState(() {

                                                  });
                                                }
                                              }
                                            }else{
                                              await Share.share('Hi Friend, Join me on wayagram https://app.staging.wayagram.ng?from=shared', subject: 'Invite');
                                            }
                                          },
                                          borderRadius: 5,
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          bckgrndColor: backgroundColor,
                                          fontColor: fontColor,
                                          border: Border.all(color: (isFollowing && isOnWayagram) ? getAppColor(AppColors.background) : AppColors.primary, width: 1),
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
            ),
          );
        }
    );
  }
}
