import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:wayagram/app/global_widgets/overlays.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../data/providers/api_response.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/date_button.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

class CreatePoll extends StatelessWidget {
  const CreatePoll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    var isTextPoll = false;
    var pos = 0;

    var option = "";
    var description = "";
    List<String> options = [];
    List<String> images = [];
    List<String> descriptions = [];

    var formKey1 = GlobalKey<FormState>();
    var formKey2 = GlobalKey<FormState>();
    var formKey3 = GlobalKey<FormState>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeControllerWayagram>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Create Poll', style: AppTextStyle.subtitle1.copyWith(
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
                    title: pos == 0 ? 'Next' : 'Post',
                    onPressed: () async {
                      if(pageController.page?.toInt() == 0 && formKey1.currentState!.validate()) {
                        pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                        pos = 1;
                        controller.update();
                      } else {
                        if(formKey2.currentState!.validate()) {
                          var body = {
                            'description': titleController.text,
                            "type": "user",
                            "page_id": null,
                            "group_id": null,
                            "parent_id": null,
                            "pollCategory": "text",
                            "showResult": true,
                            "schedule": true,
                            "millisecCreatedAt": "0",
                            "millisecUpdatedAt": "0",
                            "isPaid": false,
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
                          var response = await controller.postData(body, "/wayagram-service/all-posts/poll-create");
                          if(response.isSuccessful){
                            var id = response.data['id'] as String;
                            ApiResponse? innerResponse;
                            for (var element in options) {
                              var innerBody = {
                                'pollId': id,
                                "option": element,
                                "position": options.indexOf(element)+1,
                              };
                              if(descriptions[options.indexOf(element)].isNotEmpty){
                                innerBody['short_desc'] = descriptions[options.indexOf(element)];
                              }
                              innerResponse = await controller.postData(innerBody, "/wayagram-service/all-posts/poll-option-create");
                              if(innerResponse.isSuccessful) {
                                if(options.indexOf(element) == options.length - 1) {
                                  await controller.getPosts;
                                  controller.update(['home']);
                                  Get.back();
                                }
                              } else {
                                AppOverlay.showInfoDialog(title: 'Error', content: innerResponse.message);
                                break;
                              }
                            }
                          }else{
                            AppOverlay.showInfoDialog(title: 'Error', content: response.message);
                          }
                        }
                      }
                    },
                    borderRadius: 10,
                    fontColor: AppColors.button,
                    bckgrndColor: AppColors.background,
                    width: Get.width * 0.2,
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
                                        startDateController.text = '${date.day}/${date.month}/${date.year}';
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
                                        endDateController.text = '${date.day}/${date.month}/${date.year}';
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
                                    }else if(options.length < 2){
                                      return 'Please add at least 2 poll options below';
                                    }
                                    return null;
                                  },
                                  isCompulsory: true,
                                  controller: titleController,
                                ),
                              ),
                              SizedBox(height: Get.height*0.025),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Form(
                                    key: formKey3,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: Get.width*0.8,
                                          child: PageInput(
                                            hint: '',
                                            label: 'Add Poll Option',
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Please enter your question';
                                              }else if(options.contains(val)){
                                                return 'This option already exists';
                                              }
                                              return null;
                                            },
                                            isCompulsory: true,
                                            onChanged: (val) {
                                              option = val;
                                            },
                                            controller: questionController,
                                          ),
                                        ),
                                        SizedBox(height: Get.height*0.025),
                                        SizedBox(
                                          width: Get.width*0.8,
                                          child: PageInput(
                                            hint: '',
                                            label: 'Enter Description',
                                            validator: (val){
                                              return null;
                                            },
                                            isCompulsory: false,
                                            onChanged: (val) {
                                              description = val;
                                            },
                                            controller: descriptionController,
                                          ),
                                        ),
                                        if(!isTextPoll)
                                          AppButton(
                                              title: "Choose File",
                                            width: Get.width*0.8,
                                          )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: (){
                                        if(options.length < 31){
                                          if(formKey3.currentState!.validate()){
                                            options.add(option);
                                            descriptions.add(description);

                                            option = '';
                                            description = '';

                                            questionController.clear();
                                            descriptionController.clear();
                                            controller.update();
                                          }
                                        } else {
                                          Get.snackbar('Poll Limit Reached', 'You can only add 10 options',backgroundColor: AppColors.primary);
                                        }
                                      },
                                      icon: Center(child: Icon(Icons.add_circle_outline, color: AppColors.primary, size: Get.width*0.065)),
                                  )
                                ],
                              ),
                              SizedBox(height: Get.height*0.025),
                              SizedBox(height: Get.height*0.025),
                              SizedBox(
                                height: Get.height*0.5,
                                child: ListView.builder(
                                  itemCount: options.length,
                                  //physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  //shrinkWrap: true,
                                  itemBuilder: (context, index){
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: Get.width*0.8,
                                              child: PageInput(
                                                hint: options[index],
                                                label: '',
                                                validator: (val){
                                                  return null;
                                                },
                                                isCompulsory: false,
                                                readOnly: true,
                                                hintColor: Colors.black,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: (){
                                                  options.removeAt(index);
                                                  descriptions.removeAt(index);
                                                  controller.update();
                                                },
                                                icon: Center(child: Icon(Icons.remove_circle_outline_rounded, color: Colors.black, size: Get.width*0.055))
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: Get.width*0.025),
                                          child: Text(descriptions[index], style: TextStyle(fontSize: Get.width*0.035, fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    );
                                  },
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