import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

class UserSearchState {
  final bool isLoading;
  final bool hasNextPage;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;
  final List<String> searchedFields;
  final List<User> results;
  final String query;

  UserSearchState({
    required this.isLoading,
    required this.hasNextPage,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
    required this.searchedFields,
    required this.results,
    required this.query,
  });

  static final initial = UserSearchState(
    isLoading: false,
    hasNextPage: false,
    page: 1,
    limit: 50,
    totalPages: 0,
    totalResults: 0,
    searchedFields: [],
    results: [],
    query: "",
  );

  /// Creates a new instance of [UserSearchState] with optional updated values.
  ///
  /// Takes optional parameters to update specific fields while maintaining
  /// the values of fields that are not specified.
  ///
  /// Returns a new [UserSearchState] instance with the updated values.
  UserSearchState copyWith({
    bool? isLoading,
    bool? hasNextPage,
    int? page,
    int? totalPages,
    int? totalResults,
    List<String>? searchedFields,
    List<User>? results,
    String? query,
  }) {
    return UserSearchState(
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
      limit: limit,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
      searchedFields: searchedFields ?? this.searchedFields,
      results: results ?? this.results,
      query: query ?? this.query,
    );
  }
}
