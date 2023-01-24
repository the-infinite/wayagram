import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/app/global_widgets/overlays.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/providers/api_response.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/date_button.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

import 'package:dio/dio.dart' as dio;


class CreatePoll extends StatefulWidget {
  const CreatePoll({Key? key}) : super(key: key);

  @override
  State<CreatePoll> createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll> {
  final ImagePicker _imagePicker = ImagePicker();

  var pageController = PageController();
  var votesController = TextEditingController(text: '1');
  var chargeController = TextEditingController(text: '0');

  var startTimeController = TextEditingController();
  var startDateController = TextEditingController();
  var endTimeController = TextEditingController();
  var endDateController = TextEditingController();

  var titleController = TextEditingController();
  var questionController = TextEditingController();
  var descriptionController = TextEditingController();
  var isTextPoll = true;
  var pos = 0;

  List<TextEditingController> allTextOptions = [];
  List<String> images = [];
  List<String> descriptions = [];

  var formKey1 = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var formKey3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Create Poll', style: AppTextStyle.subtitle1.copyWith(
                  color: getAppColor(const Color(0xff4F4F4F)),
                  fontSize: Get.textScaleFactor * 18,
                  fontWeight: FontWeight.bold,
                )),
                if(controller.groupToPost != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'To Group: ',
                        style: TextStyle(
                          color: getAppColor(const Color(0xff4F4F4F)),
                          fontSize: Get.textScaleFactor * 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        controller.groupToPost!.name.toString(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: Get.textScaleFactor * 14,
                        ),
                      ),
                    ],
                  ),
                if(controller.pageToPost != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'To Page: ',
                        style: TextStyle(
                          color: getAppColor(const Color(0xff4F4F4F)),
                          fontSize: Get.textScaleFactor * 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        controller.pageToPost!.name.toString(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: Get.textScaleFactor * 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(FeatherIcons.arrowLeft, color: getAppColor(Colors.black)),
              onPressed: () {
                if(pageController.page?.toInt() == 1){
                  pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                  pos = 0;
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
                    title: pos == 0 ? 'Next' : 'Post',
                    onPressed: () async {
                      if(pageController.page?.toInt() == 0 && formKey1.currentState!.validate()) {
                        pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        pos = 1;
                        controller.update();
                      } else {
                        formKey2.currentState?.validate();
                        formKey3.currentState?.validate();
                        if(formKey2.currentState?.validate() == true && formKey3.currentState?.validate() == true) {
                          bool create = true;
                          if(int.parse(chargeController.text) > 0){
                            create = false;
                            await AppOverlay.showDeviceDialog(
                              title: "Payment Information",
                              content: "All paid votes will be credited into your Wayabank(default wallet) at the end of the post duration. A commission of total payment will be paid to Waya.",
                              onPositivePressed: () {
                               create = true;
                              },
                              onNegativePressed: () {
                                create = false;
                              },
                            );
                          }
                          if(create){
                            var body = {
                              'description': titleController.text,
                              "type": "user",
                              "page_id": controller.pageToPost == null ? null : controller.pageToPost!.id.toString(),
                              "group_id": controller.groupToPost == null ? null : controller.groupToPost!.id.toString(),
                              "parent_id": null,
                              "pollCategory": isTextPoll ? "text" : "image",
                              "showResult": true,
                              "schedule": true,
                              "millisecCreatedAt": "0",
                              "millisecUpdatedAt": "0",
                              "isPaid": int.parse(chargeController.text) > 0 ? true : false,
                              'startTime': startTimeController.text,
                              'startDate': startDateController.text,
                              'endTime': endTimeController.text,
                              'endDate': endDateController.text,
                              'voteLimit': votesController.text,
                              'amount': chargeController.text,
                              "hashtags": [

                              ],
                              "mentions": [

                              ]
                            };
                            if(controller.pageToPost != null){
                              body['type'] = "page";
                            }
                            if(controller.groupToPost != null){
                              body['type'] = "group";
                            }
                            var response = await controller.postData(body, "/wayagram-service/all-posts/poll-create");
                            if(response.isSuccessful){
                              var id = response.data['id'] as String;
                              ApiResponse? innerResponse;
                              for (var element in allTextOptions) {
                                var innerBody = {
                                  'pollId': id,
                                  "option": element.text,
                                  "position": allTextOptions.indexOf(element)+1,
                                };
                                /*if(descriptions[options.indexOf(element)].isNotEmpty){
                                innerBody['short_desc'] = descriptions[options.indexOf(element)];
                              }*/
                                if(isTextPoll){
                                  innerResponse = await controller.postData(innerBody, "/wayagram-service/all-posts/poll-option-create");
                                }else{
                                  innerBody['file'] = await dio.MultipartFile.fromFile(
                                    images[allTextOptions.indexOf(element)],
                                    filename: images[allTextOptions.indexOf(element)].split('/').last,
                                  );
                                  var formData = dio.FormData.fromMap(innerBody);
                                  innerResponse = await controller.postData(formData, "/wayagram-service/all-posts/poll-option-create");
                                }
                                if(innerResponse.isSuccessful) {
                                  if(allTextOptions.indexOf(element) == allTextOptions.length - 1) {
                                    await controller.getPosts;
                                    controller.update(['profile_page','home_tab','home','group_screen','page_screen']);
                                    Get.back();
                                    AppOverlay.showSuccessSnackBar(content: "Poll Created Successfully");
                                  }
                                } else {
                                  AppOverlay.showInfoDialog(title: 'Error', content: innerResponse.message);
                                  break;
                                }
                              }
                            }else{
                              AppOverlay.showErrorSnackBar(title: 'Error', content: response.message ?? "Something went wrong");
                            }
                          }
                        }
                      }
                    },
                    borderRadius: 10,
                    fontColor: AppColors.button,
                    bckgrndColor: getAppColor(AppColors.background),
                    width: Get.width * 0.2,
                    border: Border.all(color: getAppColor(AppColors.background), width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  ),
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
          body: Container(
            color: getAppColor(AppColors.background),
            child: Column(
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
                        height: Get.height * 0.9,
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
                                  PageDropButton(
                                    label: "Poll Category",
                                    hint: '',
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    onChanged: (val) {
                                      //controller.state.value = ;
                                      if(val.toString().contains('Text')) {
                                        isTextPoll = true;
                                      } else {
                                        isTextPoll = false;
                                      }
                                    },
                                    value: "Text Poll",
                                    items: ["Text Poll","Image Poll"].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: Get.height*0.025),
                                  PageInput(
                                    hint: '',
                                    label: 'Votes Per User',
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return 'Please enter your minimum vote number per user';
                                      }else if(int.tryParse(val) == null){
                                        return 'Please enter a valid number';
                                      }else if(int.parse(val) < 1){
                                        return 'Please enter a value greater than 0';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    isCompulsory: true,
                                    controller: votesController,
                                  ),
                                  SizedBox(height: Get.height*0.025),
                                  PageInput(
                                    hint: '',
                                    label: 'Charge Per Vote',
                                    validator: (val){
                                      if(int.tryParse(val.toString()) == null){
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                    isCompulsory: false,
                                    keyboardType: TextInputType.number,
                                    controller: chargeController,
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
                                          startDateController.text = '${date.month}/${date.day}/${date.year}';
                                          return null;
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
                                          startTimeController.text = Duration(hours: date.hour, minutes: date.minute).inMilliseconds.toString();
                                          return null;
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
                                          endDateController.text = '${date.month}/${date.day}/${date.year}';
                                          return null;
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
                                          endTimeController.text = Duration(hours: date!.hour, minutes: date.minute).inMilliseconds.toString();
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Get.height*0.025),
                                  PageDropButton(
                                    label: "Poll Visibility",
                                    hint: '',
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    onChanged: (val) {
                                      //controller.state.value = ;
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
                            Column(
                              children: [
                                SizedBox(height: Get.height*0.025),
                                Form(
                                  key: formKey2,
                                  child: PageInput(
                                    hint: '',
                                    label: 'Ask Your Question',
                                    validator: (val){
                                      if(val!.isEmpty){
                                        return 'Please enter your question';
                                      }else if(allTextOptions.length < 2){
                                        return 'Please add at least 2 poll options below';
                                      }
                                      return null;
                                    },
                                    isCompulsory: true,
                                    controller: titleController,
                                  ),
                                ),
                                SizedBox(height: Get.height*0.02),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: Get.width*0.02,bottom: Get.height*0.008),
                                      child: Text('Add Option', style: AppTextStyle.subtitle1.copyWith(
                                        color: getAppColor(const Color(0xff4F4F4F)),
                                        fontSize: Get.textScaleFactor * 14,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        if(allTextOptions.length < 31){
                                          var optionController = TextEditingController();
                                          allTextOptions.add(optionController);
                                          images.add("");
                                          controller.update();
                                        } else {
                                          Get.snackbar('Poll Limit Reached', 'You can only add 30 options',backgroundColor: AppColors.primary);
                                        }
                                      },
                                      icon: Center(child: Icon(Icons.add_circle_outline, color: AppColors.button, size: Get.width*0.055)),
                                    )
                                  ],
                                ),
                                SizedBox(height: Get.height*0.01),
                                Form(
                                  key: formKey3,
                                  child: Expanded(
                                    child: ListView.builder(
                                      itemCount: allTextOptions.length,
                                      padding: const EdgeInsets.all(0),
                                      itemBuilder: (context, index){
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: Get.height*0.02),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: PageInput(
                                                      hint: "Enter Option ${index+1}",
                                                      label: '',
                                                      validator: (val){
                                                        if(val!.isEmpty){
                                                          return 'Option ${index+1} cannot be empty';
                                                        }else if(images[index].isEmpty && !isTextPoll){
                                                          return 'Please add an image for Option ${index+1}';
                                                        }
                                                        return null;
                                                      },
                                                      isCompulsory: false,
                                                      controller: allTextOptions[index],
                                                      suffix: isTextPoll ? null : InkWell(
                                                        onTap: () async {
                                                          final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
                                                          if (pickedFile != null) {
                                                            images[index] = pickedFile.path;
                                                            controller.update();
                                                          }
                                                        },
                                                        child: Container(
                                                          width: Get.width*0.3,
                                                          decoration: BoxDecoration(
                                                            color: getAppColor(AppColors.background),
                                                            border: Border.all(color: const Color(0xFF828282)),
                                                            borderRadius: const BorderRadius.only(
                                                              bottomRight: Radius.circular(10),
                                                              topRight: Radius.circular(10),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Text(
                                                                images[index].isEmpty ? 'Pick Image' : images[index].split('/').last,
                                                                style: AppTextStyle.subtitle1.copyWith(
                                                                color: getAppColor(const Color(0xff4F4F4F)),
                                                                fontSize: Get.textScaleFactor * 12,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: Get.height*0.008),
                                                    child: IconButton(
                                                        onPressed: (){
                                                          allTextOptions.removeAt(index);
                                                          images.removeAt(index);
                                                          controller.update();
                                                        },
                                                        icon: Center(child: Icon(Icons.cancel_outlined, color: getAppColor(Colors.black), size: Get.width*0.055))
                                                    ),
                                                  )
                                                ],
                                              ),
                                              /*Padding(
                                                padding: EdgeInsets.only(left: Get.width*0.025),
                                                child: Text(allTextOptions[index].text, style: TextStyle(fontSize: Get.width*0.035, fontWeight: FontWeight.w400)),
                                              ),*/
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
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
          ),
          bottomNavigationBar: InkWell(
            onTap: (){
              controller.launchURL("https://wayagram.ng/terms");
            },
            child: Container(
              color: getAppColor(AppColors.background),
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
                    "By creating, you agree with our terms and conditions \nof poll creation",
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
          ),
        );
      }),
    );
  }
}

class PollModel {
  final String? question;
  final String? category;
  final String? votesPerUser;
  final String? chargePerVote;
  final String? startDate;
  final String? startTime;
  final String? endDate;
  final String? endTime;
  final String? visibility;
  final List<String>? options;
  final List<String>? descriptions;

  PollModel({
    this.question,
    this.category,
    this.votesPerUser,
    this.chargePerVote,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.visibility,
    this.options,
    this.descriptions
  });
}