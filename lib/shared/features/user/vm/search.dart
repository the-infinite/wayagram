import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/shared/features/user/repo/default.dart';
import 'package:wayagram/shared/features/user/state/search.dart';

class UserSearchNotifier extends StateNotifier<UserSearchState> {
  final repo = UserRepository.instance;
  UserSearchNotifier(super.state);

  /// Retrieves a list of users based on the search query.
  ///
  /// The [query] parameter is the search string used to filter users.
  /// Returns a [Future] that resolves to a [List] of [User] objects matching the query.
  /// The search is asynchronous and may take some time to complete.
  Future<List<User>> getSearchResults(String query) async {
    //? Our list of results.
    final results = <User>[];

    //? If this is querying something different from the last...
    if (state.query != query) {
      // Update th search query and general state.
      state = state.copyWith(
        query: query,
        page: 1,
        hasNextPage: true,
        results: [],
      );
    }

    //? Since this is the same as the previous query, we can append results.
    else {
      results.addAll(state.results);
    }

    //? If we have reached the end of our pagination...
    if (!state.hasNextPage) {
      //? Just return this one.
      state = state.copyWith(
        results: [
          ...state.results,
        ],
      );

      //? Just return this.
      return state.results;
    }

    //? Now, notify the listeners that we are loading.
    state = state.copyWith(isLoading: true);

    //? Try sending the request.
    final response = await repo.getSearchResults(query, state.limit, state.page);

    //? If this was fine...
    if (response.success) {
      //? Parse the users as they are in the response object...
      final docs = (response.data['docs'] as List<Map<String, dynamic>>).map((doc) => User.fromJson(doc));

      //? This is fine.
      results.addAll(docs);

      //? Update state.
      state = state.copyWith(
        results: results,
        totalResults: response.data['totalDocs'],
        totalPages: response.data['totalPages'],
        hasNextPage: response.data['hasNextPage'],
        page: response.data['nextPage'] ?? 1,
        isLoading: false,
      );
    }

    //? Since it failed.
    else {
      state = state.copyWith(isLoading: false);
    }

    //? Return this result.
    return results;
  }
}


final userSearchProvider = StateNotifierProvider<UserSearchNotifier, UserSearchState>(
  (ref) {
    return UserSearchNotifier(UserSearchState.initial);
  },
);
