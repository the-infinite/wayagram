import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/polls_and_voting/data/repo/poll_and_voting_repository.dart';
import 'package:wayagram/shared/features/profile/model/poll.dart';
import 'package:wayagram/shared/features/profile/state/poll.dart';

class UserPollsNotifier extends StateNotifier<PollsState> {
  final repo = PollAndVotingRepository();
  UserPollsNotifier() : super(PollsState.initial);

  Future<List<PollModel>> getPollsByUser(String id) async {
    final result = <PollModel>[];

    try {
      // This is fine too.
      final response = await repo.getAllPolls(state.nextPage ?? state.page, state.limit, id);

      // If this was fine...
      if (response.success) {
        final data = response.data["data"];

        //? Parse the posts as they are in the response object...
        final docs = (data['docs'] as List).map((doc) => PollModel.fromJson(doc));

        //? Now, add these to what we have here.
        result.addAll(docs);

        //? If the previous page had a next page, offload them onto this place.
        if (state.hasNextPage) {
          result.addAll(state.polls);
        }

        //? This is fine.
        state = state.copyWith(
          polls: result,
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
      // TODO: Actual error handling.
      rethrow;
    }

    // That's fine.
    return result;
  }

  void reset() {
    state = PollsState.initial;
  }
}

final userPollsProvider = StateNotifierProvider<UserPollsNotifier, PollsState>((ref) => UserPollsNotifier());
