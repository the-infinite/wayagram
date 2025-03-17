import 'package:wayagram/shared/features/profile/model/groups.dart';

class GroupsState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<GroupModel> groups;

  // Construct.
  GroupsState({
    required this.hasLoaded,
    required this.isLoading,
    required this.totalSize,
    required this.limit,
    required this.page,
    required this.nextPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.groups,
  });

  GroupsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    int? totalSize,
    int? limit,
    int? page,
    int? nextPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<GroupModel>? groups,
  }) {
    return GroupsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      totalSize: totalSize ?? this.totalSize,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      nextPage: nextPage ?? this.nextPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      groups: groups ?? this.groups,
    );
  }

  static final initial = GroupsState(
    hasLoaded: false,
    isLoading: false,
    totalSize: 0,
    limit: 15,
    page: 0,
    nextPage: 1,
    totalPages: 0,
    hasNextPage: true,
    hasPreviousPage: false,
    groups: [],
  );
}
