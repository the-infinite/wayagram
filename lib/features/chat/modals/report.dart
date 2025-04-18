import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class ReportDialog extends StatefulWidget {
  final UserDetailsModel user;
  final SocialProfileModel profile;
  final WidgetRef ref;

  // Construct.
  const ReportDialog({
    super.key,
    required this.user,
    required this.profile,
    required this.ref,
  });

  @override
  State<ReportDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportDialog> {
  late final notifier = widget.ref.read(conversationProvider.notifier);
  late final buttonController = ValueNotifier(false);
  final inputController = TextEditingController();
   ReportModel? selectedReport = null;
  final list = [
    ReportModel(
      id: 1,
      text: "Spam or misleading content",
      value: false,
    ),
    ReportModel(
      id: 2,
      text: "Inappropriate content",
      value: false,
    ),
    ReportModel(
      id: 3,
      text: "Fraudulent activity",
      value: false,
    ),
    ReportModel(
      id: 4,
      text: "Violates terms and conditions",
      value: false,
    ),
    ReportModel(
      id: 5,
      text: "Other",
      value: false,
    ),
  ];

  @override
  void dispose() {
    buttonController.dispose();
    inputController.dispose();
    super.dispose();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    //? First, we obtain all things needed to build this widget.
    final user = widget.user;
    final profile = widget.profile;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Some space to give a decent amount of spacing between concerned
              // sections.
              Gap(30.h),

              //? Next, the title of this popup.
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Report User",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.black,
                  ),
                ),
              ),

              // Some space.
              Gap(5.h),

              //? Next, this user's username.
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Help us improve the platform by letting us know why you're reporting this user",
                  textAlign: TextAlign.start,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.greyColor500,
                  ),
                ),
              ),

              // Some space.
              Gap(25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 0.5,
                      width: 100.w,
                      color: theme.colorScheme.greyColor300,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Choose Reason For Reporting",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.greyColor900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 0.5,
                      width: 100.w,
                      color: theme.colorScheme.greyColor300,
                    ),
                  ),
                ],
              ),
              Gap(25.h),

              //? A titular action section.
              ...list.map(
                (e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectedReport = e;
                        int index = list.indexOf(e);
                        setState(() {
                          for (int i = 0; i < list.length; i++) {
                            list[i].value =
                                (i == index); // Only selected index is true
                          }
                        });
                      },
                      child: Container(
                        width: Get.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: e.value
                                ? theme.colorScheme.primary
                                : Colors.transparent, // Border color
                            width: 0.5, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              8), // Optional rounded corners
                        ),
                        child: Text(
                          e.text,
                          textAlign: TextAlign.start,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.greyColor900,
                          ),
                        ),
                      ),
                    ),
                    Gap(25),
                  ],
                ),
              ),

              // Some space.
              Gap(10.h),

              //? A titular action section.
              WayaTextFormField(
                controller: inputController,
                hintText: "Provide more details about the issue...",
                label: "Additional Comments (Optional)",
                maxLines: 5,
                line: 5,
                // isReadOnly: true,

                //  label: 'Business Name',
              ),

              // Some space.
              Gap(15.h),

              //? Our block button.
              WayaProgressiveButton(
                notifier: buttonController,
                color: theme.colorScheme.primary,
                callback: () async {
                  if(selectedReport == null && inputController.text.trim().isEmpty){ 
                    WayaSnackBar.showToast("Please select a reason for reporting this user", showSuccess: false);
                    return;
                  }
                  //? If this went well...
                  final result = await notifier.reportUser(user.id, 
                  inputController.text.trim().isEmpty?selectedReport?.text??"": inputController.text.trim()
                  );

                  //? Then leave.
                  if (result) {
                    WayaNav.goBack(result: true);
                    return;
                  }

                  //? Then we leave.
                  WayaNav.goBack();
                },
                text: "Submit",
              ),

              // Some space.
              Gap(5.h),

              //? Our block button.
              WayaButton(
                color: theme.colorScheme.transparent,
                border: Border.all(color: theme.colorScheme.greyColor300),
                textColor: theme.colorScheme.greyColor500,
                callback: () => WayaNav.goBack(),
                text: "Cancel",
              ),

              // Some space.
              Gap(25.h),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportModel {
  final int id;
  final String text;
  bool value;

  ReportModel({
    required this.id,
    required this.text,
    this.value = false,
  });
}
