import 'package:wayagram/features/notifications/models/default.dart';

class NotificationState {
  final bool isLoading;
  final bool requestsOnly;
  final String searchQuery;
  final List<NotificationModel> notifications;
  final int page;
  final int totalSize;

  //  Construct.
  NotificationState({
    required this.requestsOnly,
    required this.isLoading,
    required this.searchQuery,
    required this.notifications,
    required this.page,
    required this.totalSize,
  });

  // Copy with.
  NotificationState copyWith({
    bool? isLoading,
    bool? requestsOnly,
    String? searchQuery,
    List<NotificationModel>? notifications,
    int? page,
    int? totalSize,
  }) {
    return NotificationState(
      requestsOnly: requestsOnly ?? this.requestsOnly,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      totalSize: totalSize ?? this.totalSize,
    );
  }

  /// Controller utility used to retrieve the currently browsed list of all
  /// notifications after considering the 
  List<NotificationModel> get currentNotifications {
    return notifications;
  }
}
