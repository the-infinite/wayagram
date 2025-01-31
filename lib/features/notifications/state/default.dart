import 'package:wayagram/features/notifications/models/default.dart';
import 'package:wayagram/features/notifications/state/filter_notification.dart';

/*

'chats',
            'call',
            'follow_request',
            'likes',
            'comments',
            'shares',
            'views',
            'events',
            'livestream',
            'debit_alert',
            'credit_alert'
*/
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
    notifications: [
      //? Dummy notifications.
      NotificationModel(
        id: "notif-1",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.transaction,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "Payment Received",
          body: "You have received ₦5,000 from XYZ Ltd.",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: false,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-2",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.follower,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Follower Alert",
          body: "John Doe started following you.",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: false,
      ),

      // This is fine too.
      NotificationModel(
        id: "notif-3",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.event,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "Upcoming Event: Webinar on UX Design",
          body: "Starts in 30 minutes",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-4",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.poll,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "The Results Are In!",
          body: "Your poll 'Favourite Design' has ended",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: false,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-5",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.chat,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Message from Jane",
          body: '"Hey are you available for a call?"',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-5",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.chat,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Message from Jane",
          body: '"Hey are you available for a call?"',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-6",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.comment,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Comment",
          body: 'Fasas Commented "Hey, are you available for a call?"',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-7",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.donation,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Donation Received",
          body: 'You just received a new donation on "Help Sanni Walk Again"',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-8",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.transaction,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "Debit Transaction",
          body: 'You spent ₦480 voting in a poll',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine
      NotificationModel(
        id: "notif-9",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.transaction,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "Payment Received",
          body: "You have received ₦50,000 from Trevor Baker",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-10",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.follower,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Follower Alert",
          body: "Jane Fischer started following you.",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine too.
      NotificationModel(
        id: "notif-11",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.event,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "Upcoming Event: Waya Bank Launch",
          body: "Coming up in 11 days, be there!",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-12",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.poll,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "The Results Are In!",
          body: "Not bad. Your vote was the second most popular one in the poll.",
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-13",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.chat,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Message from Jacob",
          body: '"Pick a time and place."',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-14",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.chat,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Message from Jane",
          body: '"What\'s your take?"',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-15",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.comment,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Comment",
          body: 'Archie commented "Nice shoes. Where did you get them?"',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-16",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.transaction,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "Debit Transaction",
          body: 'You withdrew ₦8,000 from the bank',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-17",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.donation,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Donation Received",
          body: 'You just received a new donation on "Help Sanni Walk Again"',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-18",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.groupInvite,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "Group Team Invite",
          body: 'Collaborate as a team member on the "Empire Music" group',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-19",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.friendRequest,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Friend Request",
          body: 'John Doe is asking to be your friend',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),

      // This is fine.
      NotificationModel(
        id: "notif-20",
        status: NotificationStatus.delivered,
        messageType: NotificationMessageType.followRequest,
        channel: NotificationChannel.push,
        priority: NotificationPriority.normal,
        correlationId: "corr-12345",
        message: NotificationMessage(
          subject: "New Follow Request",
          body: 'Samantha Higgins wants to follow you',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        read: true,
      ),
    ],
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
              NotificationMessageType.friendRequest,
              NotificationMessageType.followRequest,
            ].contains(notif.messageType),
          )
        : notifications;

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
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.transaction);
    }

    //? Fifth, filter out polling notifications.
    if (filters.isApplied && !filters.showPollingAndVotingNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.poll);
    }

    //? Sixth, filter out event notifications.
    if (filters.isApplied && !filters.showQuotationNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.transaction);
    }

    //? Seventh, filter out University Got Talent notifications.
    if (filters.isApplied && !filters.showUgtNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.event);
    }

    //? Eighth, filter out wallet notifications.
    if (filters.isApplied && !filters.showWalletNotifications) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.transaction);
    }

    // This is fine.
    return aggregate.toList();
  }
}
