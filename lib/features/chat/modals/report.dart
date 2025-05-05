import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/chat/vm/default.dart';

class ReportChatPage extends StatefulHookConsumerWidget {
  final List<String> statuses;
  final String userId;
  const ReportChatPage({
    super.key,
    required this.statuses,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportChatPageState();
}

class _ReportChatPageState extends ConsumerState<ReportChatPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController comment;

  String? selectedStatus;

  @override
  void initState() {
    super.initState();

    comment = TextEditingController();
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final isLoading = useState(false);
    final notifier = ref.read(conversationProvider.notifier);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Report ",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            const Gap(5),
            Text(
                maxLines: 3,
                "Help us improve the platform by letting us know you are reporting this group",
                style: wayaTheme.textTheme.hintStyle),
            const Gap(30),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: wayaTheme.colorScheme.greyColor200,
                    thickness: 1,
                  ),
                ),
                Gap(10),
                Text(
                  "Choose Reason for Reporting",
                  style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  ),
                ),
                Gap(10),
                Expanded(
                  child: Divider(
                    color: wayaTheme.colorScheme.greyColor200,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const Gap(30),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        itemCount: widget.statuses.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                minTileHeight: 30,
                                selectedTileColor:
                                    selectedStatus == widget.statuses[index]
                                        ? wayaTheme.colorScheme.scaffoldColor
                                        : null,
                                trailing: selectedStatus ==
                                        widget.statuses[index]
                                    ? Icon(
                                        Icons.check_circle,
                                        size: 20,
                                        color:
                                            wayaTheme.colorScheme.customPrimary,
                                      )
                                    : null,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 1),
                                title: Text(
                                  WayaHelpers.removeCamelCaseAndUnderscore(
                                      widget.statuses[index]),
                                  style: TextStyle().wayaCopyWith(
                                      color: wayaTheme.colorScheme.customBlack,
                                      fontSize: 14.sp),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedStatus = widget.statuses[index];
                                  });
                                },
                              ),
                              if (index < widget.statuses.length - 1)
                                const Gap(0), // Adjust the gap as needed
                            ],
                          );
                        }),
                    const Gap(24),
                    FormField<String>(validator: (value) {
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            line: 6,
                            keyboardType: TextInputType.text,
                            controller: comment,
                            hintText: 'Provide more detail about the issue',
                            label: 'Additional Comment (Optional)',
                          ),
                        ],
                      );
                    }),
                    const Gap(24),
                    WayaButton(
                        callback: !isLoading.value
                            ? () async {
                                if (selectedStatus == null &&
                                    comment.text.trim().isEmpty) {
                                  WayaSnackBar.showToast(
                                      "Please select a reason for reporting this user",
                                      showSuccess: false);
                                  return;
                                }
                                //? If this went well...
                                isLoading.value = true;
                                final result = await notifier.reportUser(
                                  widget.userId,
                                  comment.text.trim().isEmpty
                                      ? selectedStatus ?? ""
                                      : comment.text.trim(),
                                );

                                //? Then leave.
                                isLoading.value = true;
                                if (result) {
                                  WayaNav.goBack(result: true);
                                  if (context.mounted) {
                                    await WayaUtils.showNotice(
                                      context: context,
                                      title: "Thank you for reporting",
                                      onPress: () => WayaNav.goBack(),
                                      icon: Image.asset(
                                        WayaAssets.images.eCheckEvent.path,
                                        scale: 1.5,
                                      ),
                                      message:
                                          'Your report has been submitted. Our team will review the issue and take appropriate action.',
                                      buttonText: 'Continue',
                                    );

                                    //? This is fine.
                                    //  WayaNav.goBack();
                                  }
                                  return;
                                }

                                //? Then we leave.
                                WayaNav.goBack();
                              }
                            : null,
                        centerWidget: LoadingState(
                            loading: isLoading.value, text: "Submit Report")),
                  ],
                )),
            const Gap(10),
            WayaButton(
                callback: () {
                  WayaNav.goBack();
                },
                textColor: wayaTheme.colorScheme.greyColor500,
                color: wayaTheme.colorScheme.transparent,
                border: Border.all(
                    color: wayaTheme.colorScheme.greyColor500, width: 1),
                text: 'Cancel')
          ],
        ),
      ),
    );
  }
}
