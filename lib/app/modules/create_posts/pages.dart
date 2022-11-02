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

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pos = 0;
    var pageController = PageController();
    var formKey1 = GlobalKey<FormState>();
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
            title: Text('Create Page', style: AppTextStyle.subtitle1.copyWith(
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
                          ),
                          SizedBox(height: Get.height * 0.025),
                          PageDropButton(
                            label: "Page Category",
                            hint: '',
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            onChanged: (val) {
                              //controller.businessType.value = val!;
                            },
                            value: "Catering and Food",
                            items: businessList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(value),
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
                              return null;
                            },
                            isCompulsory: false,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageInput(
                            hint: '',
                            label: 'Website',
                            validator: (val){
                              return null;
                            },
                            isCompulsory: false,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageDropButton(
                            label: "Page Visibility",
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
                          SizedBox(height: Get.height*0.025),
                          Padding(padding: EdgeInsets.only(left: Get.width*0.015,bottom: 5), child: Text('Page Profile Photo [Optional]', style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.7)),)),
                          DocumentPicker(
                              radius: 10,
                              networkImage: null,
                              renderHeight: Get.width * 0.35,
                              renderWidth: Get.width * 0.35,
                              controller: controller,
                              onSelected: (imagePath, base64Image) async {
                                /*CroppedFile? croppedFile = await ImageCropper().cropImage(
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
                                        toolbarTitle: 'Crop ID Photo',
                                        toolbarColor: AppColors.primary,
                                        toolbarWidgetColor: Colors.white,
                                        activeControlsWidgetColor: AppColors.primary,
                                        cropGridColor: AppColors.primary,
                                        initAspectRatio: CropAspectRatioPreset.original,
                                        lockAspectRatio: false),
                                    IOSUiSettings(
                                      title: 'Crop ID Photo',
                                    ),
                                    WebUiSettings(
                                      context: context,
                                    ),
                                  ],
                                );
                                if(croppedFile == null){
                                  //controller.onPassportSelected(imagePath);
                                 // field.didChange(imagePath);
                                }else{
                                  //controller.onPassportSelected(croppedFile.path);
                                  //field.didChange(croppedFile.path);
                                }*/
                              },
                              actionWord: "Upload Photo"
                          ),
                          SizedBox(height: Get.height*0.025),
                          Padding(padding: EdgeInsets.only(left: Get.width*0.015,bottom: 5), child: Text('Page Cover Photo [Optional]', style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.7)),)),
                          DocumentPicker(
                              radius: 10,
                              networkImage: null,
                              renderHeight: Get.width * 0.35,
                              renderWidth: Get.width * 0.8,
                              controller: controller,
                              onSelected: (imagePath, base64Image) async {
                                /*CroppedFile? croppedFile = await ImageCropper().cropImage(
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
                                        toolbarTitle: 'Crop ID Photo',
                                        toolbarColor: AppColors.primary,
                                        toolbarWidgetColor: Colors.white,
                                        activeControlsWidgetColor: AppColors.primary,
                                        cropGridColor: AppColors.primary,
                                        initAspectRatio: CropAspectRatioPreset.original,
                                        lockAspectRatio: false),
                                    IOSUiSettings(
                                      title: 'Crop ID Photo',
                                    ),
                                    WebUiSettings(
                                      context: context,
                                    ),
                                  ],
                                );
                                if(croppedFile == null){
                                  //controller.onPassportSelected(imagePath);
                                 // field.didChange(imagePath);
                                }else{
                                  //controller.onPassportSelected(croppedFile.path);
                                  //field.didChange(croppedFile.path);
                                }*/
                              },
                              actionWord: "Upload Photo"
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