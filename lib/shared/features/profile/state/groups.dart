import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/model/base_model.dart';

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
  final List<GroupModel> docs;

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
    required this.docs,
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
    List<GroupModel>? docs,
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
      docs: docs ?? this.docs,
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
    docs: [],
  );

  Iterable<GroupModel> _filterBy(BaseFilterModel? filter) {
    //? If there is no filter, return early.
    if (filter == null) {
      return docs;
    }

    //? Start by creating a lazy iterable of the entire list.
    var filtered = docs as Iterable<GroupModel>;

    //? First, we check if the filter has applied promotions.
    // if (filter.isPromoted != null) {
    //   filtered = filtered.where((post) => post.isPromoted == filter.isPromoted);
    // }

    //? Second, we check if the filter has any applied categories.
    if (filter.categories != null) {
      filtered = filtered.where(
        (post) => filter.categories!.any((category) {
          return (post.categories ?? const <String>[]).contains(category.id) ||
              (post.categories ?? const <String>[]).contains(category.name);
        }),
      );
    }

    //? Third, we check if the filter has applied starting time.
    if (filter.timeStart != null) {
      filtered = filtered.where((post) => !post.createdAt.isBefore(filter.timeStart!));
    }

    //? Fourth, we check if the filter has any applied ending time.
    if (filter.timeEnd != null) {
      filtered = filtered.where((post) => !post.createdAt.isAfter(filter.timeEnd!));
    }

    //? Fifth, we check if the filter has any activity start time set.
    if (filter.activityStart != null) {
      filtered = filtered.where((post) => post.engagementCount >= filter.activityStart!);
    }

    //? Sixth, we check if the filter has any activity end( time set.
    if (filter.activityEnd != null) {
      filtered = filtered.where((post) => post.engagementCount <= filter.activityEnd!);
    }

    //? Seventh, we check if the filter has any price start time set.
    // if (filter.priceStart != null) {
    //   filtered = filtered.where((post) => post.earnings >= filter.priceStart!);
    // }

    //? Eighth, we check if the filter has any price end time set.
    // if (filter.priceEnd != null) {
    //   filtered = filtered.where((post) => post.earnings <= filter.priceEnd!);
    // }

    //? If the filter has any text you can use to search inside of it...
    if (filter.search?.isNotEmpty ?? false) {
      filtered = filtered.where((group) =>
          group.name.toLowerCase().contains(filter.search!) ||
          group.description.toString().toLowerCase().contains(filter.search!));
    }

    //? Now, we filter into the
    return filtered;
  }

  List<GroupModel> groups(BaseFilterModel? filter) {
    //? If there is searching enabled...
    if (filter != null) {
      return _filterBy(filter).toList();
    }

    //? Return what we already have.
    return docs;
  }
}
