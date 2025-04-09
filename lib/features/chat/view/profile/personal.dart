import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/block.dart';
import 'package:wayagram/features/chat/modals/unblock.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/profile/button.dart';
import 'package:wayagram/features/chat/widget/profile/section.dart';
import 'package:wayagram/shared/features/chat/widget/empty_conversation.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class PersonalChatProfilePage extends StatefulWidget {
  final ChatModel chat;
  final WidgetRef ref;

  // Construct.
  const PersonalChatProfilePage({
    super.key,
    required this.chat,
    required this.ref,
  });

  @override
  State<PersonalChatProfilePage> createState() => _PersonalChatProfilePageState();
}

class _PersonalChatProfilePageState extends State<PersonalChatProfilePage> {
  late final notifier = widget.ref.read(conversationProvider.notifier);
  final mediaTypeController = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    //? First, we obtain all things needed to build this widget.
    final user = widget.chat.other.userData!;
    final profile = widget.chat.other.profileData!;
    final state = widget.ref.watch(conversationProvider);
    final theme = Theme.of(context);

    //? Now, build and return the widget.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      padding: EdgeInsets.all(15.dg),
      resizeToAvoidBottomInset: true,
      body: ValueListenableBuilder(
        valueListenable: mediaTypeController,
        builder: (context, groupValue, _) => Column(
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
                chat: widget.chat,
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
                  onTap: () => notifier.muteOrUnmuteUser(widget.chat.other.userId),
                  icon: WayaAssets.icons.cProfileMute.path,
                  isBad: true,
                  text: "Mute",
                ),

                //* Next, report a user.
                ProfileActionButton(
                  onTap: () => notifier.reportUser(widget.chat.other.userId),
                  icon: WayaAssets.icons.cProfileReport.path,
                  text: "Report",
                ),

                //* Finally, to block/unblock a user.
                ProfileActionButton(
                  onTap: state.isBlocked(widget.chat.other.userId)
                      ? () async {
                          final result = await WayaUtils.showModalSheet<bool?>(
                            context,
                            child: UnblockUserDialog(
                              user: widget.chat.other.userData!,
                              profile: widget.chat.other.profileData!,
                              ref: widget.ref,
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
                              user: widget.chat.other.userData!,
                              profile: widget.chat.other.profileData!,
                              ref: widget.ref,
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
                  isBad: !state.isBlocked(widget.chat.other.userId),
                  text: state.isBlocked(widget.chat.other.userId) ? "Unblock" : "Block",
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

            //? Now, for the media themselves.
            Row(
              spacing: 10.w,
              children: [
                //? For all types of media..
                Expanded(
                  child: SectionCountButton(
                    title: "All Media",
                    count: 0,
                    value: 0,
                    controller: mediaTypeController,
                  ),
                ),

                //? For videos
                Expanded(
                  child: SectionCountButton(
                    title: "Videos",
                    count: 0,
                    value: 1,
                    controller: mediaTypeController,
                  ),
                ),

                //? For pictures
                Expanded(
                  child: SectionCountButton(
                    title: "Images",
                    count: 0,
                    value: 2,
                    controller: mediaTypeController,
                  ),
                ),
              ],
            ),

            // Some space.
            Gap(10.h),

            //? Now as it is empty.
            ...[
              // Space.
              Gap(80.h),

              //? Now for the media themselves.
              EmptyConversationsWidget(
                title: "No ${groupValue == 0 ? "media" : groupValue == 1 ? "videos" : "images"} yet",
                text: "Send the first one today",
              ),

              // Some other space.
              Gap(60.h),
            ],
          ],
        ),
      ),
    );
  }
}
