import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/components/waya_select_field.dart';
import '../../../core/components/waya_text_form_field.dart';
import '../../../core/utils/waya_navigation.dart';

class SuccessfulModal extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showCopyLink;
  final VoidCallback onTap;
  const SuccessfulModal(
      this.title, this.subtitle, this.showCopyLink, this.onTap,
      {super.key});

  @override
  State<SuccessfulModal> createState() => _SuccessfulModalState();
}

class _SuccessfulModalState extends State<SuccessfulModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/successugt.png',
            ),
            SizedBox(height: 20.h),
            Text(widget.title, style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            Text(
              widget.subtitle,
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 17.h),
            WayaButton(
              callback: widget.onTap,
              text: "Manage Contest",
            ),
            const Gap(10),
            if (widget.showCopyLink)
              WayaButton(
                  text: 'Copy Contest Invite Link',
                  color: wayaTheme.colorScheme.greyColor300,
                  textColor: wayaTheme.colorScheme.customBlack,
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300),
                  callback: () {})
          ],
        ),
      ),
    );
  }
}
