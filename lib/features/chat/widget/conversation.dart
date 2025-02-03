import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/widget/profile_picture.dart';

class ConversationWidget extends StatelessWidget {
  final ChatModel chat;
  final ChatNotifier notifier;
  final int index;

  // Construct.
  const ConversationWidget({
    super.key,
    required this.chat,
    required this.index,
    required this.notifier,
  });

  /// Helper function used to navigate to the current chat screen.
  void _toChat() {
    notifier.setChat(chat);
    WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
  }

  // This is fine too.
  @override
  Widget build(BuildContext context) {
    final isMine = chat.lastMessage.senderId == ConversationState.self.id;

    // The thing that you are sending.
    return InkWell(
      onTap: _toChat,
      splashColor: WayaColors.primary.withAlpha(30),
      focusColor: WayaColors.primary.withAlpha(30),
      highlightColor: WayaColors.primary.withAlpha(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // The user's chat profile picture.
            ChatProfilePicture(
              user: chat.other,
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
                    "${chat.other.firstName} ${chat.other.lastName}",
                    maxLines: 1,
                    style: WayaTextStyles.titleMedium.copyWith(
                      fontWeight: chat.unread.isEmpty ? FontWeight.normal : FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  //? For the message content...
                  Text(
                    "${isMine ? "You: " : ""}${chat.lastMessage.contentDescription}",
                    maxLines: 1,
                    style: WayaTextStyles.titleMedium.copyWith(
                      fontWeight: chat.unread.isEmpty ? FontWeight.normal : FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      color: chat.unread.isEmpty ? WayaColors.greyColor400 : WayaColors.greyColor500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Some space
            const Gap(10),

            //* The timing for the messages.
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First, the time.
                Text(
                  WayaDateHelper.getTimestamp(chat.lastMessage.updatedAt),
                  style: WayaTextStyles.titleMedium.copyWith(
                    fontWeight: chat.unread.isEmpty ? FontWeight.normal : FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    color: chat.unread.isEmpty ? WayaColors.black : WayaColors.primary,
                    fontSize: 13,
                  ),
                ),

                // Some space.
                const Gap(2),

                // This is fine.
                if (chat.unread.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      color: WayaColors.primary,
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: Text(
                      chat.unreadText,
                      style: WayaTextStyles.bodyMedium.copyWith(
                        color: WayaColors.white,
                        fontSize: 14,
                      ),
                    ),
                  )
                else if (isMine)
                  WayaAssets.icons.cRead.svg(
                    color: WayaColors.greyColor400,
                    height: 16,
                    width: 16,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
