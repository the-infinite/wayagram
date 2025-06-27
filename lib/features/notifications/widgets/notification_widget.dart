import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_rich_text.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
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
      },
    );

    super.initState();
  }

  bool get showActions {
    //? If this is fine...
    if (widget.data.message.data != null) {
      return false;
    }

    //? Only show the action button when this is not yet followed.
    if (widget.data.messageType == NotificationMessageType.followRequest) {
      return _follow?.status == FollowRelationship.none;
    }

    //? Show the chat.
    if (widget.data.messageType == NotificationMessageType.chat) {
      return widget.data.message.chatId != null;
    }

    //? If this is for comments
    if (widget.data.messageType == NotificationMessageType.comment) {
      return widget.data.message.commentId != null && widget.data.message.postId != null;
    }

    //? If this is for post...
    if ([
      NotificationMessageType.share,
      NotificationMessageType.like,
    ].contains(widget.data.messageType)) {
      return widget.data.message.postId != null;
    }

    //? If this is for donations...
    if (widget.data.messageType == NotificationMessageType.donation) {
      return widget.data.message.donationId != null;
    }

    //? If this is for an event...
    if (widget.data.messageType == NotificationMessageType.event) {
      return widget.data.message.eventId != null;
    }

    //? If this is for a poll.
    if (widget.data.messageType == NotificationMessageType.poll) {
      return widget.data.message.pollId != null;
    }

    //? If this is a credit or debit alert...
    if ([
      NotificationMessageType.debitAlert,
      NotificationMessageType.creditAlert,
    ].contains(widget.data.messageType)) {
      return widget.data.message.transactionId != null;
    }

    //? If this is a quotation notification.
    if (widget.data.messageType == NotificationMessageType.getQuotation) {
      return widget.data.message.requestId != null || widget.data.message.bidId != null;
    }

    //? If this is for a group notification.
    if (widget.data.messageType == NotificationMessageType.groupInvite) {
      return widget.data.message.invitationId != null;
    }

    //? If this is for a group notification.
    if (widget.data.messageType == NotificationMessageType.groups) {
      return widget.data.message.groupId != null;
    }

    //? If this is for a page invitation.
    if (widget.data.messageType == NotificationMessageType.pages) {
      return widget.data.message.pageId != null;
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
  void _executeAction() async {
    final chatId = widget.data.message.chatId;
    final commentId = widget.data.message.commentId;
    final postId = widget.data.message.postId;
    final donationId = widget.data.message.donationId;
    final eventId = widget.data.message.eventId;
    final pollId = widget.data.message.pollId;
    final transactionId = widget.data.message.transactionId;
    final requestId = widget.data.message.requestId;
    final bidId = widget.data.message.bidId;
    final groupId = widget.data.message.groupId;
    final invitationId = widget.data.message.invitationId;
    final pageId = widget.data.message.pageId;

    //? If this in any way involves a chat...
    if (chatId != null) {
      final chat = wayaChatsCache.getCachedData(chatId) ?? await chatNotifier.getChatDetails(chatId);

      if (chat == null) {
        WayaSnackBar.showToast("This chat has been deleted");
        return;
      }
      final messagingNotifier = ref.read(chatProvider(chatId).notifier);
      chatNotifier.dismissOverlay();
      messagingNotifier.setChat(chat);
      messagingNotifier.markAllAsRead().then((result) {
        if (!result) return;
        chatNotifier.getChats(true);
        chatNotifier.getArchivedChats(true);
      });
      WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chatId));
    }

    //? If comment ID is not undefined.
    if (commentId != null && postId != null) {
      WayaNav.toNamed(WayaAppRoutes.getCommentDetailsScreen(commentId, postId));
    }

    //? If this is for a post...
    if (postId != null) {
      WayaNav.toNamed(WayaAppRoutes.getSinglePostScreen(postId));
    }

    //? If this is for a donation post...
    if (donationId != null) {
      WayaNav.toNamed(WayaAppRoutes.getDonationDetailsPage(donationId));
    }

    //? If this is for an event...
    if (eventId != null) {
      WayaNav.toNamed(WayaAppRoutes.getEventDetailsScreen(eventId));
    }

    //? If this is for a poll.
    if (pollId != null) {
      WayaNav.toNamed(WayaAppRoutes.getPollDetailsPage(pollId));
    }

    //? If this is for a poll.
    if (transactionId != null) {
      WayaNav.toNamed(WayaAppRoutes.getWalletDetailsPage(transactionId));
    }

    //? If this is for a quotation...
    if (bidId != null && requestId != null) {
      WayaNav.toNamed(WayaAppRoutes.getBidDetailsScreen(bidId, requestId));
    }
    if (requestId != null) {
      WayaNav.toNamed(WayaAppRoutes.getBuyerBidsRoute(requestId));
    }

    //? If this is for a group invitation notification...
    if (groupId != null && invitationId != null) {
      WayaNav.toNamed(WayaAppRoutes.getGroupInvitation(invitationId));
    }

    //? If this is for a group...
    if (groupId != null) {
      WayaNav.toNamed(WayaAppRoutes.getGroupDetailsPage(groupId));
    }

    //? If this is for a page invitation...
    if (pageId != null && invitationId != null) {
      WayaNav.toNamed(WayaAppRoutes.getPageInvitation(invitationId));
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
