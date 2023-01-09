import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/following_model_entity.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/app_refresher.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/person_view.dart';
import '../home/widgets/notification_view.dart';


class NewGroupChat extends StatelessWidget{
  NewGroupChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    List<Person> chosenPersonList = [];
    RefreshController refreshController = RefreshController(initialRefresh: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        var currentPage = ReadWriteValue('wayagram_following_current_page', 1, MyPref.box);
        var savedPosts = MyPref.following.val;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text('New Group Chat', style: AppTextStyle.subtitle1.copyWith(
              color: getAppColor(Color(0xff4F4F4F)),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            actions: [
              Center(
                child: SizedBox(
                  child: AppButton(
                    title: 'Create',
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {

                      }
                    },
                    borderRadius: 10,
                    fontColor: AppColors.button,
                    bckgrndColor: getAppColor(AppColors.background),
                    border: Border.all(color: getAppColor(AppColors.background), width: 1),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    width: Get.width * 0.2,
                  ),
                ),
              )
            ],
            leading: IconButton(
              icon: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black)),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: PreferredSize(
                preferredSize: Size(Get.width, 0.5),
                child: Column(
                  children: [
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ],
                )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
          ),
          body: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Get.height*0.01,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: Get.width*0.01),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          color: Colors.white
                      ),
                      child: FormField<String>(
                          initialValue: '',
                          validator: null,
                          builder: (field) {
                            return DocumentPicker(
                                radius: 100,
                                renderHeight: Get.width * 0.18,
                                renderWidth: Get.width * 0.18,
                                controller: controller,
                                position: 1,
                                displayPickerIcon: false,
                                onSelected: (imagePath, base64Image) async {
                                  CroppedFile? croppedFile = await ImageCropper().cropImage(
                                    sourcePath: imagePath,
                                    cropStyle: CropStyle.rectangle,
                                    aspectRatioPresets: [
                                      CropAspectRatioPreset.square,
                                      CropAspectRatioPreset.ratio3x2,
                                      CropAspectRatioPreset.original,
                                      CropAspectRatioPreset.ratio4x3,
                                      CropAspectRatioPreset.ratio16x9
                                    ],
                                    uiSettings: [
                                      AndroidUiSettings(
                                          toolbarTitle: 'Crop Profile Photo',
                                          toolbarColor: Colors.white,
                                          toolbarWidgetColor: getAppColor(Colors.black),
                                          activeControlsWidgetColor: AppColors.primary,
                                          cropGridColor: AppColors.primary,
                                          initAspectRatio: CropAspectRatioPreset.square,
                                          lockAspectRatio: false),
                                      IOSUiSettings(
                                        title: 'Crop Profile Photo',
                                      ),
                                      WebUiSettings(
                                        context: context,
                                      ),
                                    ],
                                  );
                                  if(croppedFile == null){
                                    if(controller.imagePaths.isEmpty){
                                      controller.imagePaths = List.from(controller.imagePaths)..add("")..add(imagePath);
                                    }else{
                                      if(controller.imagePaths.length > 2) {
                                        controller.imagePaths[1] = imagePath;
                                      }else{
                                        controller.imagePaths = List.from(controller.imagePaths)..add(imagePath);
                                      }
                                    }
                                    field.didChange(imagePath);
                                  }else{
                                    if(controller.imagePaths.isEmpty){
                                      controller.imagePaths = List.from(controller.imagePaths)..add("")..add(croppedFile.path);
                                    }else{
                                      if(controller.imagePaths.length > 2) {
                                        controller.imagePaths[1] = croppedFile.path;
                                      }else{
                                        controller.imagePaths = List.from(controller.imagePaths)..add(croppedFile.path);
                                      }
                                    }
                                    field.didChange(croppedFile.path);
                                  }
                                },
                                actionWord: "Choose Group Image"
                            );
                          }
                      ),
                    ),
                    SizedBox(width: Get.width*0.01),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height*0.023),
                        child: AppInput(
                          hintText: "Group Name",
                          label: null,
                          controller: nameController,
                          validator: (val){
                            if(val!.isEmpty){
                              return "Please enter group name";
                            }else if(chosenPersonList.length < 2){
                              return "Please select at least two members";
                            }
                            return null;
                          },
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width*0.01)
                  ],
                ),
                SizedBox(height: Get.height*0.01,),
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  child: AppRefresher(
                    onRefresh: () async {
                      final response = await controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=1',true);
                      if(response.isSuccessful){
                        var posts = FollowingModelEntity.fromJson(response.data);
                        if(posts.following != null){
                          if(posts.following!.isNotEmpty && savedPosts.isNotEmpty){
                            var saved = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                            if(saved.following!.isNotEmpty){
                              var first = saved.following!.first;
                              var current = posts.following!.first;
                              if(first.id != current.id){
                                posts.following = saved.following! + posts.following!;
                                MyPref.following.val = jsonEncode(posts);
                              }
                            }else{
                              MyPref.following.val = jsonEncode(response.data);
                            }
                          }
                        }
                      }
                      refreshController.refreshCompleted();
                      controller.update();
                    },
                    onLoading: () async {
                      final response = await controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=${currentPage.val}',true);
                      if(response.isSuccessful){
                        var posts = FollowingModelEntity.fromJson(response.data);
                        var saved = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                        for (var element in posts.following!) {
                          saved.following!.removeWhere((e) => e.id == element.id);
                        }
                        saved.following!.addAll(posts.following!);
                        MyPref.following.val = jsonEncode(saved);
                        if(posts.following!.isNotEmpty){
                          currentPage.val = currentPage.val + 1;
                        }
                      }
                      refreshController.loadComplete();
                      controller.update();
                    },
                    controller: refreshController,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<ApiResponse>(
                              future: controller.getData('/wayagram-service/graph/friend/following?user_id=${profile.userId}&page=1',true),
                              builder: (context, snapshot) {
                                var savedPosts = MyPref.following.val;
                                if(savedPosts.isNotEmpty){
                                  var posts = FollowingModelEntity.fromJson(jsonDecode(savedPosts));
                                  var names = posts.following!.map((e) => e.displayName.toString()).toList();
                                  var username = posts.following!.map((e) => e.username.toString()).toList();
                                  var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                                  var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                                  return PersonView(
                                    name: names,
                                    username: username,
                                    profilePic: profile,
                                    length: posts.following == null ? 0 : posts.following!.length,
                                    userIDs: userIds,
                                    following: posts.following,
                                    chosenPersonList: chosenPersonList,
                                    showCheckBox: true,
                                    onChecked: (person){
                                      if(chosenPersonList.contains(person)){
                                        chosenPersonList.remove(person);
                                      }else{
                                        chosenPersonList.add(person);
                                      }
                                      controller.update();
                                    },
                                  );
                                }else{
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                                    var posts = FollowingModelEntity.fromJson(snapshot.data!.data);
                                    var names = posts.following!.map((e) => e.displayName.toString()).toList();
                                    var username = posts.following!.map((e) => e.username.toString()).toList();
                                    var profile = posts.following!.map((e) => e.avatar.toString()).toList();
                                    var userIds = posts.following!.map((e) => e.userId.toString()).toList();
                                    MyPref.following.val = jsonEncode(posts);
                                    currentPage.val = 2;
                                    return PersonView(
                                      name: names,
                                      username: username,
                                      profilePic: profile,
                                      length: posts.following == null ? 0 : posts.following!.length,
                                      userIDs: userIds,
                                      following: posts.following,
                                      showCheckBox: true,
                                      chosenPersonList: chosenPersonList,
                                      onChecked: (person){
                                        if(chosenPersonList.contains(person)){
                                          chosenPersonList.remove(person);
                                        }else{
                                          chosenPersonList.add(person);
                                        }
                                        controller.update();
                                      },
                                    );
                                  }
                                  return NotificationView(isLoading: true);
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}