import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/group/leave.dart';
import 'package:wayagram/features/chat/modals/group/mute.dart';
import 'package:wayagram/features/chat/modals/group/report.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/widget/profile/chat_media.dart';
import 'package:wayagram/features/chat/widget/profile/button.dart';
import 'package:wayagram/features/chat/widget/profile/group_members.dart';
import 'package:wayagram/features/chat/widget/profile/section.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class GroupChatProfilePage extends StatefulWidget {
  final ChatModel chat;
  final WidgetRef ref;

  // Construct.
  const GroupChatProfilePage({
    super.key,
    required this.chat,
    required this.ref,
  });

  @override
  State<GroupChatProfilePage> createState() => _GroupChatProfilePageState();
}

class _GroupChatProfilePageState extends State<GroupChatProfilePage> {
  late final notifier = widget.ref.read(conversationProvider.notifier);
  final tabController = ValueNotifier(0);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //? This is fine too.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      padding: EdgeInsets.all(15.dg),
      resizeToAvoidBottomInset: true,
      body: ValueListenableBuilder(
        valueListenable: tabController,
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
                user: widget.chat.other.userData!,
                radius: 40.r,
                showActive: true,
                isEdit: true,
                chat: widget.chat,
              ),
            ),

            // Some space.
            Gap(5.h),

            //? Next, the user's fullname.
            Align(
              child: Text(
                widget.chat.name ?? "N/A",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.customBlack,
                ),
              ),
            ),

            //? Next, this user's username.
            if (widget.chat.description?.isNotEmpty ?? false) ...[
              // Some space.
              Gap(2.h),

              //? Next, this user's username.
              Align(
                child: WayaCollapsibleText(
                  widget.chat.description!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyBold.copyWith(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.greyColor500,
                  ),
                ),
              ),
            ],

            // Some space.
            Gap(20.h),

            //? Next, the row of actions that can be performed on a group chat.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 20.w,
              children: [
                //* Go to this user's profile.
                ProfileActionButton(
                  onTap: () => WayaNav.toNamed(
                    WayaAppRoutes.getEditChatGroupProfileScreen(widget.chat.id, widget.chat.id),
                  ),
                  icon: WayaAssets.icons.actionEdit.path,
                  text: "Edit Group Info",
                ),

                //* Mute/Unmute this user.
                ProfileActionButton(
                  onTap: widget.chat.self.mutedUntil != null
                      ? () async {
                          //? Get the result.
                          final result = await notifier.muteOrUnmuteGroup(widget.chat.id, null);

                          //? The result of your efforts is needed for this much.
                          if (result) {
                            WayaSnackBar.showToast("This group has been unmuted successfully");
                          }
                        }
                      : () => WayaUtils.showModalSheet(
                            context,
                            child: MuteChatGroupModal(
                              chat: widget.chat,
                              notifier: notifier,
                            ),
                          ),
                  icon: WayaAssets.icons.cProfileMute.path,
                  isBad: widget.chat.self.mutedUntil == null,
                  text: widget.chat.self.mutedUntil == null ? "Mute" : "Unmute",
                ),

                //* Next, report a user.
                ProfileActionButton(
                  onTap: () => WayaUtils.showModalSheet(
                    context,
                    child: ReportChatGroupModal(
                      chat: widget.chat,
                      notifier: notifier,
                    ),
                  ),
                  icon: WayaAssets.icons.cProfileReport.path,
                  text: "Report",
                ),

                //* Finally, to block/unblock a user.
                ProfileActionButton(
                  onTap: () => WayaUtils.showModalSheet(
                    context,
                    child: LeaveChatGroupModal(
                      chat: widget.chat,
                      notifier: notifier,
                    ),
                  ),
                  icon: WayaAssets.icons.actionLeave.path,
                  isBad: true,
                  text: "Exit Group",
                )
              ],
            ),

            // Some space.
            Gap(20.h),

            //? The pages herein.
            Row(
              spacing: 10.w,
              children: [
                //? For all types of media..
                Expanded(
                  child: SectionCountButton(
                    title: "Members",
                    count: widget.chat.chatMembers.length,
                    value: 0,
                    controller: tabController,
                  ),
                ),

                //? For videos
                Expanded(
                  child: SectionCountButton(
                    title: "Media Shared",
                    count: null,
                    value: 1,
                    controller: tabController,
                  ),
                ),
              ],
            ),

            //? If this is for the group chat.
            if (groupValue == 0) ...[
              //? A divider to tell this section apart form the rest.
              Divider(
                color: theme.colorScheme.greyColor200,
                height: 40.h,
              ),

              //? The group members widget.
              GroupMembersWidget(
                chat: widget.chat,
                ref: widget.ref,
              ),
            ] else ...[
              // Some space.
              Gap(10.h),

              //? The chat media widget.
              ChatMediaWidget(
                chat: widget.chat,
                ref: widget.ref,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
