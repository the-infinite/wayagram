import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'default.g.dart';

// Chat type enum
enum ChatType {
  personal("personal"),
  group("group"),
  dispute("dispute");

  const ChatType(this.value);
  final String value;
}

@JsonSerializable()
class ChatModel {
  final String id;
  final String? name;
  final String createdBy;
  final String? latestMessageId;
  final MessageModel? lastMessage;
  final int unreadCount;
  final String chatType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMember> chatMembers;

  ChatModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.latestMessageId,
    required this.chatType,
    required this.createdAt,
    required this.updatedAt,
    required this.chatMembers,
    required this.lastMessage,
    required this.unreadCount,
  });

  // This is fine.
  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

  // This is fine.
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  /// Helper function used to get the other person in this conversation that is
  /// not the currently logged in user.
  ChatMember get other {
    return allOthers.first;
  }

  /// Helper function  used to return the user that is currently using the app.
  ChatMember get self {
    return chatMembers.where((user) => user.userId == ConversationState.self.id).first;
  }

  /// Helper function used to get the other people in the chat.
  Iterable<ChatMember> get allOthers {
    return chatMembers.where((user) => user.userId != ConversationState.self.id);
  }

  /// Helper function used to get the text to show for the unread messages count.
  String get unreadText {
    if (unreadCount > 99) return "99+";

    // This is fine.
    return unreadCount.toString();
  }

  /// Helper function used to copy data from one instance of this class to another.
  ChatModel copyWith({
    String? id,
    String? name,
    String? createdBy,
    String? latestMessageId,
    MessageModel? lastMessage,
    int? unreadCount,
    String? chatType,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatMember>? chatMembers,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      latestMessageId: latestMessageId ?? this.latestMessageId,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      chatType: chatType ?? this.chatType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chatMembers: chatMembers ?? this.chatMembers,
    );
  }
}
