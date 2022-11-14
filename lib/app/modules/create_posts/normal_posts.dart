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

import '../../global_widgets/overlays.dart';

class CreatePosts extends StatelessWidget {
  const CreatePosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePicker _imagePicker = ImagePicker();
    var textController = TextEditingController();
    List<String> images = [];
    var postID = "";
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
            title: Text('Create Post', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Center(
                child: SizedBox(
                  child: AppButton(
                    title: 'Create',
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
                    fontColor: AppColors.primary,
                    bckgrndColor: AppColors.background,
                    border: Border.all(color: AppColors.background, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    width: Get.width * 0.3,
                  ),
                ),
              )
            ],
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
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.01, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width*0.15,
                    height: Get.width*0.15,
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
                    width: Get.width*0.75,
                    height: double.infinity,
                    child: HashTagTextField(
                      decoratedStyle: AppTextStyle.subtitle1.copyWith(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                      basicStyle: AppTextStyle.subtitle1.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      expands: true,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(images.isNotEmpty)
                SizedBox(
                  height: Get.height * 0.20,
                  width: Get.width,
                  child: ListView.builder(
                    itemCount: images.length,
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                        height: Get.height * 0.15,
                        width: Get.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(.5),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.file(
                              File(images[index]),
                              fit: BoxFit.cover,
                              height: Get.height * 0.15,
                              width: Get.height * 0.13,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.cancel_rounded, color: Colors.black),
                                    onPressed: () {
                                      images.removeAt(index);
                                      controller.update();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              SizedBox(
                height: Get.height*0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width*0.025,
                        ),
                        IconButton(
                          icon: Icon(Icons.image, color: images.length > 29 ? Colors.grey : Colors.black),
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
                        SizedBox(
                          width: Get.width*0.025,
                        ),
                        IconButton(
                          icon: const Icon(Icons.video_camera_back_rounded, color: Colors.white),
                          onPressed: () async {
                            /*if(images.length <= 29){
                              final pickedFile = await _imagePicker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 10));
                              if (pickedFile != null) {
                                images = List.from(images)..add(pickedFile.path);
                                controller.update();
                              }
                            }*/
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: Get.width*0.025),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt_rounded, color: images.length > 29 ? Colors.grey : Colors.black),
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
              ),
            ],
          ),
        );
      }),
    );
  }
}