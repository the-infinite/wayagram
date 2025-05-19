import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/repo/default.dart';
import 'package:wayagram/shared/features/follow/state/default.dart';

class FollowNotifier extends StateNotifier<FollowState> {
  final repo = FollowRepository.instance;
  FollowNotifier(super.state);

  Future<List<FollowModel>> getFollowersOf(String id) async {
    final result = <FollowModel>[];

    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.getFollowers(id, state.followersNextPage ?? state.followersPage, state.limit);

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

  Future<List<FollowModel>> getUsersFollowing(String id) async {
    final result = <FollowModel>[];

    //? This is wonderful.
    try {
      // This is fine too.
      final response = await repo.getFollowing(id, state.followingNextPage ?? state.followingPage, state.limit);

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

  void setUserId(String id) {
    state = state.copyWith(
      userId: id,
    );
  }

  Future<void> getIfEmpty(String id) async {
    //? If this user has not loaded followers yet.
    if (state.followers.isEmpty) await getFollowersOf(id);

    //? If this user has not loaded following yet.
    if (state.following.isEmpty) await getUsersFollowing(id);
  }

  void reset() {
    state = FollowState.initial;
  }
}

typedef FollowProvider = StateNotifierProvider<FollowNotifier, FollowState>;

final userFollowersProvider = StateNotifierProvider.family<FollowNotifier, FollowState, String>(
  (ref, id) => FollowNotifier(
    FollowState.initial.copyWith(
      userId: id,
    ),
  ),
);
