import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class BlockUserDialog extends StatefulWidget {
  final ChatModel chat;
  final WidgetRef ref;

  // Construct.
  const BlockUserDialog({
    super.key,
    required this.chat,
    required this.ref,
  });

  @override
  State<BlockUserDialog> createState() => _BlockUserDialogState();
}

class _BlockUserDialogState extends State<BlockUserDialog> {
  late final notifier = widget.ref.read(conversationProvider.notifier);
  late final buttonController = ValueNotifier(false);

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    //? First, we obtain all things needed to build this widget.
    final user = widget.chat.other.userData!;
    final profile = widget.chat.other.profileData!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Some space to give a decent amount of spacing between concerned
              // sections.
              Gap(30.h),

              //? First, the user's profile picture.
              Align(
                alignment: Alignment.center,
                child: ChatProfilePicture(
                  user: user,
                  radius: 40.r,
                  showActive: false,
                ),
              ),

              // Something like space.
              Gap(10.h),

              //? Next, the title of this popup.
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Block ${profile.username ?? user.id}",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.customBlack,
                  ),
                ),
              ),

              // Some space.
              Gap(5.h),

              //? Next, this user's username.
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Are you sure you want to block this user? Blocking them will "
                  "prevent them from messaging or interacting with you on this platform",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.greyColor400,
                  ),
                ),
              ),

              // Some space.
              Gap(25.h),

              //? A titular action section.
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Here's what happens when you block someone",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.greyColor400,
                  ),
                ),
              ),

              // Some space.
              Gap(10.h),

              //? Now, let's show the user the list.
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary50,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "They won't be able to message or call you",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              // Some space.
              Gap(5.h),

              //? Now, let's show the user the list.
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary50,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "You won't see their posts or activity",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              // Some space.
              Gap(5.h),

              //? Now, let's show the user the list.
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary50,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "You can unblock them anytime",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              // Some space.
              Gap(25.h),

              //? A titular action section.
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "This action won't notify the user",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.greyColor400,
                  ),
                ),
              ),

              // Some space.
              Gap(5.h),

              //? Our block button.
              WayaProgressiveButton(
                notifier: buttonController,
                color: theme.colorScheme.error,
                callback: () async {
                  //? If this went well...
                  final result = await notifier.blockOrUnblockUser(user.id);

                  //? Then leave.
                  if (result) {
                    WayaNav.goBack(result: true);
                    return;
                  }

                  //? Then we leave.
                  WayaNav.goBack();
                },
                text: "Block ${user.firstName.capitalizeFirst}",
              ),

              // Some space.
              Gap(5.h),

              //? Our block button.
              WayaButton(
                color: theme.colorScheme.transparent,
                border: Border.all(color: theme.colorScheme.greyColor300),
                textColor: theme.colorScheme.greyColor500,
                callback: () => WayaNav.goBack(),
                text: "Cancel",
              ),

              // Some space.
              Gap(25.h),
            ],
          ),
        ),
      ),
    );
  }
}
