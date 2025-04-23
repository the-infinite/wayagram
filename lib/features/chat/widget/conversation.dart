import 'dart:ui';

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

class ConversationWidget extends StatefulWidget {
  final ChatModel chat;
  final ChatNotifier notifier;
  final ConversationVm conversationNotifier;
  final int index;
  final bool isInteractive;
  final bool canClick;

  // Construct.
  const ConversationWidget({
    super.key,
    required this.chat,
    required this.index,
    required this.notifier,
    required this.conversationNotifier,
    this.isInteractive = true,
    this.canClick = true,
  });

  @override
  State<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  /// Helper function used to navigate to the current chat screen.
  void _toChat() async {
    widget.conversationNotifier.dismissOverlay();
    widget.notifier.setChat((await widget.conversationNotifier.getChatDetails(widget.chat.id)) ?? widget.chat);
    widget.notifier.markAllAsRead().then((result) {
      if (!result) return;
      widget.conversationNotifier.getChats(true);
      widget.conversationNotifier.getArchivedChats(true);
    });
    WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(widget.chat.id));
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
                widget.conversationNotifier.pinOrUnpinChat(widget.chat.id);
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: WayaColors.black,
              color: Colors.transparent,
              leadingIcon: Icon(
                widget.chat.self.isPined ? CupertinoIcons.pin_slash_fill : CupertinoIcons.pin_fill,
                size: 20,
                color: WayaColors.black,
              ),
              text: widget.chat.self.isPined ? "Unpin" : "Pin",
              textStyle: WayaTextStyles.bodySemiBold.copyWith(
                fontSize: 13.sp,
              ),
            ),

            //* Second, the archive/unarchive button.
            WayaButton(
              callback: () {
                sizeNotifier.dispose();
                entry.remove();
                widget.conversationNotifier.archiveOrUnarchiveChat(widget.chat.id);
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: WayaColors.black,
              color: Colors.transparent,
              leadingIcon: Icon(
                widget.chat.self.isArchived ? CupertinoIcons.archivebox : CupertinoIcons.archivebox_fill,
                size: 20,
                color: WayaColors.black,
              ),
              text: widget.chat.self.isArchived ? "Unarchive" : "Archive",
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
                widget.chat.self.isDeletedChat ? CupertinoIcons.volume_up : CupertinoIcons.volume_off,
                size: 20,
                color: WayaColors.black,
              ),
              text: widget.chat.self.isDeletedChat ? "Unmute" : "Mute",
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
                widget.conversationNotifier.deleteChat(widget.chat.id);
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

            //? This is fine.
            return Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  //? Our background.
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                    ),
                    child: Opacity(
                      opacity: 0.6,
                      child: SizedBox(
                        child: ModalBarrier(
                          dismissible: true,
                          color: Colors.white,
                          onDismiss: () => entry.remove(),
                        ),
                      ),
                    ),
                  ),

                  //? Second, the actions and conversation component.
                  Positioned(
                    top: popupExtent > screenSize.height ? offset.dy - 10 - popupSize.height : offset.dy,
                    child: SizedBox(
                      width: screenSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        verticalDirection: popupExtent > screenSize.height ? VerticalDirection.up : VerticalDirection.down,
                        spacing: 10.h,
                        children: [
                          //? This is fine.
                          ColoredBox(
                            color: WayaColors.primary50,
                            child: ConversationWidget(
                              chat: widget.chat,
                              index: widget.index,
                              notifier: widget.notifier,
                              conversationNotifier: widget.conversationNotifier,
                              isInteractive: widget.isInteractive,
                              canClick: false,
                            ),
                          ),

                          //? The actions themselves
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: actions,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Set the overlay we are interacting with currently.
    widget.conversationNotifier.setOverlay(entry);

    // Then we do it like this.
    Overlay.of(context).insert(entry);
  }

  // This is fine too.
  @override
  Widget build(BuildContext context) {
    final isMine = widget.chat.lastMessage?.senderId == ConversationState.self.id;
    final unread = widget.chat.unreadCount;
    final userStatus = widget.chat.other.chatUser?.onlineStatus;

    // The thing that you are sending.
    return InkWell(
      onTap: widget.canClick ? _toChat : null,
      onLongPress: widget.canClick ? () => _showActions(context) : null,
      splashColor: WayaColors.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: WayaColors.primary.withAlpha(30),
      child: Padding(
        padding: !widget.isInteractive
            ? const EdgeInsets.symmetric(vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // The user's chat profile picture.
            ChatProfilePicture(
              user: widget.chat.other.userData!,
              lastSeen: widget.chat.other.chatUser?.lastSeen,
              showActive: widget.chat.chatType != ChatType.group && userStatus == ChatUserActivity.online,
              chat: widget.chat,
              radius: 25.r,
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
                    widget.chat.name ??
                        widget.chat.other.userData?.fullname ??
                        widget.chat.other.chatUser?.displayName ??
                        "WayaGram User",
                    maxLines: 1,
                    style: WayaTextStyles.titleMedium.copyWith(
                      fontWeight: unread < 1 ? FontWeight.normal : FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  //? For the message content...
                  if (widget.chat.lastMessage != null)
                    Text(
                      "${isMine ? "You: " : ""}${widget.chat.lastMessage!.contentDescription}",
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
                  WayaDateHelper.getSocialTimeAgo(widget.chat.lastMessage?.updatedAt ?? widget.chat.updatedAt),
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
                      widget.chat.unreadText,
                      style: WayaTextStyles.bodyMedium.copyWith(
                        color: WayaColors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                else if (isMine && widget.chat.lastMessage?.readAt != null)
                  WayaAssets.icons.cRead.svg(
                    color: WayaColors.primary,
                    height: 16,
                    width: 16,
                  )
                else if (isMine && widget.chat.lastMessage?.deliveredAt != null)
                  WayaAssets.icons.cRead.svg(
                    color: WayaColors.greyColor400,
                    height: 16,
                    width: 16,
                  )
                else if (isMine && widget.chat.lastMessage?.createdAt != null)
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
