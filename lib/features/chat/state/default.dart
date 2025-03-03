import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class ConversationState {
  static UserDetailsModel? _self;
  static SocialProfileModel? _profile;
  final bool isLoading;
  final String searchFilter;
  final List<ChatModel> conversations;
  final List<ChatModel> archived;
  final bool inArchived;

  //? For chats.
  final bool hasLoaded;
  final int totalCount;
  final int totalPages;
  final int limit;
  final int page;
  final bool hasNextPage;

  //? For archived chats.
  final bool hasLoadedArchived;
  final int archivedTotalCount;
  final int archivedTotalPages;
  final int archivedPage;
  final bool archivedHasNextPage;

  // This is fine.
  const ConversationState({
    required this.hasLoaded,
    required this.hasLoadedArchived,
    required this.isLoading,
    required this.searchFilter,
    required this.conversations,
    required this.page,
    required this.archived,
    required this.totalPages,
    required this.limit,
    required this.hasNextPage,
    required this.inArchived,
    required this.totalCount,
    required this.archivedTotalCount,
    required this.archivedTotalPages,
    required this.archivedPage,
    required this.archivedHasNextPage,
  });

  // This is fine.
  static void setSelf(UserDetailsModel? self, SocialProfileModel? profile) async {
    ConversationState._self ??= self;
    ConversationState._profile ??= profile;

    //? If this is not undefined.
    if (self != null) {
      //? First for crashlytics.
      await FirebaseCrashlytics.instance.setUserIdentifier(self.id);
      await FirebaseCrashlytics.instance.setCustomKey("fullname", self.fullname);
      await FirebaseCrashlytics.instance.setCustomKey("environment", WayaConstants.isProduction ? 'live' : 'test');

      //? Next for analytics.
      await FirebaseAnalytics.instance.setUserId(id: self.id);
      await FirebaseAnalytics.instance.setUserProperty(name: "fullname", value: self.fullname);
      await FirebaseAnalytics.instance.setUserProperty(name: "environment", value: WayaConstants.isProduction ? 'live' : 'test');
    }
  }

  /// The currently logged in user's account details.
  static UserDetailsModel get self => _self!;

  /// The social media profile of the currently logged in user.
  static SocialProfileModel get profile => _profile!;

  /// When this was done.
  static final initial = ConversationState(
    isLoading: false,
    searchFilter: "",
    conversations: [],
    archived: [],
    page: 1,
    totalPages: 0,
    limit: 100,
    totalCount: 0,
    hasLoaded: false,
    hasLoadedArchived: false,
    inArchived: false,
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

  /// The results displayed whenever you are looking at a list of conversations
  /// arranged in no particular order.
  List<ChatModel> get results {
    // The filter.
    final filter = searchFilter.toLowerCase();

    // Then return this.
    if (searchFilter.isEmpty) {
      return conversations;
    }

    //? This is fine.
    return conversations
        .where((chat) =>
            (chat.chatType == 'group' && (chat.name ?? '').toLowerCase().contains(filter)) ||
            (chat.other.userData?.fullname.toLowerCase().contains(filter) ?? false) ||
            (chat.other.profileData?.username?.toLowerCase().contains(filter) ?? false) ||
            (chat.other.chatUser?.displayName.toLowerCase().contains(filter) ?? false))
        .toList();
  }

  /// The results displayed whenever you are looking at a list of conversations
  /// arranged in no particular order.
  List<ChatModel> get archivedResults {
    // The filter.
    final filter = searchFilter.toLowerCase();

    // Then return this.
    if (searchFilter.isEmpty) {
      return archived;
    }

    //? This is fine.
    return archived
        .where((chat) =>
            (chat.chatType == 'group' && (chat.name ?? '').toLowerCase().contains(filter)) ||
            (chat.other.userData?.fullname.toLowerCase().contains(filter) ?? false) ||
            (chat.other.profileData?.username?.toLowerCase().contains(filter) ?? false) ||
            (chat.other.chatUser?.displayName.toLowerCase().contains(filter) ?? false))
        .toList();
  }

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
    bool? inArchived,
    bool? hasLoaded,
    bool? hasLoadedArchived,
  }) {
    return ConversationState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      hasLoadedArchived: hasLoadedArchived ?? this.hasLoadedArchived,
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
      inArchived: inArchived ?? this.inArchived,
    );
  }
}
