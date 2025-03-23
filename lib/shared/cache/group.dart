import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';

class GroupsCache extends WayaCacheUtility<GroupModel> {
  // Construct.
  GroupsCache._() : super();

  //? This is fine.
  static final instance = GroupsCache._();
  factory GroupsCache() => instance;

  @override
  void cacheAll(Iterable<GroupModel> data) {
    //? If there is no post to add, leave.
    if (data.isEmpty) return;

    //? Add each post here, iteratively.
    for (final page in data) {
      putOrReplace(page.id, page);
    }

    refresh();
  }
}

/// A singleton instance of [GroupsCache] used for caching group-related data throughout
/// the application. This cache provides centralized access to group information and
/// helps reduce network requests by storing frequently accessed group data.
final wayaGroupCache = GroupsCache.instance;
