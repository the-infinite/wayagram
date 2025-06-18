import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';

class ReportChatGroupModal extends StatefulWidget {
  final ChatModel chat;
  final ConversationVm notifier;

  // Construct.
  const ReportChatGroupModal({
    super.key,
    required this.chat,
    required this.notifier,
  });

  @override
  State<ReportChatGroupModal> createState() => _ReportChatGroupModalState();
}

class _ReportChatGroupModalState extends State<ReportChatGroupModal> {
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final loadingController = ValueNotifier(false);
  final valueNotifier = ValueNotifier("");
  final indexNotifier = ValueNotifier(0);
  static const defaults = [
    "Spam or misleading content",
    "Inappropriate_Content",
    "Fraudulent_activity",
    "Violates_terms_and_conditions",
    "other"
  ];

  //? This is fine.
  @override
  void dispose() {
    controller.dispose();
    valueNotifier.dispose();
    indexNotifier.dispose();
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The things required to build it.
    final wayaTheme = Theme.of(context);

    //? The components.
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Form(
        key: _formKey,
        child: ValueListenableBuilder(
          valueListenable: indexNotifier,
          builder: (context, selectedReasonIndex, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //? Section title.
              Text(
                "Report Group",
                style: wayaTheme.textTheme.headlineLarge,
              ),

              // Some space.
              const Gap(5),

              //? The hint next.
              Text(
                maxLines: 3,
                "Help us improve the platform by letting us know you are reporting this group",
                style: wayaTheme.textTheme.hintStyle,
              ),

              // Some space.
              const Gap(30),

              //? Our text stripe.
              WayaTextStrip(
                "Choose Reason For Reporting",
                style: wayaTheme.textTheme.hintStyle.copyWith(
                  color: wayaTheme.colorScheme.greyColor600,
                ),
              ),

              // Some space.
              const Gap(30),

              //? Next, the examples.
              ...List.generate(
                defaults.length,
                (index) => ListTile(
                  minTileHeight: 30,
                  selectedTileColor: selectedReasonIndex == index ? wayaTheme.colorScheme.scaffoldColor : null,
                  trailing: selectedReasonIndex == index
                      ? Icon(
                          Icons.check_circle,
                          size: 20,
                          color: wayaTheme.colorScheme.customPrimary,
                        )
                      : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                  title: Text(
                    WayaHelpers.removeCamelCaseAndUnderscore(defaults[index]),
                    style: wayaTheme.textTheme.bodyMedium?.copyWith(
                      color: wayaTheme.colorScheme.customBlack,
                      fontSize: 14.sp,
                    ),
                  ),
                  onTap: () {
                    valueNotifier.value = defaults[index];
                    indexNotifier.value = index;
                  },
                ),
              ),

              // Some space.
              const Gap(24),

              //? Our form field for additional reasons.
              if (selectedReasonIndex == defaults.length - 1) ...[
                //? First, the form field.
                WayaFormField(
                  validator: (value) {
                    if (controller.text.trim().isEmpty) {
                      return "You must specify a reason";
                    }

                    return null;
                  },
                  line: 6,
                  onChanged: (value) {
                    valueNotifier.value = value;
                  },
                  keyboardType: TextInputType.text,
                  controller: controller,
                  hintText: 'Provide more detail about the issue',
                  label: 'Additional Comment (Optional)',
                ),

                // Some space.
                const Gap(24),
              ],

              //? The button to submit the report.
              WayaProgressiveButton(
                callback: () async {
                  //? Get the result.
                  final result = await widget.notifier.reportGroup(widget.chat.id, valueNotifier.value);

                  //? The result of your efforts is needed for this much.
                  if (result) {
                    WayaNav.goBack();
                    WayaSnackBar.showToast("This group has been reported successfully");
                  }
                },
                notifier: loadingController,
                text: "Submit Report",
              ),

              // Some space.
              const Gap(10),

              //? The button to navigate backward.
              WayaButton(
                callback: () => WayaNav.goBack(),
                textColor: wayaTheme.colorScheme.greyColor500,
                color: wayaTheme.colorScheme.transparent,
                border: Border.all(
                  color: wayaTheme.colorScheme.greyColor500,
                  width: 1,
                ),
                text: 'Cancel',
              )
            ],
          ),
        ),
      ),
    );
  }
}
