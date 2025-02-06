class SavedPostsResponse {
  final int currentPage;
  final int totalPages;
  final List<SavedPost> savedPosts;

  SavedPostsResponse({
    required this.currentPage,
    required this.totalPages,
    required this.savedPosts,
  });

  factory SavedPostsResponse.fromJson(Map<String, dynamic> json) {
    return SavedPostsResponse(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      savedPosts: (json['SavedPosts'] as List<dynamic>)
          .map((post) => SavedPost.fromJson(post))
          .toList(),
    );
  }
}

class SavedPost {
  final String? postId;
  final Author author;
  final String title;
  final String content;
  final List<String> media;
  final List<String> tags;
  final int commentCount;
  final List<Comment> comments;
  final List<Reaction> reactions;
  final String? profilePicture;
  final String? jobTitle;
  final bool isRepost;
  final int repostCount;
  final bool isLiked;
  final int isLikedCount;

  SavedPost({
    this.postId,
    required this.author,
    required this.title,
    required this.content,
    required this.media,
    required this.tags,
    required this.commentCount,
    required this.comments,
    required this.reactions,
    this.profilePicture,
    this.jobTitle,
    required this.isRepost,
    required this.repostCount,
    required this.isLiked,
    required this.isLikedCount,
  });

  factory SavedPost.fromJson(Map<String, dynamic> json) => SavedPost(
    postId: json['_id'] as String?,
    author: Author.fromJson(json["author"]),
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    media: (json['media'] as List<dynamic>)
        .map((media) => media as String)
        .toList(),
    tags: (json['tags'] as List<dynamic>)
        .map((tag) => tag as String)
        .toList(),
    commentCount: json['commentCount'] ?? 0,
    comments: (json['comments'] as List<dynamic>? ?? [])
        .map((comment) => Comment.fromJson(comment))
        .toList(),
    reactions: (json['reactions'] as List<dynamic>? ?? [])
        .map((reaction) => Reaction.fromJson(reaction))
        .toList(),
    profilePicture: json['profilePicture'] as String?,
    jobTitle: json['jobTitle'] as String?,
    isRepost: json['isRepost'] ?? false,
    repostCount: json['repostCount'] ?? 0,
    isLiked: json['isLiked'] ?? false,
    isLikedCount: json['isLikedCount'] ?? 0,
  );
}

class Author {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  Author({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profilePicture: json["profilePicture"] as String?,
  );
}
class Comment {
  final List<String> content;
  final Commenter commenter;

  Comment({
    required this.content,
    required this.commenter,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    content: (json['content'] as List<dynamic>).map((e) => e as String).toList(),
    commenter: Commenter.fromJson(json['commenter']),
  );
}
// class Comment {
//   final String userId;
//   final String type;
//   final String id;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   Comment({
//     required this.userId,
//     required this.type,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Comment.fromJson(Map<String, dynamic> json) => Comment(
//     userId: json['userId'],
//     type: json['type'],
//     id: json['_id'],
//     createdAt: DateTime.parse(json['createdAt']),
//     updatedAt: DateTime.parse(json['updatedAt']),
//   );
// }

class Reaction {
  final String userId;
  final String type;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reaction({
    required this.userId,
    required this.type,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
    userId: json['userId'],
    type: json['type'],
    id: json['_id'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

class Commenter {
  final String firstName;
  final String lastName;
  final String? profilePicture; // Nullable field

  Commenter({
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  factory Commenter.fromJson(Map<String, dynamic> json) => Commenter(
    firstName: json['firstName'],
    lastName: json['lastName'],
    profilePicture: json['profilePicture'] as String?, // Accepts null
  );
}