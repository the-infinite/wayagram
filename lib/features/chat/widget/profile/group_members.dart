import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/group/add_users.dart';
import 'package:wayagram/features/chat/modals/group/remove.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/conversation_vm.dart';
import 'package:wayagram/features/chat/widget/chat_selection.dart';

class GroupMembersWidget extends StatefulWidget {
  final ChatModel chat;
  final WidgetRef ref;

  // Construct.
  const GroupMembersWidget({
    super.key,
    required this.chat,
    required this.ref,
  });

  @override
  State<GroupMembersWidget> createState() => _GroupMembersWidgetState();
}

class _GroupMembersWidgetState extends State<GroupMembersWidget> {
  final addMemberController = ValueNotifier(false);

  @override
  void dispose() {
    addMemberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Data needed to get there.
    final theme = Theme.of(context);
    final notifier = widget.ref.read(conversationProvider.notifier);

    //? This is the widget itself.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        //? Now, for the media themselves.
        Row(
          spacing: 10.w,
          children: [
            //? The button to add a new member.
            Expanded(
              child: WayaProgressiveButton(
                callback: () => WayaUtils.showModalSheet(
                  context,
                  child: AddUserToGroupModal(
                    chat: widget.chat,
                    notifier: notifier,
                  ),
                ),
                notifier: addMemberController,
                color: theme.colorScheme.greyColor200,
                text: "Add New Member",
                textColor: theme.colorScheme.greyColor500,
                leadingIcon: WayaAssets.icons.cPlus.svg(
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.greyColor500,
                    BlendMode.srcIn,
                  ),
                ),
                textStyle: theme.textTheme.bodySemiBold.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            ),

            //? The button to add a share an invitation link.
            Expanded(
              child: WayaButton(
                callback: () async =>
                    await WayaNavigationHelper.showComingSoonModal(false),
                color: theme.colorScheme.greyColor200,
                text: "Share Invite Link",
                textColor: theme.colorScheme.greyColor500,
                leadingIcon: WayaAssets.icons.cLink.svg(
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.greyColor500,
                    BlendMode.srcIn,
                  ),
                ),
                textStyle: theme.textTheme.bodySemiBold.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),

        // Some space.
        Gap(10.h),

        //? Now for the other members.
        ...List.generate(
          widget.chat.chatMembers.length,
          (index) => UserActionWidget(
            index: index,
            id: widget.chat.chatMembers[index].userId,
            onTap: () => WayaUtils.showModalSheet(
              context,
              child: RemoveUserChatGroupModal(
                chat: widget.chat,
                notifier: notifier,
                userId: widget.chat.chatMembers[index].userId,
              ),
            ),
            actionText: "Remove",
            hideAction: widget.chat.chatMembers[index].userId ==
                ConversationState.self.id,
            actionAvailable: widget.chat.membersCanAddMembers,
            child: widget.chat.chatMembers[index].role == ChatMemberRole.member
                ? null
                : Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.w, horizontal: 12.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Group Owner",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
