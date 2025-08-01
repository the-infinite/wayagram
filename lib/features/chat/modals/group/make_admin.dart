import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';

class MakeGroupAdminModal extends StatefulWidget {
  final ChatModel chat;
  final ConversationVm notifier;
  final String userId;

  // Construct.
  const MakeGroupAdminModal({
    super.key,
    required this.chat,
    required this.notifier,
    required this.userId,
  });

  @override
  State<MakeGroupAdminModal> createState() => _MakeGroupAdminModalState();
}

class _MakeGroupAdminModalState extends State<MakeGroupAdminModal> {
  final loadingController = ValueNotifier(false);

  //? This is fine.
  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The things required to build it.
    final wayaTheme = Theme.of(context);

    //? The components.
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          //? The hint next.
          Text(
            maxLines: 3,
            textAlign: TextAlign.center,
            "Are you sure you want to make this user a group admin?",
            style: wayaTheme.textTheme.hintStyle.copyWith(
              fontSize: 16.sp,
            ),
          ),

          // Some space.
          const Gap(30),

          //? The button to submit the report.
          WayaProgressiveButton(
            callback: () async {
              //? Get the result.
              final result = await widget.notifier.makeUserAdmin(widget.chat.id, widget.userId);

              //? The result of your efforts is needed for this much.
              if (result) {
                WayaNav.goBack();
                WayaSnackBar.showToast("You have made this user a group admin successfully!", showSuccess: true);
              }
            },
            notifier: loadingController,
            text: "Yes",
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
          ),
        ],
      ),
    );
  }
}
