import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

class CreateGroup extends StatelessWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentPage = 0;
    var pageController = PageController();
    var formKey1 = GlobalKey<FormState>();

    var groupNameController = TextEditingController();
    var privacyController = TextEditingController(text: 'Public');
    var inviteController = TextEditingController();

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
            title: Text('Create Group', style: AppTextStyle.subtitle1.copyWith(
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
                    title: currentPage == 0 ? 'Next' : 'Create',
                    onPressed: () async {
                      if(formKey1.currentState!.validate()) {
                        pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                        currentPage = 1;
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
            ],
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
            ),
          ),
          body: Column(
            children: [
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width*0.03, vertical: 0),
                    child: SizedBox(
                      height: Get.height*0.8,
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Form(
                            key: formKey1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Get.height*0.025),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Group Information', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black,
                                    fontSize: Get.width*0.05,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.01),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Name your group', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: Get.width*0.04,
                                    fontWeight: FontWeight.normal,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.04),
                                PageInput(
                                  hint: 'What is the name of your group?',
                                  label: 'Group Name',
                                  validator: (val){
                                    if(val!.isEmpty){
                                      return 'Please enter a group name';
                                    }else if(val.length <= 1){
                                      return 'Please enter a valid group name';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  isCompulsory: true,
                                  controller: groupNameController,
                                ),
                                SizedBox(height: Get.height*0.025),
                                PageDropButton(
                                  label: "Choose Privacy",
                                  hint: '',
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  onChanged: (val) {
                                    privacyController.text = val;
                                  },
                                  value: "Public",
                                  items: ["Public","Private"].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: Get.height*0.025),
                                PageInput(
                                  hint: 'e.g. John Doe',
                                  label: 'Who do you want to invite?',
                                  validator: (val){
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  isCompulsory: false,
                                  controller: inviteController,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height*0.025),
                              Padding(
                                padding: EdgeInsets.only(left: Get.width*0.01),
                                child: Text('Images', style: AppTextStyle.subtitle1.copyWith(
                                  color: Colors.black,
                                  fontSize: Get.width*0.05,
                                  fontWeight: FontWeight.w600,
                                )),
                              ),
                              SizedBox(height: Get.height*0.01),
                              Padding(
                                padding: EdgeInsets.only(left: Get.width*0.01),
                                child: Text('Pick images for your group [Optional]', style: AppTextStyle.subtitle1.copyWith(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: Get.width*0.04,
                                  fontWeight: FontWeight.normal,
                                )),
                              ),
                              SizedBox(height: Get.height*0.04),
                              Padding(padding: EdgeInsets.only(left: Get.width*0.015,bottom: 5), child: Text('Group Profile Photo [Optional]', style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.7)),)),
                              FormField<String>(
                                  initialValue: '',
                                  validator: null,
                                  builder: (field) {
                                    return DocumentPicker(
                                        radius: 10,
                                        networkImage: null,
                                        renderHeight: Get.width * 0.35,
                                        renderWidth: Get.width,
                                        controller: controller,
                                        fileImage: field.value,
                                        position: 0,
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
                                                title: 'Crop Profile Photo',
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
                                        actionWord: "Upload Profile Photo",
                                      displayPickerIcon: false,
                                    );
                                  }
                              ),
                              SizedBox(height: Get.height*0.025),
                              Padding(padding: EdgeInsets.only(left: Get.width*0.015,bottom: 5), child: Text('Group Cover Photo [Optional]', style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.7)),)),
                              FormField<String>(
                                  initialValue: '',
                                  validator: null,
                                  builder: (field) {
                                    return DocumentPicker(
                                        radius: 10,
                                        networkImage: null,
                                        renderHeight: Get.width * 0.35,
                                        renderWidth: Get.width,
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
                                        actionWord: "Upload Cover Photo",
                                      displayPickerIcon: false,
                                    );
                                  }
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}