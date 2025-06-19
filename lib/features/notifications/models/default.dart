import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/message.dart';

part 'default.g.dart';

enum NotificationPriority {
  none,
  low,
  normal,
  high,
}

enum NotificationStatus {
  pending,
  processing,
  delivered,
  failed,
}

enum NotificationChannel {
  email,
  push,
  sms,
  webhook,
}

enum NotificationMessageType {
  @JsonValue('chats')
  chat,

  @JsonValue('call')
  calls,

  @JsonValue('follow_request')
  followRequest,

  @JsonValue('likes')
  like,

  @JsonValue('comments')
  comment,

  @JsonValue('shares')
  share,

  @JsonValue('views')
  view,

  @JsonValue('donations')
  donation,

  @JsonValue('groups')
  groups,

  @JsonValue('pages')
  pages,

  @JsonValue('events')
  event,

  @JsonValue('polls')
  poll,

  @JsonValue('livestream')
  liveStream,

  @JsonValue('group_invite')
  groupInvite,

  @JsonValue('credit_alert')
  creditAlert,

  @JsonValue('debit_alert')
  debitAlert,

  @JsonValue('quotation')
  getQuotation,

  @JsonValue('others')
  uncategorized,

  // The ones for support.
  @JsonValue('support')
  supportNotification,

  @JsonValue('dispute')
  disputeNotification,
}

@JsonSerializable()
class NotificationTarget {
  final String? email;
  final String? token;
  final String? topic;

  // This is fine.
  NotificationTarget({
    this.email,
    this.token,
    this.topic,
  });

  factory NotificationTarget.fromJson(Map<String, dynamic> data) => _$NotificationTargetFromJson(data);

  Map<String, dynamic> toJson() => _$NotificationTargetToJson(this);
}

@JsonSerializable()
class NotificationMessage {
  final String subject;
  final String body;
  final List<dynamic>? attachments;
  final Map<String, dynamic>? data;

  // This is fine.
  NotificationMessage({
    required this.subject,
    required this.body,
    required this.attachments,
    required this.data,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> data) => _$NotificationMessageFromJson(data);

  Map<String, dynamic> toJson() => _$NotificationMessageToJson(this);

  // The section for data getters.
  String? get groupId => data?['groupId'];
  String? get pageId => data?['pageId'];
  String? get chatId => data?['chatId'];
  String? get followerId => data?['followerId'];
  String? get followingId => data?['followingId'];
  String? get invitationId => data?['invitationId'];
  String? get transactionId => data?['transactionId'];
  String? get requestId => data?['requestId'];
  String? get orderId => data?['orderId'];
}

@JsonSerializable()
class NotificationModel {
  final String id;
  final NotificationChannel channel;
  final NotificationStatus status;
  final NotificationPriority priority;
  final String? correlationId;
  final String? emailMessageType;
  @JsonKey(name: "nType")
  final NotificationMessageType messageType;
  final NotificationMessage message;
  @JsonKey(name: "isRead", defaultValue: false)
  final bool read;
  final DateTime createdAt;
  final DateTime updatedAt;

  // This is fine.
  NotificationModel({
    required this.id,
    required this.status,
    required this.priority,
    required this.messageType,
    required this.correlationId,
    required this.emailMessageType,
    required this.channel,
    required this.message,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> data) {
    // First, do the basic conversion.
    var json = {...data};

    //? If this has any data here....
    if (data["message"]?["data"] != null) {
      final messageData = data["message"]!["data"] as Map<String, dynamic>?;

      //? If the body is absolutely null and this is a chat...
      if (json['messageType'] == 'chats' &&
          json['message']['body'].toString() == 'null' &&
          (messageData?.isNotEmpty ?? false)) {
        final message = MessageModel.fromJson(messageData!);
        json['message']['body'] = message.contentDescription;
      }

      //? Else, retrieve each key.
      else {
        for (final key in messageData?.keys ?? []) {
          json["message"]["body"] = json["message"]["body"].toString().replaceAll("{{$key}}", messageData![key]);
        }
      }
    }

    // Next, return this as is.
    return _$NotificationModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  bool get isRequest => [
        NotificationMessageType.groupInvite,
        NotificationMessageType.getQuotation,
        NotificationMessageType.followRequest,
      ].contains(messageType);

  //? This is fine.
  String? get notificationAction => switch (messageType) {
        NotificationMessageType.chat => "Tap to open the chat and reply",
        NotificationMessageType.comment => "Tap to view comment",
        NotificationMessageType.donation => "Tap to view details",
        NotificationMessageType.event => "Tap to join event",
        NotificationMessageType.poll => "Tap to view results and insights",
        NotificationMessageType.calls => "Tap to view the call details",
        NotificationMessageType.like => "Tab to view the post",
        NotificationMessageType.share => "Tap to view what was shared",
        NotificationMessageType.view => "Tap to view the profile of your viewer",
        NotificationMessageType.liveStream => "Tap to join the livestream",
        NotificationMessageType.groups => "Tap to view group summary",
        NotificationMessageType.pages => "Tap to view page summary",
        NotificationMessageType.creditAlert ||
        NotificationMessageType.debitAlert =>
          "Tap to view transaction details in your wallet",
        NotificationMessageType.getQuotation => "Tap to view order details",

        // For requests.
        NotificationMessageType.groupInvite => "Tap to view group invitation",
        NotificationMessageType.followRequest => "Tap to view follow request",

        // For support notifications.
        NotificationMessageType.supportNotification => "Tap to view support conversation",
        NotificationMessageType.disputeNotification => "Tap to view dispute conversation",
        NotificationMessageType.uncategorized => null,
      };
}
