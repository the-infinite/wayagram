import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class ExploreRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> getFeeds(int page, [int limit = 20 ]) {
    return get("$serviceUrl/posts/users/feed?page=$page&limit=$limit");
  }
}
