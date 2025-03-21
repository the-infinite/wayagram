import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:wayagram/core/data/local_data_source.dart';

class PostsResponse {
  final int currentPage;
  final int totalPages;
  final List<Post> posts;

  PostsResponse({
    required this.currentPage,
    required this.totalPages,
    required this.posts,
  });

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    print('Parsing Posts Response: $json');
    return PostsResponse(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      posts: (json['postsWithFullUrls'] as List<dynamic>).map((post) {
        return Post.fromJson(post);
      }).toList(),
    );
  }
}

class Post {
  final String? id;
  final String content;
  final List<String?> media;
  final List<String> tags;
  late final RxInt commentCount;
  final List<Comment> comments;
  final Map<String, Reaction> reactions;
  final RxBool isReposted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final _isLiked = Rx<bool?>(null);
  final RxInt isLikedCount;
  final RxInt repostCount;

  Post({
    required this.id,
    required this.content,
    required this.media,
    required this.tags,
    required this.commentCount,
    required this.comments,
    required this.reactions,
    required this.createdAt,
    required this.updatedAt,
    //required this.shareLink,
    required this.isReposted,
    required this.repostCount,
    required this.isLikedCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        content: json['content'] ?? '',
        media: (json['media'] as List<dynamic>?)
                ?.map((media) => media as String)
                .toList() ??
            [],
        tags: (json['tags'] as List<dynamic>?)
                ?.map((tag) => tag as String)
                .toList() ??
            [],
        commentCount: ((json['commentCount'] ?? 0)),
        comments: List<Comment>.from((json['comments'] ?? []).map((comment) =>
            comment is String?
                ? Comment(
                    content: [],
                    commenter: Commenter(
                        firstName: '', lastName: '', profilePicture: ''))
                : Comment.fromJson(comment))),
        reactions: {
          for (var r in json['reactions'] ?? [])
            getReactionUserId(r['userId']): Reaction.fromJson(r)
        }.obs,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? ''),
//shareLink: json['shareLink'],
        isReposted: ((json['isRepost'] ?? false)),
        repostCount: ((json['repostCount'] ?? 0)),
        isLikedCount: ((json['isLikedCount'] ?? 0)),
      );

  Rx<bool?> getIsLiked() {
    WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();
    if (_isLiked.value == null) {
//Get.find<ProfileController>().getProfile().value.data;
// if (user != null) {
// _isLiked.value = reactions[user.id!] != null;
// } else {
// //debugPrint('Error:: User data has not been fetched!!');
// }
    }
    return _isLiked;
  }

  void toggleLike() {
    getIsLiked();
    _isLiked.toggle();
  }

  static String getReactionUserId(dynamic data) {
    if (data is String?) {
      return data ?? '';
    } else {
      return data['_id'];
    }
  }

String? getReactionId(String userId) => reactions[userId]?.id;
}

/*class Post {
  final String? id;
  Author? author;
  final String title;
  final String content;
  final List<String?> media;
  final List<String> tags;
  late final RxInt commentCount;
  final List<Comment> comments;
  final RxMap<String, Reaction> reactions;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? shareLink;
  final RxBool isReposted;
  final _isLiked = Rx<bool?>(null);
  final RxInt isLikedCount;
  final RxInt repostCount;

  Post({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.media,
    required this.tags,
    required this.commentCount,
    required this.comments,
    required this.reactions,
    required this.createdAt,
    required this.updatedAt,
    required this.shareLink,
    required this.isReposted,
    required this.repostCount,
    required this.isLikedCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        author: json["author"] == null || json["author"] is String
            ? null
            : Author.fromJson(json["author"]),
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        media: (json['media'] as List<dynamic>?)
                ?.map((media) => media as String)
                .toList() ??
            [],
        tags: (json['tags'] as List<dynamic>?)
                ?.map((tag) => tag as String)
                .toList() ??
            [],
        commentCount: ((json['commentCount'] ?? 0) as int).obs,
        comments: List<Comment>.from((json['comments'] ?? []).map((comment) =>
            comment is String?
                ? Comment(
                    content: [],
                    commenter: Commenter(
                        firstName: '', lastName: '', profilePicture: ''))
                : Comment.fromJson(comment))),
        reactions: {
          for (var r in json['reactions']??[])
            getReactionUserId(r['userId']): Reaction.fromJson(r)
        }.obs,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? ''),
        shareLink: json['shareLink'],
        isReposted: ((json['isRepost'] ?? false) as bool).obs,
        repostCount: ((json['repostCount'] ?? 0) as int).obs,
        isLikedCount: ((json['isLikedCount'] ?? 0) as int).obs,
      );

  Rx<bool?> getIsLiked() {
    WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();
    if (_isLiked.value == null) {
      final user = _wayaLocalDataSource.getUser().user;
          //Get.find<ProfileController>().getProfile().value.data;
      if (user != null) {
        _isLiked.value = reactions[user.id!] != null;
      } else {
       //debugPrint('Error:: User data has not been fetched!!');
      }
    }
    return _isLiked;
  }

  void toggleLike() {
    getIsLiked();
    _isLiked.toggle();
  }

  static String getReactionUserId(dynamic data) {
    if (data is String?) {
      return data ?? '';
    } else {
      return data['_id'];
    }
  }

  String? getReactionId(String userId) => reactions[userId]?.id;
}*/

class Author {
  final String? id;
  final String firstName;
  final String lastName;
  final String? jobTitle;
  final String? profilePicture;
  // final List<dynamic>? profilePicture;

  Author({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.jobTitle,
    this.profilePicture,
    // this.profilePicture,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profilePicture: json['profilePicture'],
        jobTitle: json['jobTitle'],
      );
}

class Comment {
  final List<String> content;
  final Commenter commenter;

  Comment({
    required this.content,
    required this.commenter,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      content: List<String>.from(json['content']),
      commenter: Commenter.fromJson(json['commenter']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'commenter': commenter.toJson(),
    };
  }
}

class Commenter {
  final String firstName;
  final String lastName;
  // final List<dynamic> profilePicture;
  final String profilePicture;

  Commenter({
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  factory Commenter.fromJson(Map<String, dynamic> json) {
    return Commenter(
      firstName: json['firstName'],
      lastName: json['lastName'],
      // profilePicture:
      //     json['profilePicture'] ?? [],
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}

class Reaction {
  Author userId;
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
        userId: json["userId"] == null || json["userId"] is String
            ? Author(
                id: json["userId"] ?? '',
                firstName: 'Name not set',
                lastName: '')
            : Author.fromJson(json["userId"]),
        type: json["type"] ?? 'Like',
        id: json["_id"] ?? '',
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["createdAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["updatedAt"]),
      );
}
