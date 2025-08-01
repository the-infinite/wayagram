import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/group/make_admin.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/chat/modals/group/remove.dart';
import 'package:wayagram/shared/cache/chat.dart';

class GroupMemberActions extends StatelessWidget {
  final ChatModel chat;
  final WidgetRef ref;
  final ConversationVm notifier;
  final ChatMember member;

  // Construct.
  const GroupMemberActions({
    super.key,
    required this.chat,
    required this.ref,
    required this.notifier,
    required this.member,
  });

  //? Helpful function used to send a message to this person.
  void _sendMessage() async {
    var chat = wayaChatsCache.getItem(
      (chat) => chat.chatType == ChatType.personal && chat.chatMembers.any((member) => member.userId == member.userId),
    );
    chat ??= await notifier.startChat(ChatType.personal, [member.userId]);

    //? Stop if we could not make this chat.
    if (chat == null) return;

    //? If we could make this chat...
    final chatNotifier = ref.read(chatProvider(chat.id).notifier);
    chatNotifier.setChat(chat);
    WayaNav.offNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
  }

  @override
  Widget build(BuildContext context) {
    //? Get the things we need for this.
    final wayaTheme = Theme.of(context);
    final style = wayaTheme.textTheme.bodyBold.copyWith(fontSize: 16.sp);
    final self = chat.self!;

    //? Return the component.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        //? First, the title bar.
        Text(
          "Member Actions",
          textAlign: TextAlign.center,
          style: wayaTheme.textTheme.titleLarge?.copyWith(
            color: wayaTheme.colorScheme.customBlack,
            fontWeight: FontWeight.bold,
          ),
        ),

        //? Next, to send a message.
        WayaButton(
          text: "Send Message",
          verticalPadding: 10.h,
          textStyle: style,
          alignment: Alignment.centerLeft,
          textColor: wayaTheme.colorScheme.customBlack,
          color: wayaTheme.colorScheme.primary.withAlpha(25),
          leadingIcon: WayaAssets.icons.chat.svg(
            height: 18.sp,
            width: 18.sp,
            colorFilter: ColorFilter.mode(
              wayaTheme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          callback: _sendMessage,
        ),

        // Some space.
        SizedBox(height: 15.h),

        //? Next, to view the profile.
        WayaButton(
          text: "View Profile",
          verticalPadding: 10.h,
          textStyle: style,
          alignment: Alignment.centerLeft,
          textColor: wayaTheme.colorScheme.customBlack,
          color: wayaTheme.colorScheme.primary.withAlpha(25),
          leadingIcon: WayaAssets.icons.personal.svg(
            height: 18.sp,
            width: 18.sp,
            colorFilter: ColorFilter.mode(
              wayaTheme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          callback: () => WayaNav.toNamed(WayaAppRoutes.getProfileRoute(member.userId)),
        ),

        // Some space.
        SizedBox(height: 15.h),

        //? Next, to make this person an admin.
        if (self.role != ChatMemberRole.member && member.role == ChatMemberRole.member) ...[
          WayaButton(
            text: "Make Admin",
            verticalPadding: 10.h,
            textStyle: style,
            alignment: Alignment.centerLeft,
            textColor: wayaTheme.colorScheme.customBlack,
            color: wayaTheme.colorScheme.primary.withAlpha(25),
            leadingIcon: WayaAssets.icons.personal.svg(
              height: 18.sp,
              width: 18.sp,
              colorFilter: ColorFilter.mode(
                wayaTheme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            callback: () {
              WayaNav.goBack();
              WayaUtils.showModalSheet(
                context,
                child: MakeGroupAdminModal(
                  chat: chat,
                  notifier: notifier,
                  userId: member.userId,
                ),
              );
            },
          ),

          // Some space.
          SizedBox(height: 15.h),
        ],

        //? Finally, the button to remove a member from the group.
        if (self.role != ChatMemberRole.member) ...[
          WayaButton(
            text: "Remove ${member.userData?.firstName.capitalizeFirst}",
            verticalPadding: 10.h,
            textStyle: style,
            alignment: Alignment.centerLeft,
            textColor: wayaTheme.colorScheme.error,
            color: wayaTheme.colorScheme.error.withAlpha(25),
            leadingIcon: WayaAssets.icons.chat.svg(
              height: 18.sp,
              width: 18.sp,
              colorFilter: ColorFilter.mode(
                wayaTheme.colorScheme.error,
                BlendMode.srcIn,
              ),
            ),
            callback: () {
              WayaNav.goBack();
              WayaUtils.showModalSheet(
                context,
                child: RemoveUserChatGroupModal(
                  chat: chat,
                  notifier: notifier,
                  userId: member.userId,
                ),
              );
            },
          ),

          // Some space.
          SizedBox(height: 15.h),
        ]
      ],
    );
  }
}
