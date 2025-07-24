import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/model/base_model.dart';

class PostState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<PostModel> docs;

  // This is fine.
  PostState({
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

  factory PostState.fromJson(Map<String, dynamic> json) {
    return PostState(
      totalSize: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPrevPage"],
      nextPage: json["nextPage"],
      docs: (json["docs"] as List).map((e) => PostModel.fromJson(e)).toList(),
      isLoading: false,
      hasLoaded: true,
    );
  }

  //? This is fine.
  static final initial = PostState(
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

  Iterable<PostModel> _filterBy(BaseFilterModel? filter) {
    //? If there is no filter, return early.
    if (filter == null) {
      return docs;
    }

    //? Start by creating a lazy iterable of the entire list.
    var filtered = docs as Iterable<PostModel>;

    //? First, we check if the filter has applied promotions.
    if (filter.isPromoted != null) {
      filtered = filtered.where((post) => post.isPromoted == filter.isPromoted);
    }

    //? Second, we check if the filter has any applied categories.
    if (filter.categories != null) {
      filtered = filtered.where(
        (post) => filter.categories!.any((category) {
          return (post.categories ?? const <String>[]).contains(category);
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

    //? If the filter has any text you can use to search inside of it...
    if (filter.search?.isNotEmpty ?? false) {
      filtered = filtered.where((post) =>
          post.content.toString().toLowerCase().contains(filter.search!) ||
          post.hashtags.map((e) => e.toString()).any((tag) => tag.toLowerCase().contains(filter.search!)));
    }

    //? Now, we filter into the
    return filtered;
  }

  List<PostModel> posts(BaseFilterModel? filter) {
    //? If there is searching enabled...
    if (filter != null) {
      return _filterBy(filter).toList();
    }

    //? Return what we already have.
    return docs;
  }

  PostState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    int? totalSize,
    int? limit,
    int? page,
    int? nextPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<PostModel>? docs,
  }) {
    return PostState(
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

class SavedPostState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<PostModel> docs;
  final List<BookmarkModel> bookmarks;

  // This is fine.
  SavedPostState({
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
    required this.bookmarks,
  });

  factory SavedPostState.fromJson(Map<String, dynamic> json) {
    return SavedPostState(
      bookmarks: (json["docs"] as List).map((e) => BookmarkModel.fromJson(e)).toList(),
      totalSize: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPrevPage"],
      nextPage: json["nextPage"],
      docs: (json["docs"] as List).map((e) => PostModel.fromJson(e)).toList(),
      isLoading: false,
      hasLoaded: true,
    );
  }

  Iterable<PostModel> _filterBy(BaseFilterModel? filter) {
    //? If there is no filter, return early.
    if (filter == null) {
      return docs;
    }

    //? Start by creating a lazy iterable of the entire list.
    var filtered = docs as Iterable<PostModel>;

    //? First, we check if the filter has applied promotions.
    if (filter.isPromoted != null) {
      filtered = filtered.where((post) => post.isPromoted == filter.isPromoted);
    }

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

    //? If the filter has any text you can use to search inside of it...
    if (filter.search?.isNotEmpty ?? false) {
      filtered = filtered.where((post) =>
          post.content.toString().toLowerCase().contains(filter.search!) ||
          post.hashtags.map((e) => e.toString()).any((tag) => tag.toLowerCase().contains(filter.search!)));
    }

    //? Now, we filter into the
    return filtered;
  }

  List<PostModel> posts(BaseFilterModel? filter) {
    //? If there is searching enabled...
    if (filter != null) {
      return _filterBy(filter).toList();
    }

    //? Return what we already have.
    return docs;
  }

  //? This is fine.
  static final initial = SavedPostState(
    totalSize: 0,
    limit: 1000,
    page: 0,
    totalPages: 0,
    hasNextPage: true,
    hasPreviousPage: false,
    docs: [],
    bookmarks: [],
    nextPage: 1,
    isLoading: false,
    hasLoaded: false,
  );

  SavedPostState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    int? totalSize,
    int? limit,
    int? page,
    int? nextPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<PostModel>? docs,
    List<BookmarkModel>? bookmarks,
  }) {
    return SavedPostState(
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
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }

  PostModel? find(String id) {
    return docs.where((post) => post.id == id).firstOrNull;
  }

  bool isSaved(String id) {
    return docs.any((post) => post.id == id);
  }
}
