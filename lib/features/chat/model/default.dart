import 'package:json_annotation/json_annotation.dart';
import 'package:wayagram/features/chat/model/member.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'default.g.dart';

// Chat type enum
enum ChatType {
  personal,
  group,
  dispute,
}

@JsonSerializable()
class ChatModel {
  final String id;
  final String? name;
  final String? description;
  final String? groupImage;
  final String createdBy;
  final String? latestMessageId;
  final MessageModel? lastMessage;
  final int unreadCount;
  final ChatType chatType;
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
    required this.description,
    required this.groupImage,
  });

  String get initials {
    if (chatType == ChatType.group) {
      return (name?.split(" ") ?? ["Group", "Chat"]).take(2).map((word) => word[0].toUpperCase()).join();
    }

    //? This is our alternative
    return other.userData?.initials ??
        (other.chatUser?.displayName.split(" ") ?? ["WayaGram", "User"])
            .take(2)
            .map((word) => word[0].toUpperCase())
            .join();
  }

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
    ChatType? chatType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    String? groupImage,
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
      description: description ?? this.description,
      groupImage: groupImage ?? this.groupImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chatMembers: chatMembers ?? this.chatMembers,
    );
  }
}
