import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/page_categories_model.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

import 'package:dio/dio.dart' as dio;

import 'normal_posts.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var homeController = Get.find<HomeControllerWayagram>();
  var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var linkController = TextEditingController();
  var pageVisibility = TextEditingController();
  var pageCategory = TextEditingController();
  PageCategoriesModel? chosenCategory;

  var formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    homeController.userRepo.getFullUserProfile(homeController.profile.userId.toString()).then((value) {
      if(value.isSuccessful){
        homeController.userRepo.getPageCategories().then((value) {
          if(mounted){
            setState(() {

            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        List<PageCategoriesModel> categories = [];
        if(MyPref.pageCategories.val.isNotEmpty){
          categories = PageCategoriesModel.listFromJson(jsonDecode(MyPref.pageCategories.val));
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Create Page', style: AppTextStyle.subtitle1.copyWith(
              color: const Color(0xff4F4F4F),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
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
                      if (formKey1.currentState!.validate()) {
                        Map<String, dynamic> body = {
                          "userId": fullProfile.id,
                          "categoryId": chosenCategory!.id,
                          "category": chosenCategory!.title,
                          "username": nameController.text,
                          "title": nameController.text,
                          "description": descriptionController.text,
                          "isPublic": pageVisibility.text == 'Public',
                        };
                        if(linkController.text.isNotEmpty) {
                          body['websiteUrl'] = linkController.text;
                        }
                        if(controller.imagePaths.isNotEmpty){
                          body['image'] = await dio.MultipartFile.fromFile(
                            controller.imagePaths[0],
                            filename: controller.imagePaths[0].split('/').last,
                          );
                        }

                        if(controller.imagePaths.length > 1){
                          body['headerImage'] = await dio.MultipartFile.fromFile(
                            controller.imagePaths[1],
                            filename: controller.imagePaths[0].split('/').last,
                          );
                        }

                        var formData = dio.FormData.fromMap(body);
                        var response = await controller.postData(formData, "wayagram-service/main/page/create-page");
                        if(response.isSuccessful){
                          await controller.getPosts;
                          controller.update(['home']);
                          Get.back();
                          AppOverlay.showSuccessSnackBar(content: 'Page created successfully');
                        }else{
                          AppOverlay.showErrorSnackBar(title: 'Error', content: response.message ?? 'Something went wrong');
                        }
                      }
                    },
                    borderRadius: 10,
                    fontColor: AppColors.button,
                    bckgrndColor: AppColors.background,
                    border: Border.all(color: AppColors.background, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    width: Get.width * 0.2,
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
                    child: Form(
                      key: formKey1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height*0.025),
                          PageInput(
                            hint: '',
                            label: 'Page Name',
                            validator: (val){
                              if(val!.isEmpty){
                                return 'Please enter your page name';
                              }
                              return null;
                            },
                            isCompulsory: true,
                            controller: nameController,
                          ),
                          SizedBox(height: Get.height * 0.025),
                          PageDropButton(
                            label: "Page Category",
                            hint: 'Choose a category',
                            isCompulsory: true,
                            onChanged: (value) {
                              for (var element in categories) {
                                if(element.id == value){
                                  pageCategory.text = element.title.toString();
                                  chosenCategory = element;
                                  break;
                                }
                              }
                            },
                            validator: (val){
                              if(chosenCategory == null){
                                return 'Please choose a category';
                              }
                              return null;
                            },
                            items: categories.map<DropdownMenuItem<String>>((PageCategoriesModel value){
                              return DropdownMenuItem<String>(
                                value: value.id,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(value.title.toString()),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageInput(
                            hint: '',
                            label: 'Description',
                            validator: (val){
                              if(val!.isEmpty){
                                return 'Please enter your page description';
                              }
                              return null;
                            },
                            isCompulsory: true,
                            controller: descriptionController,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageInput(
                            hint: '',
                            label: 'Website',
                            validator: (val){
                              return null;
                            },
                            isCompulsory: false,
                            controller: linkController,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageDropButton(
                            label: "Page Visibility",
                            hint: '',
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            onChanged: (val) {
                              pageVisibility.text = val;
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
                          Padding(padding: EdgeInsets.only(left: Get.width*0.015,bottom: 5), child: Text('Page Profile Photo [Optional]', style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.7)),)),
                          FormField<String>(
                              initialValue: '',
                              validator: null,
                              builder: (field) {
                              return DocumentPicker(
                                  radius: 10,
                                  networkImage: null,
                                  renderHeight: Get.width * 0.35,
                                  renderWidth: Get.width * 0.35,
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
                                  actionWord: "Upload Profile Photo"
                              );
                            }
                          ),
                          SizedBox(height: Get.height*0.025),
                          Padding(padding: EdgeInsets.only(left: Get.width*0.015,bottom: 5), child: Text('Page Cover Photo [Optional]', style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.7)),)),
                          FormField<String>(
                              initialValue: '',
                              validator: null,
                              builder: (field) {
                              return DocumentPicker(
                                  radius: 10,
                                  networkImage: null,
                                  renderHeight: Get.width * 0.35,
                                  renderWidth: Get.width * 0.8,
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
                                  actionWord: "Upload Cover Photo"
                              );
                            }
                          ),
                          SizedBox(height: Get.height*0.025),
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