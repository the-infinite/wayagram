enum NotificationType {
  chat._("chats"),
  calls._("call"),
  followRequest._("follow_request"),
  likes._("likes"),
  comments._("comments"),
  shares._("shares"),
  views._("views"),
  events._("events"),
  livestream._("livestream"),
  debitAlert._("debit_alert"),
  creditAlert._("credit_alert");

  final String value;
  const NotificationType._(this.value);

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw Exception("Invalid notification type: $value"),
    );
  }
}

class NotificationSetting {
  final String category;
  final NotificationType notificationType;
  final bool enabled;

  // Constructor.
  NotificationSetting({
    required this.category,
    required this.notificationType,
    required this.enabled,
  });

  factory NotificationSetting.fromJson(Map<String, dynamic> json) {
    return NotificationSetting(
      category: json["category"],
      notificationType: NotificationType.fromString(json["notificationType"]),
      enabled: json["enabled"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "notificationType": notificationType.value,
      "enabled": enabled,
    };
  }

  NotificationSetting copyWith({
    String? category,
    NotificationType? notificationType,
    bool? enabled,
  }) {
    return NotificationSetting(
      category: category ?? this.category,
      notificationType: notificationType ?? this.notificationType,
      enabled: enabled ?? this.enabled,
    );
  }
}
