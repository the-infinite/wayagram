class NotificationSettings {
  // General maintenance.
  final bool isLoading;

  // Activity alerts.
  final bool showChat;
  final bool showCall;
  final bool showFollowRequest;
  final bool showLikes;
  final bool showComments;
  final bool showShares;
  final bool showViews;

  // Events and live streams
  final bool showEvents;
  final bool showLivestream;

  // Transaction notifications.
  final bool showDebit;
  final bool showCredit;

  // This is fine.
  static const initial = NotificationSettings(
    isLoading: false,
    showChat: true,
    showCall: true,
    showFollowRequest: true,
    showLikes: true,
    showComments: true,
    showShares: false,
    showViews: false,
    showEvents: true,
    showLivestream: false,
    showDebit: false,
    showCredit: true,
  );

  // Construct.
  const NotificationSettings({
    required this.isLoading,
    required this.showChat,
    required this.showCall,
    required this.showFollowRequest,
    required this.showLikes,
    required this.showComments,
    required this.showShares,
    required this.showViews,
    required this.showEvents,
    required this.showLivestream,
    required this.showDebit,
    required this.showCredit,
  });
}
