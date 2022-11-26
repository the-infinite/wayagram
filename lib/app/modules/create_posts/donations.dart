import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../core/utils/validator.dart';
import '../../controllers/home_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

class CreateDonation extends StatelessWidget {
  const CreateDonation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentPage = 0;
    var pageController = PageController(initialPage: 2);
    var formKey1 = GlobalKey<FormState>();

    var titleController = TextEditingController();
    var organizerController = TextEditingController();
    var descriptionController = TextEditingController();
    var tagsController = TextEditingController();
    var descriptionOfCauseController = TextEditingController();
    var descriptionOfSolutionController = TextEditingController();
    var tellUsMoreAboutYouController = TextEditingController();


    var targetController = TextEditingController();
    var minimumAmountController = TextEditingController();

    DateTime startDate = DateTime.now();
    TimeOfDay startTime = TimeOfDay.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay endTime = const TimeOfDay(hour: 23, minute: 59);

    var hideContributions = false;
    var hideDonors = false;

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
            title: Text('Create Donation', style: AppTextStyle.subtitle1.copyWith(
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
                    title: currentPage == 3 ? 'Create' : 'Next',
                    onPressed: () async {
                      if(formKey1.currentState!.validate()) {
                        if(currentPage < 3){
                          pageController.animateToPage(currentPage+1, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                          currentPage++;
                          controller.update(['create_event']);
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
                          PageInput(
                            hint: 'Who is organizing this donation?',
                            label: 'Organizer’s name',
                            validator: Validator.fullnameValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: organizerController,
                          ),
                          SizedBox(height: Get.height*0.025),
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
                            child: Text('Describe your case and state reasons why any user should donate to you', style: AppTextStyle.subtitle1.copyWith(
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
                          PageInput(
                            hint: 'Who is organizing this donation?',
                            label: 'Organizer’s name',
                            validator: Validator.fullnameValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: organizerController,
                          ),
                          SizedBox(height: Get.height*0.025),
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
                            hint: 'Add tags to improve your discovery',
                            label: 'Tags',
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: tagsController,
                          ),
                        ],
                      ),
                      Column(
                        key: const Key('page4'),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: Get.height*0.025),
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
                          PageInput(
                            hint: 'Who is organizing this donation?',
                            label: 'Organizer’s name',
                            validator: Validator.fullnameValidation,
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: organizerController,
                          ),
                          SizedBox(height: Get.height*0.025),
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
                            hint: 'Add tags to improve your discovery',
                            label: 'Tags',
                            keyboardType: TextInputType.name,
                            isCompulsory: true,
                            controller: tagsController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}