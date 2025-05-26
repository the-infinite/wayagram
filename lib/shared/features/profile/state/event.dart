import 'package:wayagram/features/event/data/model/event_response_model.dart';

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

  List<EventDoc> events(String? search) {
    //? If there is searching enabled...
    if (search?.isNotEmpty ?? false) {
      return docs
          .where((event) =>
              event.title.toLowerCase().contains(search!) ||
              event.description.toString().toLowerCase().contains(search))
          .toList();
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
