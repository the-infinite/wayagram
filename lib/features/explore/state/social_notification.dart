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

  @override
  String toString() {
    return 'SocialNotificationFilters('
        'showLikes: $showLikes, '
        'showComments: $showComments, '
        'showFollowRequests: $showFollowRequests, '
        'showLivestream: $showLivestream, '
        'showGroupInvite: $showGroupInvite, '
        'showCalls: $showCalls, '
        'showPolls: $showPolls, '
        'showEvents: $showEvents, '
        'showShares: $showShares, '
        'showView: $showView, '
        'isApplied: $isApplied, '
        'searchController.text: "${searchController.text}"'
        ')';
  }
}

class SocialNotificationState {
  final bool isLoading;
  final String searchQuery;
  final List<NotificationModel> notifications;
  final int page;
  final int totalSize;
  final SocialNotificationFilters filters;

  //  Construct.
  SocialNotificationState({
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
    isLoading: false,
    searchQuery: "",
    filters: SocialNotificationFilters.initial,
    notifications: [],
  );

  // Copy with.
  SocialNotificationState copyWith({
    bool? isLoading,
    String? searchQuery,
    List<NotificationModel>? notifications,
    int? page,
    int? totalSize,
    SocialNotificationFilters? filters,
  }) {
    return SocialNotificationState(
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
  List<NotificationModel> currentNotifications() {
    //? The first pass is filtering by notification type.
    Iterable<NotificationModel> aggregate = notifications;
    final shown = [...NotificationMessageType.values];

    // Remove the oddities.
    shown.remove(NotificationMessageType.donation);

    //? If we are filtering by notification search query, do the needful.
    if (searchQuery.trim().isNotEmpty) {
      aggregate = aggregate.where((notif) =>
          notif.message.body.toLowerCase().contains(searchQuery) ||
          notif.message.subject.toLowerCase().contains(searchQuery));
    }

    //? If filters are not applies...
    if (!filters.isApplied) {
      return aggregate.toList();
    }

    //? First, if the filter is applied and we are filtering out likes.
    if (!filters.showLikes) {
      shown.remove(NotificationMessageType.like);
    }

    //? Second, filter out comment notifications.
    if (!filters.showComments) {
      shown.remove(NotificationMessageType.comment);
    }

    //? Third, filter out follow request notifications.
    if (!filters.showFollowRequests) {
      shown.remove(NotificationMessageType.followRequest);
    }

    //? Fourth, filter out livestream notifications.
    if (!filters.showLivestream) {
      shown.remove(NotificationMessageType.liveStream);
    }

    //? Fifth, filter out group invite notifications.
    if (!filters.showGroupInvite) {
      shown.remove(NotificationMessageType.groupInvite);
      shown.remove(NotificationMessageType.groups);
      shown.remove(NotificationMessageType.pages);
    }

    //? Sixth, filter out call notifications.
    if (!filters.showCalls) {
      shown.remove(NotificationMessageType.calls);
      shown.remove(NotificationMessageType.chat);
    }

    //? Seventh, filter out follow request notifications.
    if (!filters.showPolls) {
      shown.remove(NotificationMessageType.poll);
    }

    //? Eighth, filter out follow event notifications.
    if (!filters.showEvents) {
      shown.remove(NotificationMessageType.event);
    }

    //? Ninth, filter out shares notifications.
    if (!filters.showShares) {
      shown.remove(NotificationMessageType.share);
    }

    //? Finally, filter out follow view notifications.
    if (!filters.showView) {
      shown.remove(NotificationMessageType.view);
    }

    //? Update the aggregate using only what is in shown.
    aggregate = aggregate.where((e) => shown.contains(e.messageType));

    // This is fine.
    return aggregate.toList();
  }
}
