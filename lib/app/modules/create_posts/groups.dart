import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/page_categories_model.dart';
import '../../data/model/profile_model_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

import 'package:dio/dio.dart' as dio;

class CreateGroup extends StatefulWidget {
  CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  var homeController = Get.find<HomeControllerWayagram>();
  var currentPage = 0;
  var pageController = PageController();
  var formKey1 = GlobalKey<FormState>();

  var groupNameController = TextEditingController();
  var groupDescriptionController = TextEditingController();
  var privacyController = TextEditingController(text: 'Public');
  var inviteController = TextEditingController();

  var pageCategory = TextEditingController();
  var otherCategory = TextEditingController(text: 'Catering and Food');
  PageCategoriesModel? chosenCategory;

  var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));


  @override
  void initState() {
    super.initState();
    homeController.userRepo.getFullUserProfile(homeController.profile.userId.toString()).then((value) {
      if(value.isSuccessful){
        homeController.userRepo.getGroupCategories().then((value) {
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: getAppColor(AppColors.background),
          statusBarIconBrightness: getAppBrightness(),
          statusBarBrightness: getAppBrightness(),
          systemNavigationBarColor: getAppColor(AppColors.background),
          systemNavigationBarIconBrightness: getAppBrightness()
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        List<PageCategoriesModel> categories = [];
        if(MyPref.groupCategories.val.isNotEmpty){
          categories = PageCategoriesModel.listFromJson(jsonDecode(MyPref.groupCategories.val));
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: getAppColor(AppColors.background),
            title: Text('Create Group', style: AppTextStyle.subtitle1.copyWith(
              color: getAppColor(Color(0xff4F4F4F)),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(FeatherIcons.arrowLeft, color: Colors.black),
              onPressed: (){
                if(currentPage == 1){
                  pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                  currentPage = 0;
                  controller.update();
                }else{
                  Navigator.pop(context);
                }
              },
            ),
            actions: [
              Center(
                child: AppButton(
                  title: currentPage == 0 ? 'Next' : 'Create',
                  onPressed: () async {
                    if(currentPage == 0){
                      if(formKey1.currentState!.validate()) {
                        pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                        currentPage = 1;
                        controller.update();
                      }
                    }else{
                      Map<String, dynamic> body = {
                        "userId": fullProfile.id,
                        "category": chosenCategory!.title,
                        "customCategory": chosenCategory!.title!.toLowerCase().trim() == 'others' ? otherCategory.text : "undefined",
                        "name": groupNameController.text,
                        "description": groupDescriptionController.text,
                        "isPublic": privacyController.text == 'Public',
                      };

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
                      var response = await controller.postData(formData, "wayagram-service/main/group/create-group");
                      if(response.isSuccessful){
                        await controller.getSuggestedGroups;
                        controller.update(['home']);
                        Get.back();
                        AppOverlay.showSuccessSnackBar(content: 'Group created successfully');
                      }else{
                        AppOverlay.showErrorSnackBar(title: 'Error', content: response.message ?? 'An error occurred');
                      }
                    }
                  },
                  borderRadius: 10,
                  fontColor: AppColors.button,
                  bckgrndColor: getAppColor(AppColors.background),
                  border: Border.all(color: getAppColor(AppColors.background), width: 1),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  width: Get.width * 0.2,
                ),
              )
            ],
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: getAppColor(AppColors.background),
                statusBarIconBrightness: getAppBrightness(),
                statusBarBrightness: getAppBrightness(),
                systemNavigationBarColor: getAppColor(AppColors.background),
                systemNavigationBarIconBrightness: getAppBrightness()
            ),
          ),
          body: Column(
            children: [
              Divider(
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
                        physics: NeverScrollableScrollPhysics(),
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
                                PageInput(
                                  hint: 'Describe your group',
                                  label: 'Group Description',
                                  validator: (val){
                                    if(val!.isEmpty){
                                      return 'Please enter a group description';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  isCompulsory: true,
                                  controller: groupDescriptionController,
                                ),
                                SizedBox(height: Get.height*0.025),
                                PageDropButton(
                                  label: "Group Category",
                                  hint: 'Choose a category',
                                  isCompulsory: true,
                                  onChanged: (value) {
                                    for (var element in categories) {
                                      if(element.id == value){
                                        pageCategory.text = element.title.toString();
                                        chosenCategory = element;
                                        controller.update();
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
                                if(pageCategory.text.toLowerCase().trim() == "others")
                                  PageDropButton(
                                    label: "Other Category",
                                    hint: '',
                                    padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
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
                                if(pageCategory.text.toLowerCase().trim() == "others")
                                  SizedBox(height: Get.height*0.025),
                                PageDropButton(
                                  label: "Choose Privacy",
                                  hint: '',
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                /*PageInput(
                                  hint: 'e.g. John Doe',
                                  label: 'Who do you want to invite?',
                                  validator: (val){
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  isCompulsory: false,
                                  controller: inviteController,
                                ),*/
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