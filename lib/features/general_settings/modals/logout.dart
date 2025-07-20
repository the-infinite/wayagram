import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class LogoutDialog extends StatefulWidget {
  final WidgetRef ref;

  // Construct.
  const LogoutDialog({
    super.key,
    required this.ref,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
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
                  user: ConversationState.self,
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
                  "Sign out",
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
                  "Are you sure you want to log out of this device? Signing out "
                  "would make you unable to do all of your favourite things "
                  "on Wayagram.",
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
                  "Here's what happens when you sign out",
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
                  "You won't be able to receive any notifications on this device",
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
                  "You won't be able to interact with your favourite content anymore",
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
                  "You can sign in anytime to pick up from where you left off",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              // Some space.
              Gap(30.h),

              //? Our block button.
              WayaProgressiveButton(
                notifier: buttonController,
                color: theme.colorScheme.error,
                callback: () async {
                  await widget.ref
                      .read(profileVmProvider.notifier)
                      .logOutUser();
                },
                text: "Sign out",
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
