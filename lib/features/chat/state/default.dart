import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class ConversationState {
  static UserDetailsModel? _self;
  final bool isLoading;
  final String searchFilter;
  final List<ChatModel> conversations;
  final List<ChatModel> archived;

  //? For chats.
  final int totalCount;
  final int totalPages;
  final int limit;
  final int page;
  final bool hasNextPage;

  //? For archived chats.
  final int archivedTotalCount;
  final int archivedTotalPages;
  final int archivedPage;
  final bool archivedHasNextPage;

  // This is fine.
  const ConversationState({
    required this.isLoading,
    required this.searchFilter,
    required this.conversations,
    required this.page,
    required this.archived,
    required this.totalPages,
    required this.limit,
    required this.hasNextPage,
    required this.totalCount,
    required this.archivedTotalCount,
    required this.archivedTotalPages,
    required this.archivedPage,
    required this.archivedHasNextPage,
  });

  // This is fine.
  static void setSelf(UserDetailsModel? self) {
    ConversationState._self ??= self;
  }

  // This is a getter.
  static UserDetailsModel get self => _self!;

  /// When this was done.
  static final initial = ConversationState(
    isLoading: false,
    searchFilter: "",
    conversations: [],
    archived: [],
    page: 1,
    totalPages: 0,
    limit: 150,
    totalCount: 0,
    hasNextPage: true,
    archivedTotalCount: 0,
    archivedTotalPages: 0,
    archivedPage: 1,
    archivedHasNextPage: true,
  );

  /// Utility used to retrieve the list of pinned chats from this one.
  List<ChatModel> get pinned => conversations.where((chat) => chat.self.isPined).toList();

  /// Utility used to retrieve the list of chats that are not pinned.
  List<ChatModel> get unpinned => conversations.where((chat) => !chat.self.isPined).toList();

  /// Clone this conversation but change a little bit of details about it.
  ConversationState copyWith({
    bool? isLoading,
    String? searchFilter,
    List<ChatModel>? conversations,
    List<ChatModel>? archived,
    int? page,
    int? totalPages,
    int? limit,
    bool? hasNextPage,
    int? totalCount,
    int? archivedTotalCount,
    int? archivedTotalPages,
    int? archivedPage,
    bool? archivedHasNextPage,
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      searchFilter: searchFilter ?? this.searchFilter,
      archived: archived ?? this.archived,
      conversations: conversations ?? this.conversations,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      totalCount: totalCount ?? this.totalCount,
      archivedTotalCount: archivedTotalCount ?? this.archivedTotalCount,
      archivedTotalPages: archivedTotalPages ?? this.archivedTotalPages,
      archivedPage: archivedPage ?? this.archivedPage,
      archivedHasNextPage: archivedHasNextPage ?? this.archivedHasNextPage,
    );
  }
}
