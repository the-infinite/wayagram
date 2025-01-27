import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/general_settings/notifications/vm/default.dart';
import 'package:wayagram/features/general_settings/notifications/widget/notification_switch.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  static const route = "/settings/notifications";

  // Then this is fine.
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final state = ref.watch(notificationSettingsProvider);
    final notifier = ref.watch(notificationSettingsProvider.notifier);

    // Now, the widget itself.
    return WayaScaffold(
      isLoading: state.isLoading,
      isScrollable: false,
      backgroundColor: WayaColors.scaffoldColor,
      progressIndicator: Material(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      title: 'Notification Settings',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //? First, for activity alerts.
                Text(
                  "Activity Alerts",
                  style: WayaTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor400,
                  ),
                ),

                // Some space.
                const Gap(10),

                //* The switch for chat notifications.
                NotificationSwitchButton(
                  name: "Show notifications for chat",
                  description: "Receive notifications when you get new messages",
                  value: state.showChat,
                  uid: "show-chat",
                  notifier: notifier,
                ),

                //* The switch for call notifications.
                NotificationSwitchButton(
                  name: "Show notifications for call",
                  description: "Get alerts for incoming calls so you never miss one",
                  value: state.showCall,
                  uid: "show-call",
                  notifier: notifier,
                ),

                //* The switch for follow request notifications.
                NotificationSwitchButton(
                  name: "Show notifications for follow requests",
                  description: "Receive alerts when someone wants to follow you",
                  value: state.showFollowRequest,
                  uid: "show-follow-request",
                  notifier: notifier,
                ),

                //* The switch for like notifications.
                NotificationSwitchButton(
                  name: "Show notifications for likes",
                  description: "Get notified when people like your posts",
                  value: state.showLikes,
                  uid: "show-like",
                  notifier: notifier,
                ),

                //* The switch for comment notifications.
                NotificationSwitchButton(
                  name: "Show notifications for comments",
                  description: "Receive alerts for new comments on your posts",
                  value: state.showComments,
                  uid: "show-comment",
                  notifier: notifier,
                ),

                //* The switch for share notifications.
                NotificationSwitchButton(
                  name: "Show notifications for shared posts",
                  description: "Be notified when your posts are shared by others",
                  value: state.showShares,
                  uid: "show-shares",
                  notifier: notifier,
                ),

                //* The switch for views notifications.
                NotificationSwitchButton(
                  name: "Show notifications for views",
                  description: "Get updates on how many people have viewed your posts or profile",
                  value: state.showViews,
                  uid: "show-views",
                  notifier: notifier,
                ),

                // Some space.
                const Gap(15),

                //? Second, for events and live streams alerts.
                Text(
                  "Events & Livestream",
                  style: WayaTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor400,
                  ),
                ),

                // Some space.
                const Gap(10),

                //* The switch for event notifications.
                NotificationSwitchButton(
                  name: "Show notifications for events",
                  description: "Receive reminders and alerts for events you're attending or interested in",
                  value: state.showEvents,
                  uid: "show-events",
                  notifier: notifier,
                ),

                //* The switch for livestream notifications.
                NotificationSwitchButton(
                  name: "Show notifications for livestream",
                  description: "Get notified when a livestream you follow goes live",
                  value: state.showLivestream,
                  uid: "show-livestream",
                  notifier: notifier,
                ),

                // Some space.
                const Gap(15),

                //? First, for activity alerts.
                Text(
                  "Transaction notifications",
                  style: WayaTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor400,
                  ),
                ),

                // Some space.
                const Gap(10),

                //* The switch for debit transaction notifications.
                NotificationSwitchButton(
                  name: "Debit transaction alerts",
                  description: "Stay informed with notifications for every debit transaction on your account",
                  value: state.showDebit,
                  uid: "show-debit-transaction",
                  notifier: notifier,
                ),

                //* The switch for credit transaction notifications.
                NotificationSwitchButton(
                  name: "Credit transaction alerts",
                  description: "Receive alerts whenever money enters your wallet",
                  value: state.showCredit,
                  uid: "show-credit-transaction",
                  notifier: notifier,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
