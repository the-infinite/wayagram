import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/home_controller.dart';
import '../../data/model/full_user_profile_entity.dart';
import '../../data/providers/my_pref.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/date_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/overlays.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';
import 'package:dio/dio.dart' as dio;


class CreateDonation extends StatefulWidget {
  const CreateDonation({Key? key}) : super(key: key);

  @override
  State<CreateDonation> createState() => _CreateDonationState();
}

class _CreateDonationState extends State<CreateDonation> {
  var currentPage = 0;
  var pageController = PageController(initialPage: 0);
  var formKey1 = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var organizerController = TextEditingController();
  var descriptionController = TextEditingController();
  var tagsController = TextEditingController();
  var descriptionOfCauseController = TextEditingController();
  var descriptionOfSolutionController = TextEditingController();
  var tellUsMoreAboutYouController = TextEditingController();

  var targetController = TextEditingController();
  var minimumAmountController = TextEditingController(text: '500');

  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay endTime = const TimeOfDay(hour: 23, minute: 59);

  var hideContributions = false;
  var hideDonors = false;

  var startTimeController = TextEditingController();
  var startDateController = TextEditingController();
  var endTimeController = TextEditingController();
  var endDateController = TextEditingController();

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
      child: GetBuilder<HomeControllerWayagram>(id: "create_donation",builder: (controller) {
        var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Create Donation', style: AppTextStyle.subtitle1.copyWith(
              color: const Color(0xff4F4F4F),
              fontSize: Get.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, color: Colors.black),
                onPressed: () {
                  if(currentPage > 0){
                    pageController.animateToPage(currentPage-1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                    currentPage--;
                    controller.update();
                  }else{
                    Navigator.pop(context);
                  }
                },
            ),
            actions: [
              Center(
                child: SizedBox(
                  child: AppButton(
                    title: currentPage == 3 ? 'Create' : 'Next',
                    onPressed: () async {
                      if(formKey1.currentState!.validate()) {
                        if(currentPage < 3){
                          pageController.animateToPage(currentPage+1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                          currentPage++;
                          controller.update(['create_donation']);
                        }else{
                          bool create = true;
                          await AppOverlay.showDeviceDialog(
                            title: "Payment Information",
                            content: "Waya will take a commission from the payment and the rest of the money will be paid into your account at the end of post duration or its expiry date.",
                            onPositivePressed: () {
                              create = true;
                            },
                            onNegativePressed: () {
                              create = false;
                            },
                          );
                          if(create){
                            var body = {
                              "profile_id":fullProfile.id,
                              "title": titleController.text,
                              "description":descriptionController.text,
                              "amountJustification":tellUsMoreAboutYouController.text,
                              "impact": "${descriptionOfCauseController.text} ${descriptionOfSolutionController.text}",
                              "ownerDescription": "${descriptionOfCauseController.text} ${descriptionOfSolutionController.text}",
                              "estimatedAmount":targetController.text,
                              "displayTotalDonation": !hideContributions,
                              "minimumAmount":minimumAmountController.text,
                              "displayNumberOfDonors":!hideDonors,
                              "donationExpiresAt":endDate.millisecondsSinceEpoch,
                            };

                            body['donationImage'] = await dio.MultipartFile.fromFile(
                              controller.imagePaths[1],
                              filename: controller.imagePaths[1].split('/').last,
                            );

                            var formData = dio.FormData.fromMap(body);
                            var response = await controller.postData(formData, "/wayagram-service/all-posts/create-donation",updatePages: false);
                            if(response.isSuccessful || response.message.toString().trim().toLowerCase() == "WAYAGram donation created successfully".toLowerCase()){
                              await controller.getPosts;
                              controller.update(['profile_page','home_tab','home']);
                              Get.back();
                              AppOverlay.showSuccessSnackBar(content: "Donation Created Successfully");
                            }else{
                              AppOverlay.showErrorSnackBar(content: "An Error Occurred, Please try again later");
                            }
                          }
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
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(0.5),
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.grey,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width*0.03, vertical: 0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey1,
                child: SizedBox(
                  height: Get.height * 0.8,
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        key: const Key('page1'),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: Get.height*0.025),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.005),
                            child: Text('Donation Information', style: AppTextStyle.subtitle1.copyWith(
                              color: Colors.black,
                              fontSize: Get.width*0.05,
                              fontWeight: FontWeight.w600,
                            )),
                          ),
                          SizedBox(height: Get.height*0.01),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.005),
                            child: Text('Give your cause a title and description so users can relate', style: AppTextStyle.subtitle1.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: Get.width*0.04,
                              fontWeight: FontWeight.normal,
                            )),
                          ),
                          SizedBox(height: Get.height*0.04),
                          PageInput(
                            hint: 'What is the cause you are fundraising for?',
                            label: 'Title of Cause',
                            validator: (val){
                              if(val!.isEmpty){
                                return 'Please enter a title for this donation request';
                              }else if(val.length <= 1){
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: titleController,
                          ),
                          SizedBox(height: Get.height*0.025),
                          /*PageInput(
                            hint: 'Who is organizing this donation?',
                            label: 'Organizer’s name',
                            validator: Validator.fullnameValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: organizerController,
                          ),
                          SizedBox(height: Get.height*0.025),*/
                          PageInput(
                            hint: 'Tell people why they should donate to this cause?',
                            label: 'Description',
                            validator: Validator.textValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: descriptionController,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageInput(
                            hint: 'e.g. #schoolfees, #medical, #food, #clothing',
                            label: 'Tags',
                            keyboardType: TextInputType.name,
                            isCompulsory: false,
                            controller: tagsController,
                          ),
                        ],
                      ),
                      Column(
                        key: const Key('page2'),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: Get.height*0.025),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.005),
                            child: Text('More Information', style: AppTextStyle.subtitle1.copyWith(
                              color: Colors.black,
                              fontSize: Get.width*0.05,
                              fontWeight: FontWeight.w600,
                            )),
                          ),
                          SizedBox(height: Get.height*0.01),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.005),
                            child: Text('Describe your case and state reasons why any user should donate to you', style: AppTextStyle.subtitle1.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: Get.width*0.04,
                              fontWeight: FontWeight.normal,
                            )),
                          ),
                          SizedBox(height: Get.height*0.04),
                          PageInput(
                            hint: 'What is the reason behind this donation?',
                            label: 'Description of Cause',
                            validator: Validator.textValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: descriptionOfCauseController,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageInput(
                            hint: 'How will this donation Solve the above problem?',
                            label: 'Description of Solution',
                            validator: Validator.textValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: descriptionOfSolutionController,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageInput(
                            hint: 'Tell us more about yourself',
                            label: 'Why should user donate to you?',
                            validator: Validator.textValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: tellUsMoreAboutYouController,
                          ),
                        ],
                      ),
                      Column(
                        key: const Key('page3'),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: Get.height*0.025),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.005),
                            child: Text('Other Details', style: AppTextStyle.subtitle1.copyWith(
                              color: Colors.black,
                              fontSize: Get.width*0.05,
                              fontWeight: FontWeight.w600,
                            )),
                          ),
                          SizedBox(height: Get.height*0.01),
                          Padding(
                            padding: EdgeInsets.only(left: Get.width*0.005),
                            child: Text('Complete your donation post process', style: AppTextStyle.subtitle1.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: Get.width*0.04,
                              fontWeight: FontWeight.normal,
                            )),
                          ),
                          SizedBox(height: Get.height*0.04),
                          PageInput(
                            hint: 'How much are you trying to raise?',
                            label: 'Target',
                            validator: Validator.moneyValidation,
                            keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                            isCompulsory: true,
                            controller: targetController,
                          ),
                          SizedBox(height: Get.height*0.025),
                          PageDropButton(
                            label: "Hide or display contributions in real time",
                            hint: '',
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            onChanged: (val) {
                              hideContributions = val == "Hide Contributions";
                            },
                            value: "Hide Contributions",
                            items: ["Hide Contributions","Show Contributions"].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: Get.height*0.025),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DateButton<DateTime>(
                                label: 'Start Date',
                                date: DateTime.now(),
                                initialValue: DateTime.now(),
                                validator: (date){
                                  if(date == null){
                                    return 'Required';
                                  }
                                  startDateController.text = DateFormat.yMMMd().format(date);
                                  return null;
                                },
                                dateChanged: (date) {
                                  startDate = date;
                                  startDateController.text = DateFormat.yMMMd().format(date);
                                },
                              ),
                              DateButton<TimeOfDay>(
                                label: 'Start Time',
                                time: TimeOfDay.now(),
                                initialValue: TimeOfDay.now(),
                                validator: (date){
                                  if(date == null){
                                    return 'Required';
                                  }
                                  startTimeController.text = "${date.hourOfPeriod}:${date.minute}  ${date.period == DayPeriod.am
                                      ? 'AM'
                                      : 'PM'}";
                                  return null;
                                },
                                timeChanged: (time) {
                                  startTime = time;
                                  startTimeController.text = "${time.hourOfPeriod}:${time.minute}  ${time.period == DayPeriod.am
                                      ? 'AM'
                                      : 'PM'}";
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height*0.025),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DateButton<DateTime>(
                                label: 'End Date',
                                date: DateTime.now().add(const Duration(days: 1)),
                                initialValue: DateTime.now(),
                                validator: (date){
                                  if(date == null){
                                    return 'Required';
                                  }
                                  endDateController.text = DateFormat.yMMMd().format(date);
                                  return null;
                                },
                                dateChanged: (date) {
                                  endDate = date;
                                  endDateController.text = DateFormat.yMMMd().format(date);
                                },
                              ),
                              DateButton<TimeOfDay>(
                                label: 'End Time',
                                time: const TimeOfDay(hour: 23, minute: 59),
                                initialValue: const TimeOfDay(hour: 23, minute: 59),
                                validator: (date){
                                  if(date == null){
                                    return 'Required';
                                  }
                                  endTimeController.text = "${date.hourOfPeriod} : ${date.minute}  ${date.period == DayPeriod.am
                                      ? 'AM'
                                      : 'PM'}";
                                  return null;
                                },
                                timeChanged: (time) {
                                  endTime = time;
                                  endTimeController.text = "${time.hourOfPeriod} : ${time.minute}  ${time.period == DayPeriod.am
                                      ? 'AM'
                                      : 'PM'}";
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height*0.025),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width*0.45,
                                child: PageInput(
                                  hint: 'Minimum amount a user can donate',
                                  label: 'Minimum amount a \nuser can donate',
                                  validator: Validator.moneyValidation,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                  isCompulsory: true,
                                  controller: minimumAmountController,
                                ),
                              ),
                              SizedBox(
                                width: Get.width*0.45,
                                child: PageDropButton(
                                  label: "Hide or display donors \nname in real time",
                                  hint: '',
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  onChanged: (val) {
                                    hideDonors = val == "Hide Donors";
                                  },
                                  value: "Hide Donors",
                                  items: ["Hide Donors","Show Donors"].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        key: const Key('page4'),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height*0.025),
                          //Padding(padding: EdgeInsets.only(left: Get.width*0.015,bottom: 5), child: Text('Event Image', style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(.7)),)),
                          FormField<String>(
                              initialValue: '',
                              validator: (val){
                                if(controller.imagePaths.isEmpty){
                                  return "Please select an image";
                                }
                                return null;
                              },
                              builder: (field) {
                                return Column(
                                  children: [
                                    DocumentPicker(
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
                                            CropAspectRatioPreset.ratio3x2,
                                            CropAspectRatioPreset.original,
                                            CropAspectRatioPreset.ratio16x9
                                          ],
                                          uiSettings: [
                                            AndroidUiSettings(
                                                toolbarTitle: 'Crop Event Photo',
                                                toolbarColor: AppColors.background,
                                                toolbarWidgetColor: Colors.black,
                                                activeControlsWidgetColor: AppColors.primary,
                                                cropGridColor: AppColors.primary,
                                                initAspectRatio: CropAspectRatioPreset.original,
                                                lockAspectRatio: true),
                                            IOSUiSettings(
                                              title: 'Crop Cover Photo',
                                              aspectRatioLockEnabled: true,
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
                                      fit: BoxFit.cover,
                                    ),
                                    if(field.hasError)
                                      Padding(
                                        padding: EdgeInsets.only(top: Get.height*0.01),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: Get.width*0.01,
                                            ),
                                            Text(
                                              field.errorText.toString(),
                                              style: AppTextStyle.subtitle1.copyWith(
                                                color: Colors.red,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              }
                          ),
                          SizedBox(height: Get.height*0.05),
                          _TextButton(
                            title: 'Donation Name:',
                            text: titleController.text,
                            onPressed: () {
                            },
                          ),
                          SizedBox(height: Get.height*0.01),
                          /*_TextButton(
                            title: 'Organizer Name:',
                            text: organizerController.text,
                            onPressed: () {
                            },
                          ),
                          SizedBox(height: Get.height*0.01),*/
                          _TextButton(
                            title: 'Target:',
                            text: targetController.text,
                            onPressed: () {
                            },
                          ),
                          SizedBox(height: Get.height*0.01),
                         /* _TextButton(
                            title: 'Minimum Amount:',
                            text: minimumAmountController.text,
                            onPressed: () {
                            },
                          ),
                          SizedBox(height: Get.height*0.01),*/
                          _TextButton(
                            title: 'Description:',
                            text: descriptionController.text,
                            onPressed: () {
                            },
                          ),
                          SizedBox(height: Get.height*0.01),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: (){
              controller.launchURL("https://wayagram.ng/terms");
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10,),
                Text(
                  "By creating, you agree with our terms and conditions \nof donation creation",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: Get.textScaleFactor * 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String title;
  final String text;
  final Function() onPressed;
  const _TextButton({required this.text, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.height*0.018),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: AppTextStyle.subtitle1.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: Get.width*0.04),
          ),

              SizedBox(
                width: Get.width*0.6,
                child: Text(
                  text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.subtitle1.copyWith(color: Colors.black,fontSize: Get.width*0.04),
                  textAlign: TextAlign.end,
                ),
              )
        ]),
      ),
    );
  }
}