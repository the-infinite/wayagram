import 'package:flutter/foundation.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';

class MomentRepository extends BaseRepository {
  static const serviceUrl = WayaServiceUri.graph;
  static final instance = MomentRepository._();

  MomentRepository._();

  factory MomentRepository() => instance;

  Future<WayaRequestResponse> createMoment(
      {required String userId,
      required String name,
      required String image,
      required String content,
      required String thumbnail,
      String? fontType,
      String? caption,
      String? color,
      required String contentType}) {
    final payload = {
      "userId": userId,
      'name': name,
      'image': image,
      'content': content,
      'contentType': contentType,
      'thumbnail': thumbnail,
    };
    if (caption != null) payload['caption'] = caption;
    if (color != null) payload['color'] = color;
    if (fontType != null) payload['fontType'] = fontType;
    debugPrint("$fontType  $payload");
    return post("$serviceUrl/moments/create", payload);
  }

  Future<WayaRequestResponse> getUserMoments(
      {required String userId, required int page, int? limit = 100}) {
    return get(
        "$serviceUrl/moments/get?userId=$userId&limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> viewMoments({
    required String profileId,
    required String momentId,
    bool? likeMoment,
    bool? comment,
  }) {
    final payload = {
      'userId': profileId,
      'momentId': momentId,
    };
    if (likeMoment != null) payload['likeMoment'];
    if (comment != null) payload['comment'];

    return post("$serviceUrl/view-moments/view", payload);
  }

  Future<WayaRequestResponse> deleteMoment(String momentId) async {
    return delete("$serviceUrl/moments/$momentId");
  }

// /
  Future<WayaRequestResponse> getAllMoments({int? limit = 100}) async {
    return get("$serviceUrl/moments/get-active?limit=$limit");
  }

  Future<WayaRequestResponse> editMoment(
      {required String userId,
      required String name,
      required String image,
      required String content,
      required String momentId,
      required String thumbnail,
      String? caption,
      String? color,
      String? fontType,
      required String contentType}) {
    final payload = {
      "userId": userId,
      'name': name,
      'image': image,
      'content': content,
      'contentType': contentType,
      'thumbnail': thumbnail
    };
    if (caption != null) payload['caption'] = caption;
    if (color != null) payload['color'] = color;
    if (fontType != null) payload['fontType'] = fontType;
    return patch(
      "$serviceUrl/moments/$momentId",
      payload,
    );
  }

  ///moments/get
  Future<WayaRequestResponse> getSingleMoment({required String id}) {
    return get("$serviceUrl/moments/get?id=$id");
  }

  ///moments/:momentId
  ///
  ///
  Future<WayaRequestResponse> reportMoment(
      {required String userId,
      required String momentId,
      required String reason,
      String? comment}) {
    final payload = {"momentId": momentId, "reason": reason};
    if (comment != null) payload['comment'] = comment;
    return post("$serviceUrl/reports/create", payload);
  }

  Future<WayaRequestResponse> momentViewers(
      {int? limit = 10, required String momentId, required int page}) async {
    return get(
        "$serviceUrl/view-moments/viewers?momentId=$momentId&limit=$limit&page=$page");
  }
}
