import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/delete.dart';
import 'package:wayagram/features/chat/modals/group/mute.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/conversation_vm.dart';
import 'package:wayagram/shared/cache/chat.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class ConversationWidget extends ConsumerStatefulWidget {
  final String chatId;
  final ChatNotifier notifier;
  final ConversationVm conversationNotifier;
  final int index;
  final bool isInteractive;
  final bool canClick;

  // Construct.
  const ConversationWidget({
    super.key,
    required this.chatId,
    required this.index,
    required this.notifier,
    required this.conversationNotifier,
    this.isInteractive = true,
    this.canClick = true,
  });

  @override
  ConsumerState<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends ConsumerState<ConversationWidget>
    with AutomaticKeepAliveClientMixin<ConversationWidget> {
  Timer? _timer;

  /// Helper function used to navigate to the current chat screen.
  void _toChat() async {
    final chat = wayaChatsCache.getCachedData(widget.chatId)!;
    final data = await widget.conversationNotifier.getChatDetails(chat.id);
    widget.conversationNotifier.dismissOverlay();
    widget.notifier.setChat(data ?? chat);
    widget.notifier.markAllAsRead().then((result) {
      if (!result) return;
      widget.conversationNotifier.getChats(true);
      widget.conversationNotifier.getArchivedChats(true);
    });

    WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
  }

  //? This is how we show actions.
  void _showActions(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox?;
    final chat = wayaChatsCache.getCachedData(widget.chatId)!;
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
                widget.conversationNotifier.pinOrUnpinChat(chat.id);
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: WayaColors.black,
              color: Colors.transparent,
              leadingIcon: Icon(
                chat.self?.isPined ?? false
                    ? CupertinoIcons.pin_slash_fill
                    : CupertinoIcons.pin_fill,
                size: 20,
                color: WayaColors.black,
              ),
              text: chat.self?.isPined ?? false ? "Unpin" : "Pin",
              textStyle: WayaTextStyles.bodySemiBold.copyWith(
                fontSize: 13.sp,
              ),
            ),

            //* Second, the archive/unarchive button.
            WayaButton(
              callback: () {
                sizeNotifier.dispose();
                entry.remove();
                widget.conversationNotifier.archiveOrUnarchiveChat(chat.id);
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: WayaColors.black,
              color: Colors.transparent,
              leadingIcon: Icon(
                chat.self?.isArchived ?? false
                    ? CupertinoIcons.archivebox
                    : CupertinoIcons.archivebox_fill,
                size: 20,
                color: WayaColors.black,
              ),
              text: chat.self?.isArchived ?? false ? "Unarchive" : "Archive",
              textStyle: WayaTextStyles.bodySemiBold.copyWith(
                fontSize: 13.sp,
              ),
            ),

            //* Third, the mute/unmute button.
            WayaButton(
              callback: () {
                sizeNotifier.dispose();
                entry.remove();
                if (chat.self?.isMuted ?? false) {
                  widget.conversationNotifier.muteOrUnmuteGroup(chat.id, null);
                } else {
                  WayaUtils.showModalSheet(
                    context,
                    child: MuteChatGroupModal(
                      chat: chat,
                      notifier: widget.conversationNotifier,
                    ),
                  );
                }
              },
              height: null,
              alignment: Alignment.centerLeft,
              verticalPadding: 8,
              horizontalPadding: 8,
              textColor: chat.self?.isMuted ?? false
                  ? WayaColors.black
                  : WayaColors.error,
              color: Colors.transparent,
              leadingIcon: SvgPicture.asset(
                chat.self?.isMuted ?? false
                    ? WayaAssets.icons.cProfileUnmute.path
                    : WayaAssets.icons.cProfileMute.path,
                height: 20.sp,
                colorFilter: ColorFilter.mode(
                  chat.self?.isMuted == true
                      ? WayaColors.black
                      : WayaColors.error,
                  BlendMode.srcIn,
                ),
              ),
              text: chat.self?.isMuted ?? false ? "Unmute" : "Mute",
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
                WayaUtils.showModalSheet(
                  context,
                  isDismissible: false,
                  child: DeleteChatModal(
                    chat: chat,
                    notifier: widget.conversationNotifier,
                  ),
                );
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
                colorFilter: ColorFilter.mode(
                  WayaColors.error,
                  BlendMode.srcIn,
                ),
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
            final popupExtent =
                offset.dy + mySize.height + popupSize.height + 5;

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
                    top: popupExtent > screenSize.height
                        ? offset.dy - 10 - popupSize.height
                        : offset.dy,
                    child: SizedBox(
                      width: screenSize.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        verticalDirection: popupExtent > screenSize.height
                            ? VerticalDirection.up
                            : VerticalDirection.down,
                        spacing: 10.h,
                        children: [
                          //? This is fine.
                          ColoredBox(
                            color: WayaColors.primary50,
                            child: ConversationWidget(
                              chatId: chat.id,
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 8),
      (_) => widget.conversationNotifier.getChatDetails(widget.chatId),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: wayaChatsCache,
      builder: (context, redraws, _) {
        final chat = wayaChatsCache.getCachedData(widget.chatId);
        if (chat == null) return const SizedBox.shrink();

        return _ConversationContent(
          chat: chat,
          widget: widget,
          onTap: widget.canClick ? _toChat : null,
          onLongPress: widget.canClick ? () => _showActions(context) : null,
        );
      },
    );
  }
}

class _ConversationContent extends ConsumerWidget {
  final ChatModel chat;
  final ConversationWidget widget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _ConversationContent({
    required this.chat,
    required this.widget,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumerState = ref.watch(conversationProvider);
    final chatData = _ChatDisplayData.fromChat(chat, consumerState);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      splashColor: WayaColors.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: WayaColors.primary.withAlpha(30),
      child: Padding(
        padding: widget.isInteractive
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 5)
            : const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            _buildProfilePicture(chatData),
            const Gap(10),
            Expanded(child: _buildMessageContent(chatData)),
            const Gap(10),
            _buildTimingColumn(chatData),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture(_ChatDisplayData data) {
    return ChatProfilePicture(
      user: data.otherUserData,
      lastSeen: data.lastSeen,
      showActive: data.shouldShowActive,
      chat: chat,
      radius: 25.r,
    );
  }

  Widget _buildMessageContent(_ChatDisplayData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.displayName,
          maxLines: 1,
          style: WayaTextStyles.titleMedium.copyWith(
            fontWeight: data.hasUnread ? FontWeight.w600 : FontWeight.normal,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (data.lastMessageContent != null)
          Text(
            data.lastMessageContent!,
            maxLines: 1,
            style: WayaTextStyles.titleMedium.copyWith(
              fontWeight: data.hasUnread ? FontWeight.w600 : FontWeight.normal,
              overflow: TextOverflow.ellipsis,
              fontStyle: data.isItalic ? FontStyle.italic : null,
              color: data.hasUnread
                  ? WayaColors.greyColor500
                  : WayaColors.greyColor400,
              fontSize: 14.sp,
            ),
          ),
      ],
    );
  }

  Widget _buildTimingColumn(_ChatDisplayData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          WayaDateHelper.getSocialTimeAgo(data.lastUpdateTime),
          style: WayaTextStyles.titleMedium.copyWith(
            fontWeight: data.hasUnread ? FontWeight.w600 : FontWeight.normal,
            overflow: TextOverflow.ellipsis,
            color: data.hasUnread ? WayaColors.primary : WayaColors.black,
            fontSize: 13.sp,
          ),
        ),
        const Gap(2),
        _buildStatusIndicator(data),
      ],
    );
  }

  Widget _buildStatusIndicator(_ChatDisplayData data) {
    if (data.isBlocked || data.isDeleted) {
      return const SizedBox.shrink();
    }

    if (data.isMuted) {
      return WayaAssets.icons.cProfileUnmute.svg(
        height: 16.sp,
        width: 16.sp,
        colorFilter: const ColorFilter.mode(
          WayaColors.error,
          BlendMode.srcIn,
        ),
      );
    }

    if (data.hasUnread) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: WayaColors.primary,
          borderRadius: BorderRadius.circular(500),
        ),
        child: Text(
          data.unreadText,
          style: WayaTextStyles.bodyMedium.copyWith(
            color: WayaColors.white,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return _buildMessageStatusIcon(data);
  }

  Widget _buildMessageStatusIcon(_ChatDisplayData data) {
    if (!data.isMineMessage || data.lastMessage == null) {
      return const SizedBox.shrink();
    }

    Widget? statusIcon;
    Color iconColor = WayaColors.greyColor400;

    if (data.lastMessage?.readAt != null) {
      statusIcon = WayaAssets.icons.cRead.svg(height: 16, width: 16);
      iconColor = WayaColors.primary;
    } else if (data.lastMessage?.deliveredAt != null) {
      statusIcon = WayaAssets.icons.cRead.svg(height: 16, width: 16);
    } else if (data.lastMessage?.createdAt != null) {
      statusIcon = WayaAssets.icons.cSent.svg(height: 16, width: 16);
    }

    return statusIcon != null
        ? ColorFiltered(
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            child: statusIcon,
          )
        : const SizedBox.shrink();
  }
}

class _ChatDisplayData {
  final bool isMineMessage;
  final bool isDeleted;
  final bool isBlocked;
  final bool hasUnread;
  final bool isMuted;
  final bool shouldShowActive;
  final bool isItalic;
  final String displayName;
  final String? lastMessageContent;
  final String unreadText;
  final DateTime lastUpdateTime;
  final UserDetailsModel otherUserData;
  final DateTime? lastSeen;
  final MessageModel? lastMessage;

  const _ChatDisplayData({
    required this.isMineMessage,
    required this.isDeleted,
    required this.isBlocked,
    required this.hasUnread,
    required this.isMuted,
    required this.shouldShowActive,
    required this.isItalic,
    required this.displayName,
    required this.lastMessageContent,
    required this.unreadText,
    required this.lastUpdateTime,
    required this.otherUserData,
    required this.lastSeen,
    required this.lastMessage,
  });

  factory _ChatDisplayData.fromChat(
      ChatModel chat, ConversationState consumerState) {
    final isMine = chat.lastMessage?.senderId == ConversationState.self.id;
    final isDeleted =
        chat.lastMessage?.myStatus?.status == MessageStatusCode.deleted ||
            (chat.lastMessage?.isDeleted ?? false) ||
            (chat.lastMessage?.isDeletedBySender ?? false);
    final isBlocked = chat.chatType == ChatType.personal &&
        consumerState.isBlocked(chat.other.userId);
    final unread = chat.unreadCount;
    final userStatus = chat.other.chatUser?.onlineStatus;

    String? messageContent;
    if (chat.lastMessage != null) {
      if (isBlocked) {
        messageContent = "This user was blocked";
      } else if (isDeleted) {
        messageContent = "This message was deleted";
      } else {
        messageContent =
            "${isMine ? "You: " : ""}${chat.lastMessage?.contentDescription ?? ''}";
      }
    }

    return _ChatDisplayData(
      isMineMessage: isMine,
      isDeleted: isDeleted,
      isBlocked: isBlocked,
      hasUnread: unread > 0,
      isMuted: chat.self?.isMuted ?? false,
      shouldShowActive: chat.chatType != ChatType.group &&
          userStatus == ChatUserActivity.online,
      isItalic: isBlocked || isDeleted,
      displayName: chat.name ??
          chat.other.userData?.fullname ??
          chat.other.chatUser?.displayName ??
          "WayaGram User",
      lastMessageContent: messageContent,
      unreadText: chat.unreadText,
      lastUpdateTime: chat.lastMessage?.updatedAt ?? chat.updatedAt,
      otherUserData: chat.other.userData!,
      lastSeen: chat.other.chatUser?.lastSeen,
      lastMessage: chat.lastMessage,
    );
  }
}
