import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/explore/vm/social_notifications.dart';
import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/widgets/notification_widget.dart';
import 'package:wayagram/features/notifications/widgets/request_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

import 'filter.dart';

class WayaSocialNotificationsScreen extends ConsumerStatefulWidget {
  static const route = "/notifications/social";
  const WayaSocialNotificationsScreen({super.key});

  @override
  ConsumerState<WayaSocialNotificationsScreen> createState() =>
      _WayaSocialNotificationsScreenState();
}

class _WayaSocialNotificationsScreenState
    extends ConsumerState<WayaSocialNotificationsScreen> {
  late final notifier = ref.read(socialNotificationProvider.notifier);

  @override
  void initState() {
    //? Get the user's notifications.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => notifier.getUserNotifications());

    //? Now, do the needful.
    super.initState();
  }

  /// Controller utility function used to mark all the notifications as read. A
  /// boatload of useful because sometimes people want to forget how many pending
  /// notifications they have.
  void _markAllAsRead() async {}

  //
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(socialNotificationProvider);
    final currentNotifications = state.currentNotifications();

    // Build the current screen.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'Social Notifications',
      resizeToAvoidBottomInset: currentNotifications.isEmpty,
      floatingActionButton: WayaButton(
        callback: _markAllAsRead,
        height: 50,
        width: 50,
        centerWidget: Center(
          child: Icon(
            Icons.done_all,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter this.
            SocialNotificationFilterWidget(
              all: state.notifications,
              hintText: "Search notifications",
              value: state.filters,
            ),

            //? Now for the notifications view.
            if (currentNotifications.isEmpty)
              Expanded(
                child: Center(
                  child: EmptyState(
                    assetImage: WayaAssets.icons.emptyState.svg(),
                    message: "Nothing to show yet",
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => notifier.getUserNotifications(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        currentNotifications.length,
                        (index) {
                          final notification = currentNotifications[index];

                          //? If this is a request.
                          if (const [
                            NotificationMessageType.followRequest,
                            NotificationMessageType.groupInvite,
                          ].contains(notification.messageType)) {
                            return RequestCardWidget(
                              index: index,
                              data: notification,
                            );
                          }

                          //? This is fine.
                          return NotificationCardWidget(
                            index: index,
                            data: notification,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
