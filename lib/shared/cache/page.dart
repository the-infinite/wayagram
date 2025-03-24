import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';

class PagesCache extends WayaCacheUtility<PageModel> {
// Construct.
  PagesCache._() : super();

  //? This is fine.
  static final instance = PagesCache._();
  factory PagesCache() => instance;

  @override
  void cacheAll(Iterable<PageModel> data) {
    //? If there is no post to add, leave.
    if (data.isEmpty) return;

    //? Add each post here, iteratively.
    for (final page in data) {
      putOrReplace(page.id, page);
    }

    refresh();
  }
}

/// A singleton instance of [PagesCache] used to manage cached pages across the
/// application. This cache helps improve performance by storing frequently
/// accessed pages in memory.
final wayaPageCache = PagesCache.instance;
