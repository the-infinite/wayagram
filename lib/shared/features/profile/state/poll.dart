import 'package:wayagram/shared/features/profile/model/poll.dart';

class PollsState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<PollModel> polls;

  // Construct.
  PollsState({
    required this.hasLoaded,
    required this.isLoading,
    required this.totalSize,
    required this.limit,
    required this.page,
    required this.nextPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.polls,
  });

  PollsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    int? totalSize,
    int? limit,
    int? page,
    int? nextPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<PollModel>? polls,
  }) {
    return PollsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      totalSize: totalSize ?? this.totalSize,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      nextPage: nextPage ?? this.nextPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      polls: polls ?? this.polls,
    );
  }

  static final initial = PollsState(
    hasLoaded: false,
    isLoading: false,
    totalSize: 0,
    limit: 15,
    page: 0,
    nextPage: 1,
    totalPages: 0,
    hasNextPage: true,
    hasPreviousPage: false,
    polls: [],
  );
}
