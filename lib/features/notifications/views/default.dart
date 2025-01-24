import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/notifications/views/all_notifications.dart';
import 'package:wayagram/features/notifications/views/requests.dart';
import 'package:wayagram/features/notifications/vm/default.dart';
import 'package:wayagram/features/notifications/widgets/filter_items.dart';

class WayaNotifications extends ConsumerStatefulWidget {
  static const route = '/notifications';
  const WayaNotifications({super.key});

  @override
  ConsumerState<WayaNotifications> createState() => _WayaNotificationsState();
}

class _WayaNotificationsState extends ConsumerState<WayaNotifications> with TickerProviderStateMixin {
  TabController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = TabController(length: 2, vsync: this);

    // This is fine.
    _pageController?.addListener(() {
      final value = _pageController?.index;
      final notifier = ref.watch(notificationProvider.notifier);

      // Notify this guy.
      notifier.setIsRequestsOnly(value == 1);
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _pageController = null;
    super.dispose();
  }

  /// Controller utility function used to mark all the notifications as read. A
  /// boatload of useful because sometimes people want to forget how many pending
  /// notifications they have.
  void _markAllAsRead() async {}

  @override
  Widget build(BuildContext context) {
    //final wayaTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final state = ref.watch(notificationProvider);
    final notifier = ref.watch(notificationProvider.notifier);

    // Build the current screen.
    return WayaScaffold(
      isLoading: state.isLoading,
      isScrollable: false,
      progressIndicator: Material(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: WayaColors.cardBackgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress indicator first.
              const CircularProgressIndicator(),

              // Some space here.
              const SizedBox(height: 10),

              // Some space.
              Text(
                "Getting your notifications...",
                style: WayaTextStyles.bodyMedium.copyWith(
                  color: WayaColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      title: 'Notifications',
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: _markAllAsRead,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Mark All As Read",
              style: WayaTextStyles.bodyMedium.copyWith(
                color: WayaColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
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
            TabBar(
              indicator: BoxDecoration(
                color: WayaColors.primary50,
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: (index) {
                notifier.setIsRequestsOnly(index == 1);
              },
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: WayaColors.transparent,
              controller: _pageController,
              tabs: [
                Tab(text: "All Notifications"),
                Tab(text: "Requests"),
              ],
            ),

            // Some space.
            const Gap(10),

            // Filter this.
            NotificationFilterWidget(
              all: state.notifications,
              hintText: "Search ${state.requestsOnly ? 'requests' : 'notifications'}",
              value: state.filters,
            ),

            // More space.
            const Gap(10),

            // This is fine.
            Expanded(
              child: TabBarView(
                controller: _pageController,
                children: [
                  //? First, the screen for all notifications.
                  AllNotifications(data: state.currentNotifications),

                  //? Second, the screen for request-type notifications.
                  RequestNotifications(data: state.currentNotifications),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
