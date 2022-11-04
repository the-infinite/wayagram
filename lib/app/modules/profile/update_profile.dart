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
import 'package:dio/dio.dart' as dio;

class UpdateProfile extends GetView<HomeController> {
  const UpdateProfile({Key? key}) : super(key: key);

  static const route = '/updateProfile';

  @override
  Widget build(BuildContext context) {
    var isPrivate = false;
    var formKey = GlobalKey<FormState>();
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var usernameController = TextEditingController(text: fullProfile.username);
    var displayNameController = TextEditingController(text: fullProfile.displayName);
    var bioController = TextEditingController(text: fullProfile.bio);

    var private = fullProfile.notPublic;

    return  GetBuilder<HomeController>(
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
            title: Text('Update Profile', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
              actions: [
                Center(
                  child: SizedBox(
                    child: AppButton(
                      title: 'Save',
                      onPressed: () async {
                        if(formKey.currentState!.validate()){
                          Map<String, dynamic> body = {
                            'username': usernameController.text,
                            'displayName': displayNameController.text,
                            'bio': bioController.text,
                            "user_id": fullProfile.userId,
                            "notPublic": isPrivate.toString(),
                          };

                          if(controller.imagePaths.isNotEmpty){
                            if(controller.imagePaths[0].toString().isNotEmpty){
                              body['coverImage'] = await dio.MultipartFile.fromFile(
                                controller.imagePaths[0],
                                filename: controller.imagePaths[0].split('/').last,
                              );
                            }
                          }

                          if(controller.imagePaths.length > 1){
                            if(controller.imagePaths[1].toString().isNotEmpty){
                              body['avatar'] = await dio.MultipartFile.fromFile(
                                controller.imagePaths[1],
                                filename: controller.imagePaths[0].split('/').last,
                              );
                            }
                          }

                          var formData = dio.FormData.fromMap(body);

                          await controller.updateProfile(formData);
                        }
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FormField<String>(
                              initialValue: '',
                              validator: null,
                              builder: (field) {
                              return DocumentPicker(
                                  radius: 0,
                                  networkImage: fullProfile.coverImage,
                                  renderHeight: Get.width * 0.35,
                                  renderWidth: Get.width,
                                  controller: controller,
                                  position: 0,
                                  fileImage: field.value,
                                  fit: BoxFit.cover,
                                  displayPickerIcon: false,
                                  onSelected: (imagePath, base64Image) async {
                                    CroppedFile? croppedFile = await ImageCropper().cropImage(
                                            sourcePath: imagePath,
                                            cropStyle: CropStyle.rectangle,
                                            aspectRatioPresets: [
                                              CropAspectRatioPreset.original,
                                              CropAspectRatioPreset.ratio16x9
                                            ],
                                            uiSettings: [
                                              AndroidUiSettings(
                                                  toolbarTitle: 'Crop Cover Photo',
                                                  toolbarColor: Colors.white,
                                                  toolbarWidgetColor: Colors.black,
                                                  activeControlsWidgetColor: AppColors.primary,
                                                  cropGridColor: AppColors.primary,
                                                  initAspectRatio: CropAspectRatioPreset.ratio16x9,
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
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(Icons.add_a_photo_rounded, color: Colors.white.withOpacity(1), size: 30),
                            ),
                          )
                        ],
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            FormField<String>(
                                initialValue: '',
                                validator: null,
                                builder: (field) {
                                return DocumentPicker(
                                    radius: 100,
                                    networkImage: fullProfile.avatar,
                                    renderHeight: Get.width * 0.25,
                                    renderWidth: Get.width * 0.25,
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
                                              toolbarWidgetColor: Colors.black,
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
                                    actionWord: "Upload Profile"
                                );
                              }
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.add_a_photo_rounded, color: Colors.white.withOpacity(1), size: 30),
                              ),
                            )
                          ],
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
                    child: Form(
                      key: formKey,
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
                            controller: usernameController,
                            prefix: Icon(Icons.alternate_email, color: Colors.black,size: Get.width*0.05),
                            contentPadding: const EdgeInsets.only(left: 0),
                          ),
                          SizedBox(
                            height: Get.height * 0.025,
                          ),
                          PageInput(
                            hint: '',
                            label: 'Display Name',
                            validator: Validator.fullnameValidation,
                            isCompulsory: true,
                            controller: displayNameController,
                          ),
                          SizedBox(
                            height: Get.height * 0.025,
                          ),
                          PageInput(
                            hint: '',
                            label: 'Bio',
                            validator: (val){
                              return null;
                            },
                            isCompulsory: false,
                            controller: bioController,
                          ),
                          SizedBox(
                            height: Get.height * 0.025,
                          ),
                          PageDropButton(
                            label: "Choose Privacy",
                            hint: '',
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            onChanged: (val) {
                              if(val == "Public") {
                                isPrivate = false;
                              }else{
                                isPrivate = true;
                              }
                            },
                            value: private == true ? "Private" : "Public",
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
              ),
            ],
          ),
        );
      }
    );
  }
}
