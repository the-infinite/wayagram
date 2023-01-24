import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import 'package:dio/dio.dart' as dio;

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/group_model_entity.dart';
import '../../../data/model/page_categories_model.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_button.dart';
import '../../../global_widgets/document_picker.dart';
import '../../../global_widgets/overlays.dart';
import '../../../global_widgets/page_dropdown.dart';
import '../../../global_widgets/page_input.dart';

class EditGroup extends StatelessWidget {
  const EditGroup({Key? key, required this.editInfo}) : super(key: key);

  final GroupModelEntity editInfo;

  @override
  Widget build(BuildContext context) {
    var businessList = [
      'Catering and Food',
      'Cakes and Pastries',
      'Event Planning',
      'Music and DJ',
      'Photography and Videography',
      'Makeup and Hair',
      'Decorations',
      'Health and Skin Care',
      'Fashion and Accessories',
      'Clothing, Accessories and Shoes',
      'Computers and Accessories',
      'Electronics and Accessories',
      'Transportation',
      'Church',
      'Mosque',
      'School',
      'Hospital',
      'Hotel',
      'Bar and Lounge',
      'Beauty Salon',
      'Barber Shop',
      'Gym',
      'Fitness Center',
      'Sports Club',
      'E-commerce',
      'Consulting',
      'Manufacturer',
      'Wholesaler',
      'Retailer',
      'Distributor',
      'Importer',
      'Exporter',
      'Others'
    ];

    var isPrivate = false;
    var formKey = GlobalKey<FormState>();
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var usernameController = TextEditingController(text: fullProfile.username);
    var displayNameController = TextEditingController(text: fullProfile.displayName);
    var bioController = TextEditingController(text: fullProfile.bio);

    var private = fullProfile.notPublic;
    var nameController = TextEditingController(text: editInfo.name);
    var categoryController = TextEditingController(text: editInfo.category);
    var categoryIDController = TextEditingController(text: editInfo.categoryId.toString());
    var otherCategory = TextEditingController(text: editInfo.customCategory.toString());
    var descriptionController = TextEditingController(text: editInfo.description);
    var publicController = TextEditingController(text: editInfo.isPublic == true ? 'Public' : 'Private');
    var muteController = TextEditingController(text: editInfo.mute == true ? 'UnMute' : 'Mute');

    PageCategoriesModel? formerCategory;

    return  GetBuilder<HomeControllerWayagram>(
        builder: (controller) {
          List<PageCategoriesModel> categories = [];
          if(MyPref.groupCategories.val.isNotEmpty){
            categories = PageCategoriesModel.listFromJson(jsonDecode(MyPref.groupCategories.val));
            formerCategory = categories.firstWhereOrNull((element) => element.title == editInfo.category);
          }
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
                title: Text('Edit Group', style: AppTextStyle.subtitle1.copyWith(
                  color: Colors.black,
                )),
                centerTitle: false,
                actions: [
                  Center(
                    child: SizedBox(
                      child: AppButton(
                        title: 'Save',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Map<String, dynamic> body = {
                              "userId": fullProfile.id,
                              "groupId": editInfo.id,
                              "mute": editInfo.mute == true ? "true" : "false",
                              "category": categoryController.text,
                              "name": nameController.text,
                              "customCategory": categoryController.text.toLowerCase().trim() == 'others' ? otherCategory.text : "undefined",
                              "description": descriptionController.text,
                              "isPublic": publicController.text == 'Public' ? "true" : "false",
                            };
                            // if(linkController.text.isNotEmpty) {
                            //    body['websiteUrl'] = linkController.text;
                            //   }
                            if(controller.image1.isNotEmpty){
                              body['headerImage'] = await dio.MultipartFile.fromFile(
                                controller.image1,
                                filename: controller.image1.split('/').last,
                              );
                            }

                            if(controller.image2.length > 1){
                              body['image'] = await dio.MultipartFile.fromFile(
                                controller.image2,
                                filename: controller.image2.split('/').last,
                              );
                            }

                            var formData = dio.FormData.fromMap(body);
                            var response = await controller.putData(formData, "wayagram-service/main/group/update-group");
                            if(response.isSuccessful){
                              var newRes = await controller.getData("/wayagram-service/main/group/get-all-user-created-groups?pageNumber=1&userId=${fullProfile.id}", true);
                              if(newRes.isSuccessful){
                                var savedPosts = ReadWriteValue('wayagram_created_groups', '', MyPref.box);
                                final posts = GroupModelEntity.getService(response.groups);
                                savedPosts.val = jsonEncode(posts);
                              }
                              await Future.delayed(const Duration(seconds: 1));
                              controller.update(['group_screen']);
                              controller.update();
                              Get.back();
                            }else{
                              AppOverlay.showInfoDialog(title: 'Error', content: response.message);
                            }
                          }
                        },
                        borderRadius: 10,
                        fontColor: AppColors.primary,
                        bckgrndColor: getAppColor(AppColors.background),
                        border: Border.all(color: getAppColor(AppColors.background), width: 1),
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        width: Get.width * 0.2,
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
                                  networkImage: editInfo.headerImageUrl,
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
                                      controller.image1 = imagePath;
                                      field.didChange(imagePath);
                                    }else{
                                      controller.image1 = croppedFile.path;
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
                                    networkImage: editInfo.imageUrl,
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
                                        controller.image2 = imagePath;
                                        field.didChange(imagePath);
                                      }else{
                                        controller.image2 = croppedFile.path;
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
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            PageInput(
                              hint: '',
                              label: 'Name',
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Please a name';
                                }else if(val.length < 2){
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: nameController,
                            ),
                            SizedBox(
                              height: Get.height * 0.025,
                            ),
                            PageDropButton(
                              label: "Group Category",
                              hint: 'Choose a category',
                              isCompulsory: true,
                              onChanged: (value) {
                                var val = value as PageCategoriesModel;
                                for (var element in categories) {
                                  if(element == val){
                                    categoryController.text = element.title.toString();
                                    categoryIDController.text = element.id.toString();
                                    controller.update();
                                    break;
                                  }
                                }
                              },
                              validator: (val){
                                if(categoryController.text.isEmpty){
                                  return 'Please choose a category';
                                }
                                return null;
                              },
                              value: formerCategory,
                              items: categories.map<DropdownMenuItem<PageCategoriesModel>>((PageCategoriesModel value){
                                return DropdownMenuItem<PageCategoriesModel>(
                                  value: value,
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
                            if(categoryController.text.toLowerCase().trim() == "others")
                              PageDropButton(
                                label: "Other Category",
                                hint: '',
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                onChanged: (val) {
                                  otherCategory.value = val!;
                                },
                                value: "Catering and Food",
                                items: businessList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            if(categoryController.text.toLowerCase().trim() == "others")
                              SizedBox(height: Get.height*0.025),
                            PageInput(
                              hint: '',
                              label: 'Description',
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                              isCompulsory: true,
                              controller: descriptionController,
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
                                publicController.text = val!;
                              },
                              value: publicController.text,
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
