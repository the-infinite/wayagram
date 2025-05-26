import 'package:wayagram/shared/features/profile/model/post.dart';

class PostState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final String? search;
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
    required this.search,
    required this.isLoading,
    required this.hasLoaded,
  });

  factory PostState.fromJson(Map<String, dynamic> json) {
    return PostState(
      totalSize: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      search: json['search'],
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
    search: null,
    nextPage: 1,
    isLoading: false,
    hasLoaded: false,
  );

  List<PostModel> get posts {
    //? If there is searching enabled...
    if (search != null) {
      return docs
          .where((post) =>
              post.content.toLowerCase().contains(search!) ||
              post.hashtags.any((tag) => tag.toLowerCase().contains(search!)))
          .toList();
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
    String? search,
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
      search: search ?? this.search,
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
  final String? search;
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
    required this.search,
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
      search: json['search'],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPrevPage"],
      nextPage: json["nextPage"],
      docs: (json["docs"] as List).map((e) => PostModel.fromJson(e)).toList(),
      isLoading: false,
      hasLoaded: true,
    );
  }

  List<PostModel> get posts {
    //? If there is searching enabled...
    if (search != null) {
      return docs
          .where((post) =>
              post.content.toLowerCase().contains(search!) ||
              post.hashtags.any((tag) => tag.toLowerCase().contains(search!)))
          .toList();
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
    search: null,
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
    String? search,
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
      search: search ?? this.search,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }

  BookmarkModel? find(String id) {
    return bookmarks.where((post) => post.postId == id).firstOrNull;
  }

  bool isSaved(String id) {
    return bookmarks.any((post) => post.postId == id);
  }
}
