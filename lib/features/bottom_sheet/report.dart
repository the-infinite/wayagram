import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';

class Report extends ConsumerStatefulWidget {
  final String currentStatus;
  final List<String> statuses;
  final String momentId;

  const Report({
    super.key,
    required this.statuses,
    required this.currentStatus,
    required this.momentId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportEventState();
}

class _ReportEventState extends ConsumerState<Report> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController comment;
  late bool isLoading;

  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
    comment = TextEditingController();
    isLoading = false;
  }

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                "Help us improve the platform by letting us know you are reporting this event",
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
                const Gap(10),
                Text(
                  "Choose Reason for Reporting",
                  style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  ),
                ),
                const Gap(10),
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
                    WayaTextFormField(
                      line: 6,
                      keyboardType: TextInputType.text,
                      controller: comment,
                      hintText: 'Provide more detail about the issue',
                      label: 'Additional Comment (Optional)',
                    ),
                    const Gap(24),
                    WayaButton(
                        callback: () async {
                          if (selectedStatus.isEmpty) {
                            return WayaSnackBar.showToast("Reason is required");
                          }
                          setState(() => isLoading = true);

                          final resp = await ref
                              .read(momentVmProvider.notifier)
                              .reportMoment(
                                  momentId: widget.momentId,
                                  reason: selectedStatus,
                                  comment: comment.text);
                          setState(() {
                            isLoading = false;
                          });

                          return WayaNav.goBack(result: resp);
                        },
                        centerWidget: LoadingState(
                            loading: isLoading, text: "Submit Report")),
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
