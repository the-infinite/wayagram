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
  final String? search;
  final List<PollModel> docs;

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
    required this.search,
    required this.hasPreviousPage,
    required this.docs,
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
    String? search,
    List<PollModel>? docs,
  }) {
    return PollsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      totalSize: totalSize ?? this.totalSize,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      nextPage: nextPage ?? this.nextPage,
      totalPages: totalPages ?? this.totalPages,
      search: search ?? this.search,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      docs: docs ?? this.docs,
    );
  }

  List<PollModel> get polls {
    //? If there is searching enabled...
    if (search != null) {
      return docs
          .where((poll) =>
              poll.question.toLowerCase().contains(search!) ||
              (poll.choices?.any((choice) => choice.description.toString().toLowerCase().contains(search!)) ?? false))
          .toList();
    }

    //? Return what we already have.
    return docs;
  }

  static final initial = PollsState(
    hasLoaded: false,
    isLoading: false,
    totalSize: 0,
    limit: 15,
    page: 0,
    nextPage: 1,
    totalPages: 0,
    search: null,
    hasNextPage: true,
    hasPreviousPage: false,
    docs: [],
  );
}
