import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/api_response.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_avatar.dart';
import '../../global_widgets/app_button.dart';

import 'package:dio/dio.dart' as dio;

import '../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../global_widgets/overlays.dart';

class CreatePosts extends StatelessWidget {
  const CreatePosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePicker _imagePicker = ImagePicker();
    var textController = TextEditingController();
    List<String> images = [];
    var postID = "";

    /*images.removeAt(index);
     controller.update();*/
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(
              "Posts",
              style: TextStyle(
                color: const Color(0xff4F4F4F),
                fontSize: Get.textScaleFactor * 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(FeatherIcons.arrowLeft, color: Colors.black)
            ),
            actions: [
              Center(
                child: SizedBox(
                  child: AppButton(
                    title: 'Send',
                    onPressed: () async {
                      Map<String, dynamic> body = {
                        'description': textController.text,
                        'profile_id': fullProfile.id,
                        'type': 'user'
                      };
                      if(images.isNotEmpty){
                        body['images'] = await dio.MultipartFile.fromFile(
                          images[0],
                          filename: images[0].split('/').last,
                        );
                      }
                      var formData = dio.FormData.fromMap(body);
                      ApiResponse? response;
                      if(postID.isNotEmpty){
                        formData.fields.add(MapEntry('post_id', postID));
                        //images.removeAt(0);
                        body['type'] = null;
                        for (var element in images) {
                          body['post_id'] = postID;
                          body['images'] = await dio.MultipartFile.fromFile(
                            element,
                            filename: element.split('/').last,
                          );
                          formData = dio.FormData.fromMap(body);
                          response = await controller.putData(formData, "/wayagram-service/all-posts/update");
                        }
                        if(response!.isSuccessful){
                          postID = "";
                          await controller.getPosts;
                          controller.update(['profile_page','home_page','home']);
                          //AppOverlay.showInfoDialog(title: 'Success', content: response.message);
                          Get.back();
                        }
                      }else{
                        response = await controller.postData(formData, "/wayagram-service/all-posts/create");
                        if(response.isSuccessful){
                          if(images.isNotEmpty){
                            images.removeAt(0);
                          }
                          postID = response.data['id'] as String;
                          for (var element in images) {
                            body['post_id'] = postID;
                            body['type'] = null;
                            body['images'] = await dio.MultipartFile.fromFile(
                              element,
                              filename: element.split('/').last,
                            );
                            formData = dio.FormData.fromMap(body);
                            response = await controller.putData(formData, "/wayagram-service/all-posts/update");
                          }
                          if(response!.isSuccessful){
                            postID = "";
                            //AppOverlay.showInfoDialog(title: 'Success', content: response.message);
                            await controller.getPosts;
                            controller.update(['profile_page','home_page','home']);
                            //AppOverlay.showInfoDialog(title: 'Success', content: response.message);
                            Get.back();
                          }
                        }else{
                          AppOverlay.showInfoDialog(title: 'Error', content: response.message);
                        }
                      }
                    },
                    borderRadius: 10,
                    fontColor: AppColors.button,
                    bckgrndColor: AppColors.background,
                    border: Border.all(color: AppColors.background, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    width: Get.width * 0.2,
                    fontSize: Get.textScaleFactor * 18,
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: const Color(0xffEDEAEA),
                  height: 1.0,
                )),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: Get.height*0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width*0.13,
                    height: Get.width*0.13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2),
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
                  SizedBox(
                    width: Get.width*0.02
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.01,right: Get.width*0.015),
                            child: HashTagTextField(
                              decoratedStyle: AppTextStyle.subtitle1.copyWith(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                              basicStyle: AppTextStyle.subtitle1.copyWith(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              expands: false,
                              maxLines: null,
                              minLines: null,
                              decoration: InputDecoration(
                                hintText: 'Create New Post',
                                hintStyle: AppTextStyle.subtitle1.copyWith(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              controller: textController,
                              decorateAtSign: true,
                            ),
                          ),
                          if(images.isNotEmpty)
                            SizedBox(
                              height: Get.height*0.25,
                              child: NewsfeedMultipleImageView(
                                imageUrls: images,
                                marginLeft: 0.0,
                                marginRight: Get.width*0.028,
                                marginBottom: 0,
                                marginTop: 0,
                                radius: 15,
                                isFile: true,
                                useAspectRatio: true,
                                isSlideShow: false,
                          ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: const Color(0xffEDEAEA),
                height: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: Get.width*0.025,
                      ),
                      IconButton(
                        icon: Icon(Icons.image_outlined, color: images.length > 29 ? Colors.grey : Colors.black),
                        onPressed: () async {
                          if(images.length <= 29){
                            final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
                            if (pickedFile != null) {
                              CroppedFile? croppedFile = await ImageCropper().cropImage(
                                sourcePath: pickedFile.path,
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
                                      toolbarTitle: 'Crop Photo',
                                      toolbarColor: AppColors.primary,
                                      toolbarWidgetColor: Colors.white,
                                      activeControlsWidgetColor: AppColors.primary,
                                      cropGridColor: AppColors.primary,
                                      initAspectRatio: CropAspectRatioPreset.original,
                                      lockAspectRatio: false),
                                  IOSUiSettings(
                                    title: 'Crop Photo',
                                  ),
                                  WebUiSettings(
                                    context: context,
                                  ),
                                ],
                              );
                              if(croppedFile!=null){
                                images = List.from(images)..add(croppedFile.path);
                              }else{
                                images = List.from(images)..add(pickedFile.path);
                              }
                              controller.update();
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.video_camera_back_outlined, color: images.length > 29 ? Colors.grey : Colors.black,size: Get.width*0.065),
                        onPressed: () async {
                          if(images.length <= 29){
                            final pickedFile = await _imagePicker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 10));
                            if (pickedFile != null) {
                              images = List.from(images)..add(pickedFile.path);
                              controller.update();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: Get.width*0.025),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt_outlined, color: images.length > 29 ? Colors.grey : Colors.black),
                      onPressed: () async {
                        if(images.length <= 29){
                          final pickedFile = await _imagePicker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 30,
                          );
                          if (pickedFile != null && pickedFile.path.isNotEmpty) {
                            CroppedFile? croppedFile = await ImageCropper().cropImage(
                              sourcePath: pickedFile.path,
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
                                    toolbarTitle: 'Crop Photo',
                                    toolbarColor: AppColors.primary,
                                    toolbarWidgetColor: Colors.white,
                                    activeControlsWidgetColor: AppColors.primary,
                                    cropGridColor: AppColors.primary,
                                    initAspectRatio: CropAspectRatioPreset.original,
                                    lockAspectRatio: false),
                                IOSUiSettings(
                                  title: 'Crop Photo',
                                ),
                                WebUiSettings(
                                  context: context,
                                ),
                              ],
                            );
                            if(croppedFile!=null){
                              images = List.from(images)..add(croppedFile.path);
                            }else{
                              images = List.from(images)..add(pickedFile.path);
                            }
                            controller.update();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}