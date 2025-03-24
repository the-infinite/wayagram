import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';

class CommentCache extends WayaCacheUtility<CommentModel> {
  // Construct.
  CommentCache._() : super();

  //? This is fine.
  static final instance = CommentCache._();
  factory CommentCache() => instance;

  @override
  void cacheAll(Iterable<CommentModel> data) {
    //? If there is no post to add, leave.
    if (data.isEmpty) return;

    //? Add each post here, iteratively.
    for (final page in data) {
      putOrReplace(page.id, page);
    }

    refresh();
  }
}

/// Singleton instance of [CommentCache] used for managing comment-related caching operations
/// throughout the WayaGram application.
///
/// This cached instance helps improve performance by storing and retrieving
/// comment data locally, reducing unnecessary network requests.
final wayaCommentCache = CommentCache.instance;
