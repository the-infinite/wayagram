import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class MomentRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> createMoment(
      {required String userId,
      required String name,
      required String image,
      required String content,
      String? caption,
      required String contentType}) {
    final payload = {
      "userId": userId,
      'name': name,
      'image': image,
      'content': content,
      'contentType': contentType
    };
    if (caption != null) payload['caption'];
    return post("$serviceUrl/moments/create", payload);
  }

  Future<WayaRequestResponse> getUserMoments({required String userId}) {
    return get("$serviceUrl/moments/get?userId=$userId");
  }

  Future<WayaRequestResponse> viewMoments(
      {required String profileId, required momentId}) {
    return get(
        "$serviceUrl/view-moment?profile_id=$profileId&moment_id=$momentId");
  }
}
