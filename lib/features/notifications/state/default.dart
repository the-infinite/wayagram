import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/state/filter_notification.dart';


class NotificationState {
  final bool isLoading;
  final bool requestsOnly;
  final String searchQuery;
  final List<NotificationModel> notifications;
  final int page;
  final int totalSize;
  final FilterNotificationState filters;

  //  Construct.
  NotificationState({
    required this.requestsOnly,
    required this.isLoading,
    required this.searchQuery,
    required this.notifications,
    required this.page,
    required this.totalSize,
    required this.filters,
  });

  static final initial = NotificationState(
    page: 1,
    totalSize: 24,
    requestsOnly: false,
    isLoading: false,
    searchQuery: "",
    filters: FilterNotificationState.initial,
    notifications: [],
  );

  // Copy with.
  NotificationState copyWith({
    bool? isLoading,
    bool? requestsOnly,
    String? searchQuery,
    List<NotificationModel>? notifications,
    int? page,
    int? totalSize,
    FilterNotificationState? filters,
  }) {
    return NotificationState(
      requestsOnly: requestsOnly ?? this.requestsOnly,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      totalSize: totalSize ?? this.totalSize,
      filters: filters ?? this.filters,
    );
  }

  /// Controller utility used to retrieve the currently browsed list of all
  /// notifications after considering the
  List<NotificationModel> get currentNotifications {
    //? The first pass is filtering by notification type.
    var aggregate = requestsOnly
        ? notifications.where(
            (notif) => [
              NotificationMessageType.groupInvite,
              NotificationMessageType.followRequest,
            ].contains(notif.messageType),
          )
        : notifications;
    
    //? If we are filtering by notification search query, do the needful.
    if(searchQuery.trim().isNotEmpty) {
        aggregate = aggregate.where((notif) => notif.message.body.toLowerCase().contains(searchQuery) || notif.message.subject.toLowerCase().contains(searchQuery));
    }

    //? The second pass is to take away wallet notifications.
    if (filters.isApplied && !filters.showDonationNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.donation);
    }

    //? Third, filter out event notifications.
    if (filters.isApplied && !filters.showEventsNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.event);
    }

    //? Fourth, filter out marketplace notifications.
    if (filters.isApplied && !filters.showMarketplaceNotifications) {
      aggregate = aggregate.where((notif) => [NotificationMessageType.creditAlert, NotificationMessageType.debitAlert].contains(notif.messageType));
    }

    //? Fifth, filter out polling notifications.
    if (filters.isApplied && !filters.showPollingAndVotingNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.poll);
    }

    //? Sixth, filter out event notifications.
    if (filters.isApplied && !filters.showQuotationNotifications) {
      aggregate = aggregate.where((notif) => [NotificationMessageType.creditAlert, NotificationMessageType.debitAlert].contains(notif.messageType));
    }

    //? Seventh, filter out University Got Talent notifications.
    if (filters.isApplied && !filters.showUgtNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.event);
    }

    //? Eighth, filter out wallet notifications.
    if (filters.isApplied && !filters.showWalletNotifications) {
      aggregate = aggregate.where((notif) => [NotificationMessageType.creditAlert, NotificationMessageType.debitAlert].contains(notif.messageType));
    }

    // This is fine.
    return aggregate.toList();
  }
}
