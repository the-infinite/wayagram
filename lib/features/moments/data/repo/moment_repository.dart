import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class MomentRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> createMoment(
      {required String userId,
      required String name,
      required String image,
      required String content,
      String? fontType,
      String? caption,
      String? color,
      required String contentType}) {
    final payload = {
      "userId": userId,
      'name': name,
      'image': image,
      'content': content,
      'contentType': contentType
    };
    if (caption != null) payload['caption'] = caption;
    if (color != null) payload['color'] = color;
    if (fontType != null) payload['fontType'] = fontType;
 print("$fontType  $payload");
    return post("$serviceUrl/moments/create", payload);
  }

  Future<WayaRequestResponse> getUserMoments(
      {required String userId, required int page, int? limit = 100}) {
    return get(
        "$serviceUrl/moments/get?userId=$userId&limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> viewMoments(
      {required String profileId,
      required String momentId,
      bool? likeMoment,
      bool? comment}) {
    final payload = {
      'userId': profileId,
      'momentId': momentId,
    };
    if (likeMoment == true) payload['likeMoment'];
    if (comment == true) payload['comment'];

    return post("$serviceUrl/view-moments/view", payload);
  }

  Future<WayaRequestResponse> deleteMoment(String momentId) async {
    return delete("$serviceUrl/moments/$momentId");
  }

// /
  Future<WayaRequestResponse> getAllMoments({int? limit = 200}) async {
    return get("$serviceUrl/moments/get?limit=$limit");
  }

  Future<WayaRequestResponse> editMoment(
      {required String userId,
      required String name,
      required String image,
      required String content,
      required String momentId,
      String? caption,
      String? color,
      String? fontType,
      required String contentType}) {
    final payload = {
      "userId": userId,
      'name': name,
      'image': image,
      'content': content,
      'contentType': contentType
    };
 if (caption != null) payload['caption'] = caption;
    if (color != null) payload['color'] = color;
    if (fontType != null) payload['fontType'] = fontType;
    return patch("$serviceUrl/moments/$momentId", payload);
  }

  ///moments/:momentId
  ///
  ///
   Future<WayaRequestResponse> reportMoment(
      {required String userId,
      required String momentId,
      required String reason,
      String? comment}) {
    final payload = {"userId": userId, "momentId": momentId, "reason": reason};
    if (comment != null) payload['comment'] = comment;
    return post("$serviceUrl/report-moments", payload);
  }
}
