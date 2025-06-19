import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_rich_text.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/shared/cache/chat.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';

class NotificationCardWidget extends ConsumerStatefulWidget {
  final NotificationModel data;
  final int index;

  // This is now fine.
  const NotificationCardWidget({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  ConsumerState<NotificationCardWidget> createState() => _NotificationCardWidgetState();
}

class _NotificationCardWidgetState extends ConsumerState<NotificationCardWidget> {
  late final chatNotifier = ref.read(conversationProvider.notifier);
  FollowStatusModel? _follow;
  ChatModel? _chat;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? If this is a follow request.
        if (widget.data.messageType == NotificationMessageType.followRequest) {
          debugPrint("Follow Status: ${widget.data.message.data}, ${ConversationState.self.id}");
          final follow = await myFollowProvider.getFollowStatus(widget.data.id);

          //? If mounted...
          if (mounted) {
            setState(() => _follow = follow);
          }
        }

        //? If this is a chat notification.
        if (widget.data.messageType == NotificationMessageType.chat) {
          final id = widget.data.message.chatId.toString();
          final chat = chatNotifier.getChat(id) ?? await chatNotifier.getChatDetails(id);

          //? Then run the update.
          if (mounted) {
            setState(() {
              _chat = chat;
            });
          }
        }
      },
    );

    super.initState();
  }

  bool get showActions {
    //? Only show the action button when this is not yet followed.
    if (widget.data.messageType == NotificationMessageType.followRequest) {
      return _follow?.status == FollowRelationship.none;
    }

    //? Show the chat.
    if (widget.data.messageType == NotificationMessageType.chat) {
      return _chat != null;
    }

    // This is fine.
    return true;
  }

  /// Utility function used to redirect the user to the notification details screen.
  void _toNotificationDetails() {}

  /// Utility function used to show the button that allows a user ot mark a
  /// notification as read.
  void _showMarkAction() {}

  /// Utility function used to execute the action on this notification.
  void _executeAction() {
    //? If this in any way involves a chat...
    if (_chat != null) {
      final chat = wayaChatsCache.getCachedData(_chat!.id);
      final messagingNotifier = ref.read(chatProvider(_chat!.id).notifier);
      chatNotifier.dismissOverlay();
      messagingNotifier.setChat(chat ?? _chat!);
      messagingNotifier.markAllAsRead().then((result) {
        if (!result) return;
        chatNotifier.getChats(true);
        chatNotifier.getArchivedChats(true);
      });
      WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(_chat!.id));
    }
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return this one.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? First, the divider that only shows up on the off-chance.
        if (widget.index != 0)
          Divider(
            color: wayaTheme.colorScheme.greyColor400,
          ),

        //? Second, the actual component. some padding to go with this thing.
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Material(
              child: GestureDetector(
                onTap: _toNotificationDetails,
                onDoubleTap: _showMarkAction,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? First, the notification icon.
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.primary50,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: SvgPicture.asset(
                          switch (widget.data.messageType) {
                            NotificationMessageType.chat => WayaAssets.icons.notifNewMessage.path,
                            NotificationMessageType.comment => WayaAssets.icons.notifNewComment.path,
                            NotificationMessageType.donation => WayaAssets.icons.notifNewDonation.path,
                            NotificationMessageType.event => WayaAssets.icons.notifUpcomingEvent.path,
                            NotificationMessageType.followRequest => WayaAssets.icons.notifNewFollower.path,
                            NotificationMessageType.poll => WayaAssets.icons.notifPollResults.path,
                            NotificationMessageType.creditAlert ||
                            NotificationMessageType.debitAlert ||
                            NotificationMessageType.getQuotation =>
                              WayaAssets.icons.notifTransaction.path,
                            NotificationMessageType.groupInvite ||
                            NotificationMessageType.groups ||
                            NotificationMessageType.pages =>
                              WayaAssets.icons.notifGroupRequest.path,
                            NotificationMessageType.calls => WayaAssets.icons.notifCall.path,
                            NotificationMessageType.like => WayaAssets.icons.notifLike.path,
                            NotificationMessageType.share => WayaAssets.icons.notifShare.path,
                            NotificationMessageType.view => WayaAssets.icons.notifView.path,
                            NotificationMessageType.liveStream => WayaAssets.icons.notifLivestream.path,
                            NotificationMessageType.uncategorized => WayaAssets.icons.notifications.path,
                            NotificationMessageType.supportNotification ||
                            NotificationMessageType.disputeNotification =>
                              WayaAssets.icons.cAttachContact.path,
                          },
                          height: 22,
                          width: 22,
                          color: wayaTheme.colorScheme.primary,
                        ),
                      ),
                    ),

                    // Some space.
                    const Gap(10),

                    //? Second, the notification details.
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* The notification title.
                          Text(
                            widget.data.message.subject,
                            style: wayaTheme.textTheme.bodySemiBold.copyWith(
                              color: wayaTheme.colorScheme.customBlack,
                            ),
                          ),

                          //* The notification body.
                          WayaRichText(
                            title1: "${widget.data.message.body}.",
                            title2: !showActions || (widget.data.notificationAction?.isEmpty ?? true)
                                ? null
                                : widget.data.notificationAction!,
                            style1: wayaTheme.textTheme.mediumDescriptionStyle.copyWith(
                              fontSize: 12.sp,
                            ),
                            style2: WayaTextStyles.smallActiveLinkStyle.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            onTap2: widget.data.notificationAction?.isEmpty ?? true ? null : _executeAction,
                          ),

                          // Some space.
                          const Gap(7.5),

                          //* The notification time.
                          Text(
                            WayaDateHelper.getFullTimestamp(widget.data.createdAt),
                            style: wayaTheme.textTheme.descriptionStyle.copyWith(
                              color: wayaTheme.colorScheme.greyColor400,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //? Last of all, our unread indicator.
                    if (!widget.data.read) ...[
                      // Some space.
                      const Gap(10),

                      // Now, for our unread icon.
                      SizedBox(
                        height: double.infinity,
                        child: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
