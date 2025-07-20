import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class _WayaNotificationsState extends ConsumerState<WayaNotifications>
    with TickerProviderStateMixin {
  late final notifier = ref.read(notificationProvider.notifier);
  TabController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = TabController(length: 2, vsync: this);

    // This is fine.
    _pageController?.addListener(() {
      final value = _pageController?.index;

      // Notify this guy.
      notifier.setIsRequestsOnly(value == 1);
    });

    //? Get the user's notifications.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => notifier.getUserNotifications());
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
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final state = ref.watch(notificationProvider);

    // Build the current screen.
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;

        // Always clear this flag before leaving.
        notifier.setIsRequestsOnly(false);
      },
      child: WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: 'Notifications',
        appBarTrailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: _markAllAsRead,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Mark All As Read",
                style: wayaTheme.textTheme.bodyMedium?.copyWith(
                  color: WayaColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
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
                hintText:
                    "Search ${state.requestsOnly ? 'requests' : 'notifications'}",
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
      ),
    );
  }
}
