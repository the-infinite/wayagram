import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class PostCache extends WayaCacheUtility<PostModel> {
  // Construct.
  PostCache._() : super();

  //? This is fine.
  static final instance = PostCache._();
  factory PostCache() => instance;

  void _putForMeasure(PostModel usedPost) {
    final found = getCachedData(usedPost.id);

    //? If this was found.
    if (found != null) {
      putOrReplace(
        usedPost.id,
        usedPost.copyWith(
          page: found.page,
          group: found.group,
          user: found.user,
          originalPostId: found.originalPostId,
          originalPost: found.originalPost,
        ),
      );
      return;
    }

    //? Then just do what is regular.
    putOrReplace(usedPost.id, usedPost);
  }

  @override
  void cacheAll(Iterable<PostModel> data) {
    //? If there is no post to add, leave.
    if (data.isEmpty) return;

    //? Add each post here, iteratively.
    for (final post in data) {
      _putForMeasure(post);
    }

    // Refresh this.
    refresh();
  }
}

/// A global reference to the singleton PostCache instance.
///
/// This variable provides convenient access to the post caching system
/// throughout the application. Use this to store, retrieve, and manage
/// cached post data.
final wayaPostCache = PostCache.instance;
