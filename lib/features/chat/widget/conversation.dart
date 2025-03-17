import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
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
  final bool isInteractive;

  // Construct.
  const ConversationWidget({
    super.key,
    required this.chat,
    required this.index,
    required this.notifier,
    required this.conversationNotifier,
    this.isInteractive = true,
  });

  /// Helper function used to navigate to the current chat screen.
  void _toChat() async {
    conversationNotifier.dismissOverlay();
    notifier.setChat((await conversationNotifier.getChatDetails(chat.id)) ?? chat);
    notifier.markAllAsRead().then((result) {
      if (!result) return;
      conversationNotifier.getChats(true);
      conversationNotifier.getArchivedChats(true);
    });
    WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
  }

  //? This is how we show actions.
  void _showActions(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox?;
    final mySize = renderBox?.size;
    final screenSize = MediaQuery.sizeOf(context);
    final sizeNotifier = ValueNotifier(Size.zero);

    // If we do  not find the renderBox
    if (mySize == null || renderBox == null) {
      return;
    }

    // This is fine.
    final offset = renderBox.localToGlobal(Offset.zero);

    //? Then we need to insert this overlay to the widget tree.
    late final OverlayEntry entry;

    //? These are our actions.
    final actions = WayaMeasurableWidget(
      onSized: (size) {
        sizeNotifier.value = size;
      },
      child: Container(
        width: screenSize.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: WayaColors.greyColor200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* First, the pin/unpin button.
            WayaButton(
              callback: () {
                sizeNotifier.dispose();
                entry.remove();
                conversationNotifier.pinOrUnpinChat(chat.id);
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: WayaColors.black,
              color: Colors.transparent,
              leadingIcon: Icon(
                chat.self.isPined ? CupertinoIcons.pin_slash_fill : CupertinoIcons.pin_fill,
                size: 20,
                color: WayaColors.black,
              ),
              text: chat.self.isPined ? "Unpin" : "Pin",
              textStyle: WayaTextStyles.bodySemiBold.copyWith(
                fontSize: 13.sp,
              ),
            ),

            //* Second, the archive/unarchive button.
            WayaButton(
              callback: () {
                sizeNotifier.dispose();
                entry.remove();
                conversationNotifier.archiveOrUnarchiveChat(chat.id);
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: WayaColors.black,
              color: Colors.transparent,
              leadingIcon: Icon(
                chat.self.isArchived ? CupertinoIcons.archivebox : CupertinoIcons.archivebox_fill,
                size: 20,
                color: WayaColors.black,
              ),
              text: chat.self.isArchived ? "Unarchive" : "Archive",
              textStyle: WayaTextStyles.bodySemiBold.copyWith(
                fontSize: 13.sp,
              ),
            ),

            //* Third, the mute/unmute button.
            WayaButton(
              callback: () {
                sizeNotifier.dispose();
                entry.remove();
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: WayaColors.black,
              color: Colors.transparent,
              leadingIcon: Icon(
                chat.self.isDeletedChat ? CupertinoIcons.volume_up : CupertinoIcons.volume_off,
                size: 20,
                color: WayaColors.black,
              ),
              text: chat.self.isDeletedChat ? "Unmute" : "Mute",
              textStyle: WayaTextStyles.bodySemiBold.copyWith(
                fontSize: 13.sp,
              ),
            ),

            // The divider.
            const Divider(
              color: WayaColors.greyColor200,
            ),

            //* Fourth, the delete button.
            WayaButton(
              callback: () {
                sizeNotifier.dispose();
                entry.remove();
                conversationNotifier.deleteChat(chat.id);
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              color: Colors.transparent,
              textColor: WayaColors.error,
              leadingIcon: WayaAssets.icons.cBin.svg(
                height: 20,
                width: 20,
                color: WayaColors.error,
              ),
              text: "Delete conversation",
              textStyle: WayaTextStyles.bodySemiBold.copyWith(
                fontSize: 13.sp,
              ),
            ),

            // Some space.
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    //? The actual overlay.
    entry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: sizeNotifier,
          builder: (context, popupSize, _) {
            final popupExtent = offset.dy + mySize.height + popupSize.height + 5;
            return Positioned(
              left: 20,
              top: popupExtent > screenSize.height ? offset.dy - 10 - popupSize.height : offset.dy + 10 + mySize.height,
              child: Material(
                color: Colors.transparent,
                child: actions,
              ),
            );
          },
        );
      },
    );

    // Set the overlay we are interacting with currently.
    conversationNotifier.setOverlay(entry);

    // Then we do it like this.
    Overlay.of(context).insert(entry);
  }

  // This is fine too.
  @override
  Widget build(BuildContext context) {
    final isMine = chat.lastMessage?.senderId == ConversationState.self.id;
    final unread = chat.unreadCount;

    // The thing that you are sending.
    return InkWell(
      onTap: _toChat,
      onLongPress: () => _showActions(context),
      splashColor: WayaColors.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: WayaColors.primary.withAlpha(30),
      child: Padding(
        padding: !isInteractive
            ? const EdgeInsets.symmetric(vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // The user's chat profile picture.
            ChatProfilePicture(
              user: chat.other.userData!,
              lastSeen: chat.other.chatUser?.lastSeen,
              showActive: chat.other.chatUser?.onlineStatus == ChatUserActivity.online,
              radius: 25,
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
                        fontSize: 14.sp,
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
                    fontSize: 13.sp,
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
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                else if (isMine && chat.lastMessage?.readAt != null)
                  WayaAssets.icons.cRead.svg(
                    color: WayaColors.primary,
                    height: 16,
                    width: 16,
                  )
                else if (isMine && chat.lastMessage?.deliveredAt != null)
                  WayaAssets.icons.cRead.svg(
                    color: WayaColors.greyColor400,
                    height: 16,
                    width: 16,
                  )
                else if (isMine && chat.lastMessage?.createdAt != null)
                  WayaAssets.icons.cSent.svg(
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
