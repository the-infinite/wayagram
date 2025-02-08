import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class SelectConversationWidget extends StatelessWidget {
  final ChatModel chat;
  final int index;
  final bool isSelected;
  final FutureOr<void> Function(ChatModel) onSelect;

  // Construct.
  const SelectConversationWidget({
    super.key,
    required this.chat,
    required this.index,
    required this.isSelected,
    required this.onSelect,
  });

  // This is fine too.
  @override
  Widget build(BuildContext context) {
    final unread = chat.unreadCount;

    // The thing that you are sending.
    return Padding(
      padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () => onSelect(chat),
        splashColor: WayaColors.primary.withAlpha(30),
        focusColor: WayaColors.primary.withAlpha(30),
        highlightColor: WayaColors.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? WayaColors.primary.withAlpha(30) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // The user's chat profile picture.
              ChatProfilePicture(
                user: chat.other.userData ?? ConversationState.self,
                lastSeen: chat.other.chatUser?.lastSeen,
                showActive: chat.other.chatUser?.onlineStatus == ChatUserActivity.online,
                radius: 27,
              ),

              // Some space.
              const Gap(10),

              //* For the messages part.
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* For the other person's name.
                    Text(
                      chat.name ?? chat.other.userData?.fullname ?? chat.other.chatUser?.displayName ?? "WayaGram User",
                      maxLines: 1,
                      style: WayaTextStyles.titleMedium.copyWith(
                        fontWeight: unread < 1 ? FontWeight.normal : FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    //? For the message content...
                    if (chat.other.profileData != null)
                      Text(
                        "@${chat.other.profileData!.username!}",
                        maxLines: 1,
                        style: WayaTextStyles.titleMedium.copyWith(
                          fontWeight: unread < 1 ? FontWeight.normal : FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          color: unread < 1 ? WayaColors.greyColor400 : WayaColors.greyColor500,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),

              // Some space
              const Gap(10),

              //* Selection icon
              Checkbox(
                value: isSelected,
                tristate: false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashRadius: 12,
                fillColor: WidgetStateColor.resolveWith(
                  (states) {
                    //? If this is selected...
                    if (states.contains(WidgetState.selected)) {
                      return WayaColors.primary;
                    }

                    // Since it is not.
                    return Colors.transparent;
                  },
                ),
                side: BorderSide(
                  color: isSelected ? WayaColors.greyColor300 : WayaColors.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100000),
                ),
                onChanged: (value) {
                  onSelect(chat);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
