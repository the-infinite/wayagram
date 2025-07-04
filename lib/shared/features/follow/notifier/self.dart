import 'package:flutter/material.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/model/suggestion.dart';
import 'package:wayagram/shared/features/follow/repo/default.dart';
import 'package:wayagram/shared/features/follow/state/default.dart';
import 'package:wayagram/shared/features/moments/notifier/default.dart';

class UserFollowerNotifier extends ValueNotifier<FollowState> {
  final repo = FollowRepository.instance;

  /// Our singleton instance.
  static final instance = UserFollowerNotifier._();

  UserFollowerNotifier._() : super(FollowState.initial.copyWith(userId: ConversationState.self.id));

  /// Utility to make it such that I do not have to rewrite the code I already
  /// have tested on which comes with Riverpod.
  FollowState get state => value;

  /// Utility to make it such that I do not have to rewrite the code I already
  /// have tested on which comes with Riverpod.
  set state(FollowState value) {
    this.value = value;
  }

  Future<List<FollowModel>> getFollowersOf() async {
    final result = <FollowModel>[];

    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.getFollowers(
          ConversationState.self.id, state.followersNextPage ?? state.followersPage, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => FollowModel.fromJson(doc));

        //? If the previous page had a next page, offload them onto this place.
        if (state.followersHasNextPage) {
          result.addAll(state.followers);
        }

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? This is fine.
        state = state.copyWith(
          followers: result,
          followersTotalSize: data['totalDocs'],
          followersTotalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          followersHasNextPage: data['hasNextPage'],
          followersPage: int.tryParse(data['page'].toString()) ?? 1,
          followersNextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoadedFollowers: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.relationships,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return result;
  }

  Future<List<FollowModel>> getUsersFollowing() async {
    final result = <FollowModel>[];

    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.getFollowing(
        ConversationState.self.id,
        state.followingNextPage ?? state.followingPage,
        state.limit,
      );

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => FollowModel.fromJson(doc));

        //? If the previous page had a next page, offload them onto this place.
        if (state.followingHasNextPage) {
          result.addAll(state.following);
        }

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? This is fine.
        state = state.copyWith(
          following: result,
          followingTotalSize: data['totalDocs'],
          followingTotalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          followingHasNextPage: data['hasNextPage'],
          followingPage: int.tryParse(data['page'].toString()) ?? 1,
          followingNextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoadedFollowing: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.relationships,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return result;
  }

  Future<List<SuggestionModel>> getFollowSuggestions([bool reset = false]) async {
    final result = <SuggestionModel>[];

    //? If this is a request that resets everything.
    if (reset) {
      state = state.copyWith(
        suggestionsNextPage: 0,
        suggestionsPage: 0,
        suggestionsHasNextPage: true,
        suggestionsTotalPages: null,
        suggestionsTotalSize: null,
        isLoadingSuggestions: false,
      );
    }

    //? This is wonderful.
    try {
      // This is fine too.
      final page = state.suggestionsNextPage ?? state.suggestionsPage;
      final response = await repo.getSuggestedFriends(page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => SuggestionModel.fromJson(doc));

        //? If the previous page had a next page, offload them onto this place.
        if (state.suggestionsHasNextPage) {
          result.addAll(state.suggestions);
        }

        //? Now, add these to what we have here.
        result.addAll(docs.where((suggestion) => !result.any((match) => match.id == suggestion.id)));

        //? This is fine.
        state = state.copyWith(
          suggestions: result,
          suggestionsTotalSize: data['total'],
          suggestionsTotalPages: ((data['total'] / data['limit']) as double).ceil(),
          suggestionsHasNextPage: data['hasNextPage'],
          suggestionsPage: page,
          suggestionsNextPage: page + 1,
          hasLoadedSuggestions: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.relationships,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    return result;
  }

  Future<FollowStatusModel?> getFollowStatus(String id) async {
    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.getFollowStatus(id);

      // If this was fine...
      if (response.success) {
        return FollowStatusModel.fromJson(response.data["data"]);
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.relationships,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This is fine.
    return null;
  }

  Future<FollowStatusModel?> handleFollowRequest(String followerId, String followingId, FollowAction action) async {
    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.handleFollowRequest(followerId, followingId, action);

      // If this was fine...
      if (response.success) {
        return FollowStatusModel.fromJson(response.data["data"]);
      }

      //? After getting these posts...
    } catch (e) {
      debugPrint("Error: $e");
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.relationships,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This is fine.
    return null;
  }

  Future<bool> followUser(String id) async {
    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.followUser(id);

      // If this was fine...
      if (response.success) {
        getUsersFollowing();
        getFollowSuggestions(true);
        otherUserMoments.getAllMoments();
        return true;
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.relationships,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This is fine.
    return false;
  }

  Future<bool> unfollowUser(String id) async {
    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.unFollowUser(id);

      // If this was fine...
      if (response.success) {
        final index = state.following.indexWhere((user) => user.otherUserId == id);
        final list = state.following;

        //? This is fine.
        if (index != -1) {
          list.removeAt(index);
          state = state.copyWith(following: [...list]);
        }

        //? This is fine.
        otherUserMoments.getAllMoments();
        getFollowSuggestions(true);

        //? Return here.
        return true;
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.relationships,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This is fine.
    return false;
  }

  /// Helper function used to update user chat settings
  Future<bool> updateUserSettings(UserSettingsDto dto) async {
    final response = await repo.updateUserSettings(dto);

    //? Return whether or not this is true.
    return response.success;
  }

  /// Helper function used to retrieve all of the details of just one conversation.
  Future<UserSettingsDto?> getUserSettings() async {
    //? This is fine.- getting from server with userId
    final response = await repo.getUserSettings();

    //? This is fine.
    if (response.success) {
      return UserSettingsDto.fromJson(response.data['data']);
    }

    //? Return null if empty
    return null;
  }

  Future<void> getIfEmpty() async {
    //? If this has no suggested friends yet.
    if (state.suggestions.isEmpty) await getFollowSuggestions();

    //? If this user has not loaded followers yet.
    if (state.followers.isEmpty) await getFollowersOf();

    //? If this user has not loaded following yet.
    if (state.following.isEmpty) await getUsersFollowing();
  }

  void reset() async {
    state = FollowState.initial;
  }

  bool isUserFollowing(String id) {
    return state.followers.any((relation) => relation.isUserFollowing && relation.otherUserId == id) ||
        state.following.any((relation) => relation.isUserFollowing && relation.otherUserId == id);
  }
}

final myFollowProvider = UserFollowerNotifier.instance;
