import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/core/utils/validator.dart';

import '../../../../core/theme/app_styles.dart';
import '../../controllers/home_controller.dart';
import '../../global_widgets/app_button.dart';
import '../../global_widgets/date_button.dart';
import '../../global_widgets/document_picker.dart';
import '../../global_widgets/page_dropdown.dart';
import '../../global_widgets/page_input.dart';

class CreateEvent extends StatelessWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentPage = 0;
    var pageController = PageController(initialPage: 0);
    var formKey1 = GlobalKey<FormState>();

    var eventNameController = TextEditingController();
    var eventOrganizerController = TextEditingController();
    var privacyController = TextEditingController(text: 'Public');
    var tagsController = TextEditingController();

    var eventsTypeController = TextEditingController(text: "Physical");
    var locationController = TextEditingController();
    var freeOrPaidController = TextEditingController(text: "Free");
    var linkController = TextEditingController();

    var startTimeController = TextEditingController();
    var startDateController = TextEditingController();
    var endTimeController = TextEditingController();
    var endDateController = TextEditingController();

    DateTime startDate = DateTime.now();
    TimeOfDay startTime = TimeOfDay.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay endTime = const TimeOfDay(hour: 23, minute: 59);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: GetBuilder<HomeController>(id:'create_event',builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Create Event', style: AppTextStyle.subtitle1.copyWith(
              color: Colors.black,
            )),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(FeatherIcons.arrowLeft, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: AppColors.background,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark
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
                    fontColor: AppColors.primary,
                    bckgrndColor: AppColors.background,
                    border: Border.all(color: AppColors.background, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  ),
                ),
              )
            ],
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
                      child: SizedBox(
                        height: Get.height*0.8,
                        child: PageView(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Column(
                              key: const Key('page1'),
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Get.height*0.025),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Event Information', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black,
                                    fontSize: Get.width*0.05,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.01),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Name your event, along with why attendees should come, including interesting highlights', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: Get.width*0.04,
                                    fontWeight: FontWeight.normal,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.04),
                                PageInput(
                                  hint: 'What is the name of your event?',
                                  label: 'Title of Event',
                                  validator: (val){
                                    if(val!.isEmpty){
                                      return 'Please enter a event name';
                                    }else if(val.length <= 1){
                                      return 'Please enter a valid event name';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  isCompulsory: true,
                                  controller: eventNameController,
                                ),
                                SizedBox(height: Get.height*0.025),
                                PageInput(
                                  hint: 'What is the name of the event organizer',
                                  label: 'Organizer’s name',
                                  validator: Validator.fullnameValidation,
                                  keyboardType: TextInputType.name,
                                  isCompulsory: true,
                                  controller: eventOrganizerController,
                                ),
                                SizedBox(height: Get.height*0.025),
                                PageDropButton(
                                  label: "Is the event private or public?",
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
                                  hint: 'e.g. #music, #concert, #party',
                                  label: 'Tags',
                                  validator: (val){
                                    return null;
                                  },
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
                              children: [
                                SizedBox(height: Get.height*0.025),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Location', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black,
                                    fontSize: Get.width*0.05,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.01),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Where is the location of your event?', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: Get.width*0.04,
                                    fontWeight: FontWeight.normal,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.04),
                                PageDropButton(
                                  label: "Event Type",
                                  hint: '',
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  onChanged: (val) {
                                    eventsTypeController.text = val;
                                    controller.update(['create_event']);
                                  },
                                  value: "Physical",
                                  items: ["Physical","Virtual"].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: Get.height*0.025),
                                PageInput(
                                  hint: 'What is the name of the event location?',
                                  label: 'Event Location',
                                  validator: Validator.textValidation,
                                  keyboardType: TextInputType.name,
                                  isCompulsory: true,
                                  controller: locationController,
                                ),
                                if(eventsTypeController.text == 'Virtual')
                                  SizedBox(height: Get.height*0.025),
                                if(eventsTypeController.text == 'Virtual')
                                  PageInput(
                                  hint: 'Please input the link to the event',
                                  label: 'Url Link to event',
                                  validator: Validator.urlValidation,
                                  keyboardType: TextInputType.url,
                                  isCompulsory: true,
                                  controller: linkController,
                                ),
                                SizedBox(height: Get.height*0.025),
                                PageDropButton(
                                  label: "Free to attend or paid event?",
                                  hint: '',
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  onChanged: (val) {
                                    freeOrPaidController.text = val;
                                  },
                                  value: "Free",
                                  items: ["Free","Paid"].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Column(
                              key: const Key('page3'),
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Get.height*0.025),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Date and time', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black,
                                    fontSize: Get.width*0.05,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.01),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text('Tell your attendees when the event will start and end so they plan for it', style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: Get.width*0.04,
                                    fontWeight: FontWeight.normal,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.04),
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
                                    validator: Validator.imageValidator,
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
                                      );
                                    }
                                ),
                                SizedBox(height: Get.height*0.04),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text(eventNameController.text, style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black,
                                    fontSize: Get.width*0.05,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.01),
                                Padding(
                                  padding: EdgeInsets.only(left: Get.width*0.01),
                                  child: Text("${DateFormat.yMMMMEEEEd().format(startDate)} at ${startTimeController.text}", style: AppTextStyle.subtitle1.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: Get.width*0.04,
                                    fontWeight: FontWeight.normal,
                                  )),
                                ),
                                SizedBox(height: Get.height*0.01),
                                _TextButton(
                                  leading: Icon(Icons.people_alt_rounded, color: Colors.black.withOpacity(0.5)),
                                  text: eventOrganizerController.text,
                                  onPressed: () {
                                  },
                                ),
                                SizedBox(height: Get.height*0.01),
                                _TextButton(
                                  leading: Icon(Icons.location_on, color: Colors.black.withOpacity(0.5)),
                                  text: eventsTypeController.text == "Physical" ? locationController.text : linkController.text,
                                  onPressed: () {
                                  },
                                ),
                                SizedBox(height: Get.height*0.01),
                                _TextButton(
                                  leading: Icon(FeatherIcons.tag, color: Colors.black.withOpacity(0.5)),
                                  text: freeOrPaidController.text == "Free" ? "Free to attend" : "Paid to attend",
                                  onPressed: () {
                                  },
                                ),
                                SizedBox(height: Get.height*0.01),
                                _TextButton(
                                  leading: Icon(Icons.perm_contact_calendar_rounded, color: Colors.black.withOpacity(0.5)),
                                  text: "Registered:  0",
                                  onPressed: () {
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
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

class _TextButton extends StatelessWidget {
  final Widget leading;
  final String text;
  final Function() onPressed;
  const _TextButton({required this.text, required this.onPressed, required this.leading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.height*0.018),
        child: Row(children: [
          leading,
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: AppTextStyle.subtitle1.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
        ]),
      ),
    );
  }
}