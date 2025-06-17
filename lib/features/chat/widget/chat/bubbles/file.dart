import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/widget/chat/input/selected_file.dart';
import 'package:wayagram/features/general_settings/chat_settings/vm.dart';

class FileMessageWidget extends StatelessWidget {
  final MessageModel data;
  final Color textColor;

  // Construct.
  const FileMessageWidget({
    super.key,
    required this.data,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? First, the actual media message.
        ChatFileListWidget(
          interactive: false,
          message: data,
        ),

        //? If this has any text...
        if (data.content != null && data.content!.isNotEmpty) ...[
          // Some space.
          const Gap(10),

          // The text,
          Text(
            data.content!,
            style: WayaTextStyles.bodyMedium.copyWith(
              fontSize: 15.sp * ChatSettingsNotifier.instance.textScale,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          )
        ],
      ],
    );
  }
}
