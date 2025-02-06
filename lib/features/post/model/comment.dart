

import '../../pages/data/model/feeds.dart';

class Comments {
  final String id;
  final Author user;
  final String post;
  final List<String> content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comments({
    required this.id,
    required this.user,
    required this.post,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        id: json["_id"],
        user: Author.fromJson(json["user"]),
        post: json["post"],
        content: json["content"].cast<String>(),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}

////////////////////
class Reaction {
  final String id;
  final String type;
  final Author author;

  Reaction({
    required this.id,
    required this.type,
    required this.author,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['_id'] as String,
      type: json['type'] as String,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
    );
  }
}