import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

import '../../../core/components/waya_buttons.dart';


class SuccessfulModal extends StatefulHookConsumerWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final bool showCopyLink;
  final Function( BuildContext,WidgetRef) onTap;
  const SuccessfulModal(
      {required this.title,
      required this.subtitle,
      required this.showCopyLink,
      this.buttonText,
      required this.onTap,
      super.key});

  @override
  ConsumerState<SuccessfulModal> createState() => _SuccessfulModalState();
}

class _SuccessfulModalState extends ConsumerState<SuccessfulModal> {
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
              callback: () {
                // Navigator.pop(context);
                widget.onTap(context,ref);
              },
              text: widget.buttonText ?? "Manage Contest",
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
