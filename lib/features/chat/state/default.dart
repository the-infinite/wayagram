import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

class ConversationState {
  static User? _self;
  final bool isLoading;
  final String searchFilter;
  final List<ChatModel> conversations;
  final int page;
  final int totalPages;
  final int limit;

  // This is fine.
  const ConversationState({
    required this.isLoading,
    required this.searchFilter,
    required this.conversations,
    required this.page,
    required this.totalPages,
    required this.limit,
  });

  // Our recipient users for mock data.
  static final _user = User(
    id: "user_1",
    role: null,
    phoneNumber: "+234801234567",
    email: "fasas@waya.test",
    passwordHash: "",
    firstName: "Fasas",
    lastName: "Oyewunmi",
    gender: "Male",
    address: "11 JQT MXV",
    city: "Ikorodu",
    state: "Lagos",
    country: "Nigeria",
    countryCode: "NG",
    middleName: null,
    dateOfBirth: DateTime(2002, 09, 13),
    twoFactorEnabled: false,
    profilePicture: "https://res.cloudinary.com/dr99moeep/image/upload/v1737303486/uploads/skp9khjszrmt1gzy4ufa.jpg",
    fcmToken: "?",
    emailVerified: true,
    phoneVerified: true,
    accountStatus: "active",
    tcAgreement: true,
    policyAgreement: true,
    emailVerifiedDate: DateTime.now(),
    deletedAt: null,
    roleId: "user",
    accountTypeId: "user",
    v: "1",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    lga: "Ikorodu",
  );
  static final _user2 = User(
    id: "user_2",
    role: null,
    phoneNumber: "+234801234568",
    email: "fasas@waya.test",
    passwordHash: "",
    firstName: "Hosannah",
    lastName: "Ugwu",
    gender: "Male",
    address: "11 JQT MXV",
    city: "Ikorodu",
    state: "Lagos",
    country: "Nigeria",
    countryCode: "NG",
    middleName: null,
    dateOfBirth: DateTime(2002, 09, 13),
    twoFactorEnabled: false,
    profilePicture: "https://res.cloudinary.com/dr99moeep/image/upload/v1737303486/uploads/skp9khjszrmt1gzy4ufa.jpg",
    fcmToken: "?",
    emailVerified: true,
    phoneVerified: true,
    accountStatus: "active",
    tcAgreement: true,
    policyAgreement: true,
    emailVerifiedDate: DateTime.now(),
    deletedAt: null,
    roleId: "user",
    accountTypeId: "user",
    v: "1",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    lga: "Ikorodu",
  );

  // This is fine.
  static void setSelf(User? self) {
    ConversationState._self ??= self;
  }

  // This is a getter.
  static User get self => _self!;

  /// When this was done.
  static final initial = ConversationState(
    isLoading: false,
    searchFilter: "",
    conversations: [
      //? First conversation
      ChatModel(
        id: "chat_1",
        pinned: false,
        sender: _self,
        senderId: _self?.id ?? "db27088e-7d6a-42a3-86c2-831fd603c233",
        recipient: _user,
        recipientId: _user.id!,
        lastMessage: MessageModel(
          id: "msg_1",
          chatId: "chat_1",
          senderId: _self?.id ?? "db27088e-7d6a-42a3-86c2-831fd603c233",
          content: "I'll definitely shoot my shot at any opportunities I might find though.",
          media: null,
          contacts: null,
          messageType: MessageType.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          mediaUrl: null,
          edited: false,
          originalMessageId: null,
          originalMessage: null,
          forwardedFrom: null,
          isReply: false,
          status: [],
          messageReaction: [],
        ),
        unread: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      //? Second conversation.
      ChatModel(
        id: "chat_2",
        pinned: true,
        sender: _user2,
        senderId: _user2.id!,
        recipient: _self,
        recipientId: _self?.id ?? "db27088e-7d6a-42a3-86c2-831fd603c233",
        lastMessage: MessageModel(
          id: "msg_1",
          chatId: "chat_1",
          senderId: _self?.id ?? "db27088e-7d6a-42a3-86c2-831fd603c233",
          content: "I strongly dislike your views and life values there.",
          media: null,
          contacts: null,
          messageType: MessageType.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          mediaUrl: null,
          edited: false,
          originalMessageId: null,
          originalMessage: null,
          forwardedFrom: null,
          isReply: false,
          status: [],
          messageReaction: [],
        ),
        unread: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
    page: 0,
    totalPages: 0,
    limit: 20,
  );

  /// Utility used to retrieve the list of pinned chats from this one.
  List<ChatModel> get pinned => conversations.where((chat) => chat.pinned).toList();

  /// Utility used to retrieve the list of chats that are not pinned.
  List<ChatModel> get unpinned => conversations.where((chat) => !chat.pinned).toList();

  /// Clone this conversation but change a little bit of details about it.
  ConversationState copyWith({
    bool? isLoading,
    String? searchFilter,
    List<ChatModel>? conversations,
    int? page,
    int? totalPages,
    int? limit,
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      searchFilter: searchFilter ?? this.searchFilter,
      conversations: conversations ?? this.conversations,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
    );
  }
}
