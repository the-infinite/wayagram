import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:hashtager/widgets/hashtag_text_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/document_picker.dart';
import 'package:dio/dio.dart' as dio;

import '../../../global_widgets/helpers/dark_mode_helper.dart';
import '../../../global_widgets/overlays.dart';

class CreateMoment extends StatelessWidget {
  const CreateMoment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentStep = 0;
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var textController = TextEditingController();
    PageController pageController = PageController(initialPage: 0, keepPage: true);

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
            title: Text('Create Moment', style: AppTextStyle.subtitle1.copyWith(
              color: getAppColor(const Color(0xff4F4F4F)),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true, leading: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  FeatherIcons.arrowLeft,
                  color: getAppColor(Colors.black),
                ),
                onPressed: () {
                  Get.back();
                },
                iconSize: Get.width * 0.06,
              ),
            systemOverlayStyle:  SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ), actions: [
                Center(
                  child: SizedBox(
                    child: AppButton(
                      title: 'Create',
                      onPressed: () async {
                        Map<String, dynamic> body = {
                          "profile_id": fullProfile.id,
                        };
                        if(currentStep == 0){
                          if(controller.imagePaths.isNotEmpty){
                            body['file'] = await dio.MultipartFile.fromFile(
                              controller.imagePaths[0],
                              filename: controller.imagePaths[0].split('/').last,
                            );
                            if(textController.text.isNotEmpty){
                              body['content'] = textController.text;
                            }
                            var formData = dio.FormData.fromMap(body);
                            var response = await controller.postData(formData, "/wayagram-service/all-posts/create-moment");
                            if(response.isSuccessful){
                              controller.imagePaths.clear();
                              await controller.getPosts.then((value){
                                controller.update(['profile_page','home_tab','home']);
                              });
                              if(Get.currentRoute == "/CreateMoment"){
                                Get.back();
                                AppOverlay.showSuccessSnackBar(content: "Moment Created Successfully");
                              }
                            }else{
                              if(Get.currentRoute == "/CreateMoment"){
                                AppOverlay.showErrorSnackBar(title: 'Error', content: response.message?? "An Error Occurred");
                              }
                            }
                          }else{
                            if(Get.currentRoute == "/CreateMoment"){
                              AppOverlay.showErrorSnackBar(
                                  title: 'Error',
                                  content: "Please select an image"
                              );
                            }
                          }
                        }else{
                          if(textController.text.isNotEmpty){
                            body['content'] = textController.text;
                            var formData = dio.FormData.fromMap(body);
                            var response = await controller.postData(body, "/wayagram-service/all-posts/create-moment");
                            if(response.isSuccessful){
                              await controller.getPosts.then((value){
                                controller.update(['profile_page','home_tab','home']);
                              });
                              controller.imagePaths.clear();
                              if(Get.currentRoute == "/CreateMoment"){
                                Get.back();
                                AppOverlay.showSuccessSnackBar(content: "Moment Created Successfully");
                              }
                            }else{
                              if(Get.currentRoute == "/CreateMoment"){
                                if(Get.currentRoute == "/CreateMoment"){
                                  AppOverlay.showErrorSnackBar(title: 'Error', content: response.message?? "An Error Occurred");
                                }
                              }
                            }
                          }else{
                            if(Get.currentRoute == "/CreateMoment"){
                              AppOverlay.showErrorSnackBar(
                                  title: 'Error',
                                  content: "Please enter some text"
                              );
                            }
                          }
                        }
                      },
                      borderRadius: 10,
                      fontColor: AppColors.button,
                      bckgrndColor: getAppColor(AppColors.background),
                      border: Border.all(color: getAppColor(AppColors.background), width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      width: Get.width * 0.2,
                      fontSize: Get.textScaleFactor * 18,
                    ),
                  ),
                )
              ]
          ),
          body: Center(
            child: Container(
              height: Get.height - 50,
              width: Get.width - 20,
              decoration: BoxDecoration(
                color: AppColors.grey,
                border: Border.all(color: AppColors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  currentStep = index;
                },
                children: [
                  SizedBox(
                    child: FormField<String>(
                        initialValue: controller.imagePaths.isEmpty ? "" : controller.imagePaths[0],
                        validator: null,
                        builder: (field) {
                          return DocumentPicker(
                              radius: 10,
                              networkImage: null,
                              renderHeight: Get.height - 60,
                              renderWidth: Get.width - 30,
                              controller: controller,
                              position: 0,
                              fileImage: field.value,
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
                                        toolbarTitle: 'Crop Moment Photo',
                                        toolbarColor: AppColors.primary,
                                        toolbarWidgetColor: Colors.white,
                                        activeControlsWidgetColor: AppColors.primary,
                                        cropGridColor: AppColors.primary,
                                        initAspectRatio: CropAspectRatioPreset.original,
                                        lockAspectRatio: false),
                                    IOSUiSettings(
                                      title: 'Crop Moment Photo',
                                    ),
                                    WebUiSettings(
                                      context: context,
                                    ),
                                  ],
                                );
                                if(croppedFile == null){
                                  controller.imagePaths.clear();
                                  controller.imagePaths = List.from(controller.imagePaths)..add(imagePath);
                                  field.didChange(imagePath);
                                }else{
                                  controller.imagePaths.clear();
                                  controller.imagePaths = List.from(controller.imagePaths)..add(croppedFile.path);
                                  field.didChange(croppedFile.path);
                                }
                              },
                              actionWord: "Upload Moment Photo"
                          );
                        }
                    ),
                  ),
                  SizedBox(
                    width: Get.width - 30,
                    height: Get.height - 60,
                    child: HashTagTextField(
                      decoratedStyle: AppTextStyle.subtitle1.copyWith(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                      basicStyle: AppTextStyle.subtitle1.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter Moment Text',
                        hintStyle: AppTextStyle.subtitle1.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                      controller: textController,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleSwitch(
                  minWidth: Get.width * 0.5,
                  initialLabelIndex: currentStep,
                  totalSwitches: 2,
                  inactiveBgColor: getAppColor(AppColors.background),
                  activeBgColor: [getAppColor(AppColors.background), getAppColor(AppColors.background)],
                  activeBorders: [
                    //Bottom Border
                    Border.all(
                      color: getAppColor(AppColors.background),
                      width: 3.0,
                    ),
                    Border.all(
                      color: getAppColor(AppColors.background),
                      width: 3.0,
                    ),
                  ],
                  radiusStyle: true,
                  cornerRadius: 10.0,
                  labels: const ['Image', 'Text'],
                  customTextStyles: [
                    AppTextStyle.bodyText1.copyWith(
                      color: currentStep == 0 ? AppColors.primary : const Color(0xff064A72),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    AppTextStyle.bodyText1.copyWith(
                      color: currentStep == 1 ? AppColors.primary : const Color(0xff064A72),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ],
                  onToggle: (index) {
                    if (index == 0) {
                      pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      currentStep = 0;
                    } else {
                      pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      currentStep = 1;
                    }
                    controller.update();
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