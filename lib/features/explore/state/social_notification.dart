import 'package:flutter/material.dart';
import 'package:wayagram/features/notifications/models/default.dart';

class SocialNotificationFilters {
  final bool showLikes;
  final bool showComments;
  final bool showFollowRequests;
  final bool showLivestream;
  final bool showGroupInvite;
  final bool showCalls;
  final bool showPolls;
  final bool showEvents;
  final bool showShares;
  final bool showView;
  final bool isApplied;
  final TextEditingController searchController;

  const SocialNotificationFilters({
    required this.showLikes,
    required this.showComments,
    required this.showFollowRequests,
    required this.showLivestream,
    required this.showGroupInvite,
    required this.showCalls,
    required this.showPolls,
    required this.showEvents,
    required this.showShares,
    required this.showView,
    required this.isApplied,
    required this.searchController,
  });

  static final initial = SocialNotificationFilters(
    showLikes: true,
    showComments: true,
    showFollowRequests: true,
    showLivestream: true,
    showEvents: true,
    showPolls: true,
    showGroupInvite: true,
    showCalls: true,
    showShares: true,
    showView: true,
    isApplied: true,
    searchController: TextEditingController(),
  );

  SocialNotificationFilters copyWith({
    bool? showLikes,
    bool? showComments,
    bool? showFollowRequests,
    bool? showLivestream,
    bool? showGroupInvite,
    bool? showCalls,
    bool? showShares,
    bool? showView,
    bool? isApplied,
    bool? showEvents,
    bool? showPolls,
  }) {
    return SocialNotificationFilters(
      showLikes: showLikes ?? this.showLikes,
      showComments: showComments ?? this.showComments,
      showFollowRequests: showFollowRequests ?? this.showFollowRequests,
      showLivestream: showLivestream ?? this.showLivestream,
      showGroupInvite: showGroupInvite ?? this.showGroupInvite,
      showCalls: showCalls ?? this.showCalls,
      showShares: showShares ?? this.showShares,
      showView: showView ?? this.showView,
      isApplied: isApplied ?? this.isApplied,
      showEvents: showEvents ?? this.showEvents,
      showPolls: showPolls ?? this.showPolls,
      searchController: searchController,
    );
  }
}

class SocialNotificationState {
  final bool isLoading;
  final bool requestsOnly;
  final String searchQuery;
  final List<NotificationModel> notifications;
  final int page;
  final int totalSize;
  final SocialNotificationFilters filters;

  //  Construct.
  SocialNotificationState({
    required this.requestsOnly,
    required this.isLoading,
    required this.searchQuery,
    required this.notifications,
    required this.page,
    required this.totalSize,
    required this.filters,
  });

  static final initial = SocialNotificationState(
    page: 1,
    totalSize: 24,
    requestsOnly: false,
    isLoading: false,
    searchQuery: "",
    filters: SocialNotificationFilters.initial,
    notifications: [],
  );

  // Copy with.
  SocialNotificationState copyWith({
    bool? isLoading,
    bool? requestsOnly,
    String? searchQuery,
    List<NotificationModel>? notifications,
    int? page,
    int? totalSize,
    SocialNotificationFilters? filters,
  }) {
    return SocialNotificationState(
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
    if (searchQuery.trim().isNotEmpty) {
      aggregate = aggregate.where((notif) =>
          notif.message.body.toLowerCase().contains(searchQuery) ||
          notif.message.subject.toLowerCase().contains(searchQuery));
    }

    //? First, if the filter is applied and we are filtering out likes.
    if (filters.isApplied && !filters.showLikes) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.like);
    }

    //? Second, filter out comment notifications.
    if (filters.isApplied && !filters.showComments) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.comment);
    }

    //? Third, filter out follow request notifications.
    if (filters.isApplied && !filters.showFollowRequests) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.followRequest);
    }

    //? Fourth, filter out livestream notifications.
    if (filters.isApplied && !filters.showLivestream) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.liveStream);
    }

    //? Fifth, filter out group invite notifications.
    if (filters.isApplied && !filters.showGroupInvite) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.groupInvite);
    }

    //? Sixth, filter out call notifications.
    if (filters.isApplied && !filters.showCalls) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.calls);
    }

    //? Seventh, filter out follow request notifications.
    if (filters.isApplied && !filters.showPolls) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.poll);
    }

    //? Eighth, filter out follow event notifications.
    if (filters.isApplied && !filters.showEvents) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.event);
    }

    //? Ninth, filter out shares notifications.
    if (filters.isApplied && !filters.showShares) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.share);
    }

    //? Finally, filter out follow view notifications.
    if (filters.isApplied && !filters.showView) {
      aggregate = aggregate.where((notif) => notif.messageType != NotificationMessageType.view);
    }

    // This is fine.
    return aggregate.toList();
  }
}
