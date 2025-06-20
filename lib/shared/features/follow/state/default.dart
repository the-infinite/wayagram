import 'package:wayagram/shared/features/follow/model/default.dart';

typedef SuggestionModel = FollowModel;

class FollowState {
  // Shared.
  final int limit;
  final String userId;

  // For followers
  final bool hasLoadedFollowers;
  final bool isLoadingFollowers;
  final int? followersNextPage;
  final int followersPage;
  final bool followersHasNextPage;
  final int followersTotalSize;
  final int followersTotalPages;
  final List<FollowModel> followers;

  // For following.
  final bool hasLoadedFollowing;
  final bool isLoadingFollowing;
  final int? followingNextPage;
  final int followingPage;
  final bool followingHasNextPage;
  final int followingTotalSize;
  final int followingTotalPages;
  final List<FollowModel> following;

  // For suggested friends.
  final List<SuggestionModel> suggestions;
  final bool hasLoadedSuggestions;
  final bool isLoadingSuggestions;
  final bool suggestionsHasNextPage;
  final int? suggestionsNextPage;
  final int suggestionsPage;
  final int suggestionsTotalSize;
  final int suggestionsTotalPages;

  FollowState({
    // Shared.
    required this.limit,
    required this.userId,

    // For followers.
    required this.hasLoadedFollowers,
    required this.isLoadingFollowers,
    required this.followersNextPage,
    required this.followersPage,
    required this.followersHasNextPage,
    required this.followersTotalSize,
    required this.followersTotalPages,
    required this.followers,

    // For following.
    required this.hasLoadedFollowing,
    required this.isLoadingFollowing,
    required this.followingNextPage,
    required this.followingPage,
    required this.followingHasNextPage,
    required this.followingTotalSize,
    required this.followingTotalPages,
    required this.following,

    // For suggestions.
    required this.suggestions,
    required this.hasLoadedSuggestions,
    required this.isLoadingSuggestions,
    required this.suggestionsHasNextPage,
    required this.suggestionsNextPage,
    required this.suggestionsPage,
    required this.suggestionsTotalSize,
    required this.suggestionsTotalPages,
  });

  static final initial = FollowState(
    limit: 1500,
    userId: "",
    hasLoadedFollowers: false,
    isLoadingFollowers: false,
    followersNextPage: 1,
    followersPage: 0,
    followersHasNextPage: true,
    followersTotalSize: 0,
    followersTotalPages: 0,
    followers: [],
    hasLoadedFollowing: false,
    isLoadingFollowing: false,
    followingNextPage: 1,
    followingPage: 0,
    followingHasNextPage: true,
    followingTotalSize: 0,
    followingTotalPages: 0,
    following: [],
    suggestions: [],
    hasLoadedSuggestions: false,
    isLoadingSuggestions: false,
    suggestionsHasNextPage: true,
    suggestionsNextPage: 1,
    suggestionsPage: 0,
    suggestionsTotalSize: 0,
    suggestionsTotalPages: 0,
  );

  List<String> get friends {
    final result = <String>[];
    final added = <String, bool>{};

    //? First, look into all followers...
    for (final follower in followers) {
      //? If this user has been added...
      if (added[follower.otherUserId] ?? false) {
        continue;
      }

      //? If the two users follow each other...
      if (follower.followedBack) {
        result.add(follower.otherUserId);
        added[follower.otherUserId] = true;
      }
    }

    //? Second, for all users following.
    for (final follower in following) {
      //? If this user has been added...
      if (added[follower.otherUserId] ?? false) {
        continue;
      }

      //? If the two users follow each other...
      if (follower.followedBack) {
        result.add(follower.otherUserId);
        added[follower.otherUserId] = true;
      }
    }

    //? Return the created list.
    return result;
  }

  FollowState copyWith({
    int? limit,
    String? userId,
    bool? hasLoadedFollowers,
    bool? isLoadingFollowers,
    int? followersNextPage,
    int? followersPage,
    bool? followersHasNextPage,
    int? followersTotalSize,
    int? followersTotalPages,
    List<FollowModel>? followers,
    bool? hasLoadedFollowing,
    bool? isLoadingFollowing,
    int? followingNextPage,
    int? followingPage,
    bool? followingHasNextPage,
    int? followingTotalSize,
    int? followingTotalPages,
    List<FollowModel>? following,
    List<SuggestionModel>? suggestions,
    bool? hasLoadedSuggestions,
    bool? isLoadingSuggestions,
    bool? suggestionsHasNextPage,
    int? suggestionsNextPage,
    int? suggestionsPage,
    int? suggestionsTotalSize,
    int? suggestionsTotalPages,
  }) {
    return FollowState(
      limit: limit ?? this.limit,
      userId: userId ?? this.userId,
      hasLoadedFollowers: hasLoadedFollowers ?? this.hasLoadedFollowers,
      isLoadingFollowers: isLoadingFollowers ?? this.isLoadingFollowers,
      followersNextPage: followersNextPage ?? this.followersNextPage,
      followersPage: followersPage ?? this.followersPage,
      followersHasNextPage: followersHasNextPage ?? this.followersHasNextPage,
      followersTotalSize: followersTotalSize ?? this.followersTotalSize,
      followersTotalPages: followersTotalPages ?? this.followersTotalPages,
      followers: followers ?? this.followers,
      hasLoadedFollowing: hasLoadedFollowing ?? this.hasLoadedFollowing,
      isLoadingFollowing: isLoadingFollowing ?? this.isLoadingFollowing,
      followingNextPage: followingNextPage ?? this.followingNextPage,
      followingPage: followingPage ?? this.followingPage,
      followingHasNextPage: followingHasNextPage ?? this.followingHasNextPage,
      followingTotalSize: followingTotalSize ?? this.followingTotalSize,
      followingTotalPages: followingTotalPages ?? this.followingTotalPages,
      following: following ?? this.following,
      suggestions: suggestions ?? this.suggestions,
      hasLoadedSuggestions: hasLoadedSuggestions ?? this.hasLoadedSuggestions,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      suggestionsHasNextPage: suggestionsHasNextPage ?? this.suggestionsHasNextPage,
      suggestionsNextPage: suggestionsNextPage ?? this.suggestionsNextPage,
      suggestionsPage: suggestionsPage ?? this.suggestionsPage,
      suggestionsTotalSize: suggestionsTotalSize ?? this.suggestionsTotalSize,
      suggestionsTotalPages: suggestionsTotalPages ?? this.suggestionsTotalPages,
    );
  }
}
