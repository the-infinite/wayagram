import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class WayaNoticeModal extends StatelessWidget {
  final String title;
  final String message;
  final FutureOr<void> Function() onPress;
  final VoidCallback? onCancel;
  final ValueNotifier<bool> actionNotifier;
  final Color? buttonColor;
  final String? buttonText;
  final Widget? leadingIcon;
  final String? secondButtonText;
  final Widget? buttonCenterWidget;
  final Widget? secondButtonCenterWidget;
  final Widget icon;

  const WayaNoticeModal({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.actionNotifier,
    required this.onCancel,
    required this.onPress,
    this.secondButtonText = "",
    this.buttonText,
    this.buttonCenterWidget,
    this.secondButtonCenterWidget,
    this.buttonColor,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: BoxDecoration(
        color: wayaTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const Gap(30),
          Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 3,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(12),
          Text(
            message,
            maxLines: 3,
            softWrap: true,
            textAlign: TextAlign.center,
            style: WayaTextStyles.descriptionStyle,
          ),
          const Gap(24),
          WayaProgressiveButton(
            notifier: actionNotifier,
            centerWidget: buttonCenterWidget,
            color: buttonColor,
            callback: () async => await onPress(),
            leadingIcon: leadingIcon,
            text: buttonCenterWidget == null ? buttonText ?? '' : '',
          ),
          const Gap(10),
          Visibility(
            visible: onCancel != null,
            child: WayaButton(
              callback: () {
                onCancel?.call();
              },
              textColor: wayaTheme.greyColor500,
              color: wayaTheme.transparent,
              centerWidget: secondButtonCenterWidget,
              border: Border.all(color: wayaTheme.greyColor500, width: 1),
              text: secondButtonCenterWidget == null ? secondButtonText ?? 'Cancel' : '',
            ),
          ),
        ],
      ),
    );
  }
}
