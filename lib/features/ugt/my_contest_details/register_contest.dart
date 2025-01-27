import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/application_status.dart';
import '../../../core/components/waya_buttons.dart';
import '../../../core/components/waya_scaffold.dart';
import '../../../core/components/waya_select_field.dart';
import '../../../core/components/waya_text_form_field.dart';
import '../../../core/theme/waya_textstyles.dart';
import '../../../core/utils/waya_utils.dart';
import '../../auth/account_creation/vm/personal_first_step_vm.dart';

class RegisterContest extends ConsumerStatefulWidget {
  static const route = '/register-contest1';
  const RegisterContest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterContestState();
}
bool isSwitched = false;

class _RegisterContestState extends ConsumerState<RegisterContest> {

  // String term ="terms";
   Color redColor = Colors.yellowAccent;
    String resetColor = '\x1B[0m';

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    String term = "${redColor}terms";
    final viewModel = ref.watch(personalFirstStepProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Register For Contest",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Join University Got Talent and Let\n Your Talent Shine!",
              style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          Text(
              "Sign up now to be part of the biggest university talent\n competition and make your mark!",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(20),
          Text(
              "Personal Information",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(20),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Enter Full Name",
            label: "Full Name",
          ),
          const Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "example@mail.com",
            label: "Email Address",
          ),
          const Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Enter Address here",
            label: "Address",
          ),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.phoneNumber.text.isEmpty) {
              return 'Phone is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone Number",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.wayaCopyWith(
                    fontSize: 14,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
                ),
                const Gap(3),
                Row(
                  children: [
                    //   Expanded(
                    Container(
                      height: 48,
                      width: 90,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: wayaTheme.colorScheme.greyColor300,
                              width: 1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(6.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/onboarding/flag.png',
                            width: 30,
                            height: 30,
                          ),
                          const Gap(3),
                          Text(
                            "+234",
                            style: WayaTextStyles.hintStyle,
                          )
                        ],
                      ),
                    ),
                    const Gap(4),
                    Expanded(
                      child: WayaTextFormField(
                        keyboardType: TextInputType.phone,
                        controller: viewModel.phoneNumber,
                        hintText: '000-000-000',
                        borderColor: formState.hasError &&
                            viewModel.phoneNumber.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                    )
                  ],
                ),
                if (formState.hasError &&
                    viewModel.phoneNumber.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error,
                          fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(20),
          Text(
              "University Information",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(20),
          WayaSelectField(
            height: 0.3,
            label: "Which University do you represent?",
            hintText: 'Select University',
            items: [],
            onSelected: (value) {},
            uniqueKey: 'contest-state',
          ),
          const Gap(15),
          WayaSelectField(
            height: 0.3,
            label: "State",
            hintText: 'Select state ',
            items: [],
            onSelected: (value) {},
            uniqueKey: 'contest-state',
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Upload School ID or Acceptance Letter.",
                    style: wayaTheme.textTheme.bodyMedium),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Column(
                        children: [
                          Image.asset("assets/images/upload.png"),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "upload your valid school ID.",
                              style: wayaTheme.textTheme.bodyMedium),
                          SizedBox(height: 4),
                          _selectedImage == null
                              ? Column(
                            children: [
                              Text(
                                  "JPG, MP4 format . Max. 25MB",
                                  style: wayaTheme.textTheme.hintStyle),
                            ],
                          )
                              : Image.file(
                            File(_selectedImage!.path),
                            height: 100,
                          ),

                        ],
                      ),
                    ),

                    Column(
                      children: [
                        WayaButton(
                          horizontalPadding: 15,
                            text: "Upload",
                            callback: ()=> {
                              if (_selectedImage != null) {

                              }
                            }

                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),
          Text(
              "Talent Description",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(20),
          WayaSelectField(
            height: 0.3,
            label: "Talent Category",
            hintText: 'Select Category of Talent',
            items: [],
            onSelected: (value) {},
            uniqueKey: 'contest-state',
          ),
          const Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Tell us about your talent in a few words. What makes you stand out?",
            label: "Description of Talent",
            line: 6,
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Show Us Your Talent",
                    style: wayaTheme.textTheme.bodyMedium),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Column(
                        children: [
                          Image.asset("assets/images/upload.png"),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Upload images / Videos of your Talent.",
                              style: wayaTheme.textTheme.bodyMedium),
                          SizedBox(height: 4),
                          _selectedImage == null
                              ? Column(
                            children: [
                              Text(
                                  "JPG, MP4 format . Max. 25MB",
                                  style: wayaTheme.textTheme.hintStyle),
                            ],
                          )
                              : Image.file(
                            File(_selectedImage!.path),
                            height: 100,
                          ),

                        ],
                      ),
                    ),

                    Column(
                      children: [
                        WayaButton(
                            horizontalPadding: 15,
                            text: "Upload",
                            callback: ()=> {
                              if (_selectedImage != null) {

                              }
                            }

                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),
          Text(
              "Other Information",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(20),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Enter Your Age",
            label: "Age",
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Passport",
                    style: wayaTheme.textTheme.bodyMedium),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Column(
                        children: [
                          Image.asset("assets/images/upload.png"),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Upload image of your Passport.",
                              style: wayaTheme.textTheme.bodyMedium),
                          SizedBox(height: 4),
                          _selectedImage == null
                              ? Column(
                            children: [
                              Text(
                                  "JPG, MP4 format . Max. 25MB",
                                  style: wayaTheme.textTheme.hintStyle),
                            ],
                          )
                              : Image.file(
                            File(_selectedImage!.path),
                            height: 100,
                          ),

                        ],
                      ),
                    ),

                    Column(
                      children: [
                        WayaButton(
                            horizontalPadding: 15,
                            text: "Upload",
                            callback: ()=> {
                              if (_selectedImage != null) {

                              }
                            }

                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: wayaTheme.colorScheme.customPrimary
              ),
              const SizedBox(width: 10),
              Text(
                "By checking this box, you agree to our term and\n conditions",
                style: TextStyle(
                  fontSize: 12,
                  color: isSwitched ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
          const Gap(40),
          WayaButton(
            callback: () {
              WayaUtils.showModalSheetUgt(
                context,
                child: ApplicationStatus(),
              );
            },
            text: "Apply Now & Join the Fun!",
          ),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border:
              Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                Navigator.pop(context);
              })
        ],
      ),
    );


  }
}