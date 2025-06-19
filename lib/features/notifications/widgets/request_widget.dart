import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';

class RequestCardWidget extends StatefulWidget {
  final NotificationModel data;
  final int index;

  // This is now fine.
  const RequestCardWidget({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<RequestCardWidget> createState() => _RequestCardWidgetState();
}

class _RequestCardWidgetState extends State<RequestCardWidget> {
  FollowStatusModel? _follow;

  Future<void> _getStatus() async {
    //? If this is a follow request.
    if (widget.data.messageType == NotificationMessageType.followRequest) {
      debugPrint("Follow Status: ${widget.data.message.data}, ${ConversationState.self.id}");
      final follow = await myFollowProvider.getFollowStatus(widget.data.id);

      if (mounted) {
        setState(() {
          _follow = follow;
        });
      }
    }
  }

  bool get showActions {
    //? Only show the action button when this is not yet followed.
    if (widget.data.messageType == NotificationMessageType.followRequest) {
      return _follow?.status == FollowRelationship.none;
    }

    // This is fine.
    return true;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _getStatus(),
    );

    super.initState();
  }

  /// Utility function used to redirect the user to the notification details screen.
  void _acceptRequest() async {
    final followerId = widget.data.message.followerId;
    final followingId = widget.data.message.followingId;

    //? If this is for a follow request...
    if (followerId != null && followingId != null) {
      await myFollowProvider.handleFollowRequest(followerId, followingId, FollowAction.accept);

      //? If this user is following you now....
      await _getStatus();
    }
  }

  /// Utility function used to execute the action on this notification.
  void _rejectRequest() async {
    final followerId = widget.data.message.followerId;
    final followingId = widget.data.message.followingId;

    //? If this is for a follow request...
    if (followerId != null && followingId != null) {
      await myFollowProvider.handleFollowRequest(followerId, followingId, FollowAction.reject);

      //? If this user is following you now....
      await _getStatus();
    }
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    //? If this is not a request, hide it.
    if (!widget.data.isRequest) {
      return const SizedBox.shrink();
    }

    //? Return this.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? First, the divider that only shows up on the off-chance.
        if (widget.index != 0)
          const Divider(
            color: WayaColors.greyColor400,
          ),

        //? Second, the actual component. some padding to go with this thing.
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? First, the notification icon.
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: WayaColors.primary50,
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
                      color: WayaColors.primary,
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
                        style: WayaTextStyles.bodySemiBold.copyWith(
                          color: WayaColors.customBlack,
                        ),
                      ),

                      //* The notification body.
                      Text(
                        widget.data.message.body,
                        style: WayaTextStyles.mediumDescriptionStyle.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),

                      // Some space.
                      const Gap(4),

                      //* The notification time.
                      Text(
                        WayaDateHelper.getFullTimestamp(widget.data.createdAt),
                        style: WayaTextStyles.descriptionStyle.copyWith(
                          color: WayaColors.greyColor400,
                          fontSize: 13.sp,
                        ),
                      ),

                      //? If the actions are supposed to be visible.
                      if (showActions) ...[
                        // Some space.
                        const Gap(9),

                        //* Now for the buttons that would be used to accept or reject
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Accept invite button.
                            WayaButton(
                              text: "Accept invite",
                              textColor: WayaColors.white,
                              callback: _acceptRequest,
                              color: WayaColors.primary500,
                              height: null,
                              verticalPadding: 8,
                              horizontalPadding: 12,
                            ),

                            // Some space.
                            const Gap(10),

                            // Accept invite button.
                            WayaButton(
                              text: "Decline",
                              textColor: WayaColors.customBlack,
                              callback: _rejectRequest,
                              color: WayaColors.transparent,
                              height: null,
                              verticalPadding: 8,
                              horizontalPadding: 12,
                              border: Border.all(
                                color: WayaColors.greyColor500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
