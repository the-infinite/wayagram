import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_rich_text.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/notifications/models/default.dart';

class NotificationCardWidget extends StatefulWidget {
  final NotificationModel data;
  final int index;

  // This is now fine.
  const NotificationCardWidget({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<NotificationCardWidget> createState() => _NotificationCardWidgetState();
}

class _NotificationCardWidgetState extends State<NotificationCardWidget> {
  /// Utility function used to redirect the user to the notification details screen.
  void _toNotificationDetails() {}

  /// Utility function used to show the button that allows a user ot mark a
  /// notification as read.
  void _showMarkAction() {}

  /// Utility function used to execute the action on this notification.
  void _executeAction() {}

  // This is fine.
  @override
  Widget build(BuildContext context) {
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
                            NotificationMessageType.follower ||
                            NotificationMessageType.followRequest ||
                            NotificationMessageType.friendRequest =>
                              WayaAssets.icons.notifNewFollower.path,
                            NotificationMessageType.poll => WayaAssets.icons.notifPollResults.path,
                            NotificationMessageType.transaction => WayaAssets.icons.notifTransaction.path,
                            NotificationMessageType.groupInvite => WayaAssets.icons.notifGroupRequest.path,
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
                          WayaRichText(
                            title1: "${widget.data.message.body}.",
                            title2: " ${widget.data.notificationAction}.",
                            style1: WayaTextStyles.mediumDescriptionStyle.copyWith(
                              fontSize: 12,
                            ),
                            style2: WayaTextStyles.smallActiveLinkStyle.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            onTap2: _executeAction,
                          ),

                          // Some space.
                          const Gap(7.5),

                          //* The notification time.
                          Text(
                            WayaDateHelper.getFullTimestamp(widget.data.createdAt),
                            style: WayaTextStyles.descriptionStyle.copyWith(
                              color: WayaColors.greyColor400,
                              fontSize: 13,
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
                            color: WayaColors.primary,
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
