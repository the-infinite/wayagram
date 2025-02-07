import 'package:flutter/material.dart';
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
  const UpdateStatus(
      {super.key,
      required this.title,
      required this.subTtile,
      required this.statuses,
      required this.currentStatus,
      required this.cta});

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          width: context.width,
          height: context.height * 0.6,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                Text(
                  widget.subTtile,
                  textAlign: TextAlign.start,
                  style: wayaTheme.textTheme.descriptionStyle,
                ),
                const Gap(24),
                const Gap(24),
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
                      widget.cta,
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
                ListView.builder(
                    itemCount: widget.statuses.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                        return Column(
                        children: [
                          ListTile(
                          minTileHeight: 30,
                          selectedTileColor: selectedStatus == widget.statuses[index]
                            ? wayaTheme.colorScheme.scaffoldColor
                            : null,
                          trailing: selectedStatus == widget.statuses[index]
                            ? Icon(
                              Icons.check_circle,
                              size: 20,
                              color: wayaTheme.colorScheme.customPrimary,
                              )
                            : null,
                          contentPadding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                          title: Text(WayaHelpers.removeCamelCaseAndUnderscore(widget.statuses[index]), style:TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14),),
                          onTap: () {
                            setState(() {
                            selectedStatus = widget.statuses[index];
                            });
                          },
                          ),
                          if (index < widget.statuses.length - 1) const Gap(0), // Adjust the gap as needed
                        ],
                        );
                    }),
                const Gap(24),
                WayaButton(
                    callback: () {
                      Navigator.of(context).pop(selectedStatus);
                    },
                    text: "Confirm"),
                const Gap(10),
                WayaButton(
                    callback: () {
                      Navigator.of(context).pop();
                    },
                    textColor: wayaTheme.colorScheme.greyColor500,
                    color: wayaTheme.colorScheme.transparent,
                    border: Border.all(
                        color: wayaTheme.colorScheme.greyColor500, width: 1),
                    text: 'Cancel')
              ],
            ),
          )),
    );
  }
}
