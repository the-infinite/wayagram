import 'package:wayagram/shared/features/profile/model/post.dart';

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
  final List<PostModel> posts;

  // This is fine.
  PostState({
    required this.totalSize,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.posts,
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
      posts: (json["docs"] as List).map((e) => PostModel.fromJson(e)).toList(),
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
    posts: [],
    nextPage: 1,
    isLoading: false,
    hasLoaded: false,
  );

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
    List<PostModel>? posts,
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
      posts: posts ?? this.posts,
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
  final List<PostModel> posts;
  final List<BookmarkModel> bookmarks;

  // This is fine.
  SavedPostState({
    required this.totalSize,
    required this.limit,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.posts,
    required this.nextPage,
    required this.isLoading,
    required this.hasLoaded,
    required this.bookmarks,
  });

  factory SavedPostState.fromJson(Map<String, dynamic> json) {
    return SavedPostState(
      bookmarks:
          (json["docs"] as List).map((e) => BookmarkModel.fromJson(e)).toList(),
      totalSize: json["totalDocs"],
      limit: json["limit"],
      page: json["page"],
      totalPages: json["totalPages"],
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPrevPage"],
      nextPage: json["nextPage"],
      posts: (json["docs"] as List).map((e) => PostModel.fromJson(e)).toList(),
      isLoading: false,
      hasLoaded: true,
    );
  }

  //? This is fine.
  static final initial = SavedPostState(
    totalSize: 0,
    limit: 1000,
    page: 0,
    totalPages: 0,
    hasNextPage: true,
    hasPreviousPage: false,
    posts: [],
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
    List<PostModel>? posts,
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
      posts: posts ?? this.posts,
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

