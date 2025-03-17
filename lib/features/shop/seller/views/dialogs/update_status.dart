import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class UpdateStatus extends StatefulWidget {
  final List<String> statuses;
  final String title;
  final String subTtile;
  final String cta;
  final String currentStatus;

  const UpdateStatus({
    super.key,
    required this.title,
    required this.subTtile,
    required this.statuses,
    required this.currentStatus,
    required this.cta,
  });

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  late String selectedStatus;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
    currentIndex = widget.statuses.indexOf(widget.currentStatus);
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(16), right: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style:  TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            Text(
              widget.subTtile,
              style: wayaTheme.textTheme.descriptionStyle,
            ),
            const Gap(24),
            Row(
              children: [
                Expanded(
                  child: Divider(color: wayaTheme.colorScheme.greyColor200),
                ),
                const Gap(10),
                Text(
                  widget.cta,
                  style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Divider(color: wayaTheme.colorScheme.greyColor200),
                ),
              ],
            ),
            ListView.builder(
              itemCount: widget.statuses.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                bool isDisabled = currentIndex > 0 && index < currentIndex;
                return Column(
                  children: [
                    ListTile(
                      minTileHeight: 30,
                      selectedTileColor:
                          selectedStatus == widget.statuses[index]
                              ? wayaTheme.colorScheme.scaffoldColor
                              : null,
                      trailing:
                          selectedStatus == widget.statuses[index] || isDisabled
                              ? Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: isDisabled
                                      ? wayaTheme.colorScheme.greyColor400
                                      : wayaTheme.colorScheme.customPrimary,
                                )
                              : null,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 1),
                      title: Text(
                        WayaHelpers.removeCamelCaseAndUnderscore(
                            widget.statuses[index]),
                        style: TextStyle().wayaCopyWith(
                          color: isDisabled
                              ? wayaTheme.colorScheme.greyColor400
                              : wayaTheme.colorScheme.customBlack,
                          fontSize: 14.sp,
                        ),
                      ),
                      onTap: isDisabled
                          ? null
                          : () {
                              setState(() {
                                selectedStatus = widget.statuses[index];
                              });
                            },
                    ),
                    if (index < widget.statuses.length - 1) const Gap(0),
                  ],
                );
              },
            ),
            const Gap(24),
            WayaButton(
              callback: () {
                WayaNav.goBack(result: selectedStatus);
              },
              text: "Confirm",
            ),
            const Gap(10),
            WayaButton(
              callback: () {
                WayaNav.goBack();
              },
              textColor: wayaTheme.colorScheme.greyColor500,
              color: wayaTheme.colorScheme.transparent,
              border: Border.all(color: wayaTheme.colorScheme.greyColor500),
              text: 'Cancel',
            )
          ],
        ),
      ),
    );
  }
}
