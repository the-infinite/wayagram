import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/block.dart';
import 'package:wayagram/features/chat/modals/report.dart';
import 'package:wayagram/features/chat/modals/unblock.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/profile/chat_media.dart';
import 'package:wayagram/features/chat/widget/profile/button.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class PersonalChatProfilePage extends StatelessWidget {
  final ChatModel chat;
  final WidgetRef ref;

  // Construct.
  const PersonalChatProfilePage({
    super.key,
    required this.chat,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    //? First, we obtain all things needed to build this widget.
    final notifier = ref.read(conversationProvider.notifier);
    final user = chat.other.userData!;
    final profile = chat.other.profileData!;
    final state = ref.watch(conversationProvider);
    final theme = Theme.of(context);

    //? Now, build and return the widget.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      padding: EdgeInsets.all(15.dg),
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Some space to give a decent amount of spacing between concerned
          // sections.
          Gap(40.h),

          //? First, the user's profile picture.
          Align(
            alignment: Alignment.center,
            child: ChatProfilePicture(
              user: user,
              radius: 40.r,
              showActive: false,
              chat: chat,
            ),
          ),

          // Some space.
          Gap(5.h),

          //? Next, the user's fullname.
          Align(
            child: Text(
              profile.displayName ?? '',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.customBlack,
              ),
            ),
          ),

          //? Next, this user's username.
          if (profile.username != null) ...[
            // Some space.
            Gap(2.h),

            //? Next, this user's username.
            Align(
              child: Text(
                "@${profile.username}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.greyColor400,
                ),
              ),
            ),
          ],

          // Some space.
          Gap(20.h),

          //? Next, the section for action buttons.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 20.w,
            children: [
              //* Go to this user's profile.
              ProfileActionButton(
                onTap: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(user.id)),
                icon: WayaAssets.icons.cProfileUser.path,
                text: "Profile",
              ),

              //* Mute/Unmute this user.
              ProfileActionButton(
                onTap: () => notifier.muteOrUnmuteUser(context, ref, chat.self.chatId),
                icon: WayaAssets.icons.cProfileMute.path,
                isBad: !state.isMuted(chat.self.chatId),
                text: state.isMuted(chat.self.chatId) ? "Unmute" : "Mute",
              ),

              //* Next, report a user.
              ProfileActionButton(
                onTap: () async {
                  final result = await WayaUtils.showModalSheet<bool?>(
                    context,
                    child: ReportDialog(
                      user: chat.other.userData!,
                      profile: chat.other.profileData!,
                      ref: ref,
                    ),
                  );

                  // If this is defined...
                  if (result == null) return;

                  //? Then pop.
                  if (result) {
                    WayaSnackBar.showToast("This user has been Reported");
                  }
                },
                icon: WayaAssets.icons.cProfileReport.path,
                text: "Report",
              ),

              //* Finally, to block/unblock a user.
              ProfileActionButton(
                onTap: state.isBlocked(chat.other.userId)
                    ? () async {
                        final result = await WayaUtils.showModalSheet<bool?>(
                          context,
                          child: UnblockUserDialog(
                            user: chat.other.userData!,
                            profile: chat.other.profileData!,
                            ref: ref,
                          ),
                        );

                        // If this is defined...
                        if (result == null) return;

                        //? Then pop.
                        if (result) {
                          WayaSnackBar.showToast("This user has been unblocked successfully");
                        }
                      }
                    : () async {
                        final result = await WayaUtils.showModalSheet<bool?>(
                          context,
                          child: BlockUserDialog(
                            user: chat.other.userData!,
                            profile: chat.other.profileData!,
                            ref: ref,
                          ),
                        );

                        // If this is defined...
                        if (result == null) return;

                        //? Then pop.
                        if (result) {
                          WayaSnackBar.showToast("This user has been blocked successfully");
                        }
                      },
                icon: WayaAssets.icons.cProfileBlock.path,
                isBad: !state.isBlocked(chat.other.userId),
                text: state.isBlocked(chat.other.userId) ? "Unblock" : "Block",
              )
            ],
          ),

          // Some more space.
          Gap(30.h),

          //? Next, the section for media shared in the messages.
          Text(
            "Media Shared",
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.greyColor300,
            ),
          ),

          // Some space.
          Gap(5.h),

          //? The component for media.
          ChatMediaWidget(
            chat: chat,
            ref: ref,
          ),
        ],
      ),
    );
  }
}
