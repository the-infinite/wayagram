import 'dart:convert';

import 'package:flutter/material.dart';
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
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

class UpdateProfile extends GetView<HomeController> {
  const UpdateProfile({Key? key}) : super(key: key);

  static const route = '/updateProfile';

  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    return  GetBuilder<HomeController>(
        builder: (controller) {
          print("hi");
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
            title: Text('Update Profile', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
              actions: [
                Center(
                  child: SizedBox(
                    child: AppButton(
                      title: 'Save',
                      onPressed: () {

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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.25,
                child: Stack(
                  children: [
                    SizedBox(
                      child: FormField<String>(
                          initialValue: '',
                          validator: null,
                          builder: (field) {
                          return DocumentPicker(
                              radius: 0,
                              networkImage: null,
                              renderHeight: Get.width * 0.35,
                              renderWidth: Get.width,
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
                                              toolbarTitle: 'Crop Cover Photo',
                                              toolbarColor: AppColors.primary,
                                              toolbarWidgetColor: Colors.white,
                                              activeControlsWidgetColor: AppColors.primary,
                                              cropGridColor: AppColors.primary,
                                              initAspectRatio: CropAspectRatioPreset.original,
                                              lockAspectRatio: false),
                                          IOSUiSettings(
                                            title: 'Crop Cover Photo',
                                          ),
                                          WebUiSettings(
                                            context: context,
                                          ),
                                        ],
                                      );
                                      if(croppedFile == null){
                                        if(controller.imagePaths.isEmpty){
                                          controller.imagePaths = List.from(controller.imagePaths)..add(imagePath);
                                        }else{
                                          controller.imagePaths[0] = imagePath;
                                        }
                                        field.didChange(imagePath);
                                      }else{
                                        if(controller.imagePaths.isEmpty){
                                          controller.imagePaths = List.from(controller.imagePaths)..add(croppedFile.path);
                                        }else{
                                          controller.imagePaths[0] = croppedFile.path;
                                        }
                                        field.didChange(croppedFile.path);
                                      }
                              },
                              actionWord: "Upload Cover Photo"
                          );
                        }
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
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
                                networkImage: null,
                                renderHeight: Get.width * 0.25,
                                renderWidth: Get.width * 0.25,
                                controller: controller,
                                position: 1,
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
                                          toolbarColor: AppColors.primary,
                                          toolbarWidgetColor: Colors.white,
                                          activeControlsWidgetColor: AppColors.primary,
                                          cropGridColor: AppColors.primary,
                                          initAspectRatio: CropAspectRatioPreset.original,
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
                                      controller.imagePaths = List.from(controller.imagePaths)..add("")..add(imagePath);
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
                                actionWord: "Upload Profile"
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.025,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.035, right: Get.width * 0.035),
                    child: Column(
                      children: [
                        PageInput(
                          hint: '',
                          label: 'Unique Username',
                          validator: (val){
                            if(val!.isEmpty){
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          isCompulsory: true,
                        ),
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        const PageInput(
                          hint: '',
                          label: 'Display Name',
                          validator: Validator.fullnameValidation,
                          isCompulsory: true,
                        ),
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        PageInput(
                          hint: '',
                          label: 'Bio',
                          validator: (val){
                            if(val!.isEmpty){
                              return 'Please enter your page name';
                            }
                            return null;
                          },
                          isCompulsory: true,
                        ),
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        PageDropButton(
                          label: "Choose Privacy",
                          hint: '',
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          onChanged: (val) {
                          },
                          value: "Public",
                          items: ["Public","Private"].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
