import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

part 'default.g.dart';

@JsonSerializable()
class ChatModel {
  final String id;
  final bool pinned;
  final String senderId;
  final String recipientId;
  final User? sender;
  final User? recipient;
  final MessageModel lastMessage;
  final List<MessageModel> unread;
  final DateTime createdAt;
  final DateTime updatedAt;

  // This is fine.
  const ChatModel({
    required this.id,
    required this.pinned,
    required this.sender,
    required this.recipient,
    required this.lastMessage,
    required this.unread,
    required this.senderId,
    required this.recipientId,
    required this.createdAt,
    required this.updatedAt,
  });

  // This is fine.
  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

  // This is fine.
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  /// Helper function used to get the other person in this conversation that is
  /// not the currently logged in user.
  User get other {
    //? If the author of this conversation is the current user, send the recipient.
    if (senderId == ConversationState.self.id) return recipient!;

    //? Send the sender.
    return sender!;
  }

  /// Helper function used to get the text to show for the unread messages count.
  String get unreadText {
    if (unread.length > 99) return "99+";

    // This is fine.
    return unread.length.toString();
  }
}
