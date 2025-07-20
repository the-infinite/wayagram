import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class ConfirmDeleteWidget extends ConsumerWidget {
  final Future<void> Function() delete;
  const ConfirmDeleteWidget({super.key, required this.delete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Delete this moment?',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          WayaButton(
            callback: () {
              WayaNav.goBack();
              delete();
            },
            text: "Yes Delete",
            color: wayaTheme.colorScheme.error,
          ),
          const SizedBox(height: 15),
          WayaButton(
            textColor: wayaTheme.colorScheme.greyColor600,
            callback: () {
              WayaNav.goBack();
            },
            text: "Cancel",
            color: wayaTheme.colorScheme.transparent,
            border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor600),
          ),
        ],
      ),
    );
  }
}
