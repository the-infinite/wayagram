import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/shared/model/base_model.dart';

class EventState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<EventDoc> docs;

  // This is fine.
  EventState({
    required this.totalSize,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.docs,
    required this.nextPage,
    required this.isLoading,
    required this.hasLoaded,
  });

  factory EventState.fromJson(Map<String, dynamic> json) {
    return EventState(
      totalSize: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPrevPage"],
      nextPage: json["nextPage"],
      docs: (json["docs"] as List).map((e) => EventDoc.fromJson(e)).toList(),
      isLoading: false,
      hasLoaded: true,
    );
  }

  //? This is fine.
  static final initial = EventState(
    totalSize: 0,
    limit: 15,
    page: 0,
    totalPages: 0,
    hasNextPage: true,
    hasPreviousPage: false,
    docs: [],
    nextPage: 1,
    isLoading: false,
    hasLoaded: false,
  );

  Iterable<EventDoc> _filterBy(BaseFilterModel? filter) {
    //? If there is no filter, return early.
    if (filter == null) {
      return docs;
    }

    //? Start by creating a lazy iterable of the entire list.
    var filtered = docs as Iterable<EventDoc>;

    //? First, we check if the filter has applied promotions.
    // if (filter.isPromoted != null) {
    //   filtered = filtered.where((post) => post.isPromoted == filter.isPromoted);
    // }

    //? Second, we check if the filter has any applied categories.
    // if (filter.categories != null) {
    //   filtered = filtered.where(
    //     (post) => filter.categories!.any((category) {
    //       return (post ?? const <String>[]).contains(category);
    //     }),
    //   );
    // }

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
    if (filter.priceStart != null) {
      filtered = filtered.where((post) => post.earnings >= filter.priceStart!);
    }

    //? Eighth, we check if the filter has any price end time set.
    if (filter.priceEnd != null) {
      filtered = filtered.where((post) => post.earnings <= filter.priceEnd!);
    }

    //? If the filter has any text you can use to search inside of it...
    if (filter.search?.isNotEmpty ?? false) {
      filtered = filtered.where(
        (event) =>
            event.title.toLowerCase().contains(filter.search!) ||
            event.description.toString().toLowerCase().contains(filter.search!),
      );
    }

    //? Now, we filter into the
    return filtered;
  }

  List<EventDoc> events(BaseFilterModel? filter) {
    //? If there is searching enabled...
    if (filter != null) {
      return _filterBy(filter).toList();
    }

    //? Return what we already have.
    return docs;
  }

  EventState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    int? totalSize,
    int? limit,
    int? page,
    int? nextPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<EventDoc>? docs,
  }) {
    return EventState(
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
}
