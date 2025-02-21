
//import 'package:wayagram/features/explore/data/model/default.dart';

class Ugt {
  final String logo;
  final String institution;
  final int noOfParticipants;
  final String about;
 // final List<Vote> votes;

  Ugt(
      {required this.about,
      required this.institution,
      required this.logo,
      required this.noOfParticipants,
      //required this.votes
      });
}


class Post {
  final String id;
  final String content;
  final String author;
  bool isLiked;
  bool isFollowing;
  int likes;

  Post({
    required this.id,
    required this.content,
    required this.author,
    this.isLiked = false,
    this.isFollowing = false,
    this.likes = 0,
  });

  // Copy method to modify the state
  Post copyWith({bool? isLiked, bool? isFollowing, int? likes}) {
    return Post(
      id: id,
      content: content,
      author: author,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      likes: likes ?? this.likes,
    );
  }
}