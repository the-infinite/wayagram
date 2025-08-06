import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/repo/user_profile_repository.dart';
import 'package:wayagram/shared/features/profile/state/groups.dart';

class GroupsNotifier extends StateNotifier<GroupsState> {
  final UserProfileRepository repo;
  GroupsNotifier(super.state, this.repo);

  Future<List<GroupModel>> getGroupsForUser(String id) async {
    final result = <GroupModel>[];

    try {
      // This is fine too.
      final response = await repo.getGroupsForUser(
          id, state.nextPage ?? state.page, state.limit);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs =
            (data['docs'] as List).map((doc) => GroupModel.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.docs);
        }

        //? This is fine.
        state = state.copyWith(
          docs: result,
          totalSize: data['totalDocs'],
          totalPages: int.tryParse(data['totalPages'].toString()) ?? 1,
          hasNextPage: data['hasNextPage'],
          page: int.tryParse(data['page'].toString()) ?? 1,
          nextPage: int.tryParse(data['nextPage'].toString()) ?? 1,
          hasLoaded: true,
        );
      }

      //? After getting these posts...
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    // That's fine.
    return result;
  }

  void reset() {
    state = GroupsState.initial;
  }
}

final userGroupsProvider =
    StateNotifierProvider.family<GroupsNotifier, GroupsState, String>(
        (ref, id) {
  final userRepository = ref.watch(userProfileRepositoryProvider);
  return GroupsNotifier(GroupsState.initial, userRepository);
});
