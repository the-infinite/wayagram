import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class ConversationWidget extends StatelessWidget {
  final ChatModel chat;
  final ChatNotifier notifier;
  final ConversationVm conversationNotifier;
  final int index;

  // Construct.
  const ConversationWidget({
    super.key,
    required this.chat,
    required this.index,
    required this.notifier,
    required this.conversationNotifier,
  });

  /// Helper function used to navigate to the current chat screen.
  void _toChat() async {
    notifier.setChat((await conversationNotifier.getChatDetails(chat.id)) ?? chat);
    WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
  }

  // This is fine too.
  @override
  Widget build(BuildContext context) {
    final isMine = chat.lastMessage?.senderId == ConversationState.self.id;
    final unread = chat.unreadCount;

    // This is fine.
    final renderBox = context.findRenderObject() as RenderBox?;
    final mySize = renderBox?.size ?? Size(0, 70);

    // The thing that you are sending.
    return InkWell(
      splashColor: WayaColors.primary.withAlpha(30),
      focusColor: WayaColors.primary.withAlpha(30),
      highlightColor: WayaColors.primary.withAlpha(30),
      child: WayaSwiper(
        onTap: _toChat,
        swipeSensitivity: 5,
        animationDuration: const Duration(milliseconds: 350),
        rightSwipeWidget: Container(
          height: mySize.height,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //? First, the reply icon.
              Icon(
                chat.self.isArchived ? CupertinoIcons.archivebox : CupertinoIcons.archivebox_fill,
                color: WayaColors.black,
                size: 18,
              ),

              // Some space.
              const Gap(10),

              //? Second, the text for replying.
              Text(
                chat.self.isArchived ? "Unarchive chat" : "Archive chat",
                style: WayaTextStyles.bodySemiBold.copyWith(
                  color: WayaColors.black,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        onRightSwipe: (_) {
          conversationNotifier.archiveOrUnarchiveChat(chat.id);
        },
        leftSwipeWidget: Container(
          height: mySize.height,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //? First, the reply icon.
              Icon(
                chat.self.isPined ? CupertinoIcons.pin_slash_fill : CupertinoIcons.pin_fill,
                color: WayaColors.primary,
                size: 18,
              ),

              // Some space.
              const Gap(10),

              //? Second, the text for replying.
              Text(
                chat.self.isPined ? "Unpin chat" : "Pin chat",
                style: WayaTextStyles.bodySemiBold.copyWith(
                  color: WayaColors.primary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        onLeftSwipe: (_) {
          conversationNotifier.pinOrUnpinChat(chat.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    if (chat.lastMessage != null)
                      Text(
                        "${isMine ? "You: " : ""}${chat.lastMessage!.contentDescription}",
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

              //* The timing for the messages.
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First, the time.
                  Text(
                    WayaDateHelper.getTimestamp(chat.lastMessage?.updatedAt ?? chat.updatedAt),
                    style: WayaTextStyles.titleMedium.copyWith(
                      fontWeight: unread < 1 ? FontWeight.normal : FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      color: unread < 1 ? WayaColors.black : WayaColors.primary,
                      fontSize: 13,
                    ),
                  ),

                  // Some space.
                  const Gap(2),

                  // This is fine.
                  if (unread > 0)
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
      ),
    );
  }
}
