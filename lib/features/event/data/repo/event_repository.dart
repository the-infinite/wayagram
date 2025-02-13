import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/event/data/model/add_event_request_model.dart';

class EventRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> createEvent(AddEventRequestModel payload) {
    return post("$serviceUrl/events/create", payload.toJson(), formdata: true);
  }

  Future<WayaRequestResponse> getEvents({int? limit = 100, int? page = 1}) {
    return get("$serviceUrl/events/get-event?limit=$limit&page=$page");
  }

  Future<WayaRequestResponse> getUserEvents(
      {required String userId, required int page}) {
    return get("$serviceUrl/events/get-event?userId=$userId&page=$page");
  }

  Future<WayaRequestResponse> getEventWithStatus(
      {required String status, required int page}) {
    return get("$serviceUrl/events/get-event?eventstatus=$status&page=$page");
  }

  Future<WayaRequestResponse> editEvent(
      AddEventRequestModel payload, String id) {
    return patch("$serviceUrl/events/edit-event/$id", payload.toJson(),
        formdata: true);
  }

  Future<WayaRequestResponse> joinEvent(
      {required String userId, required String eventId}) {
    return post(
      "$serviceUrl/join-events",
      {"userId": userId, "eventId": eventId},
    );
  }

  Future<WayaRequestResponse> reportEvent(
      {required String userId,
      required String eventId,
      required String reason,
      String? comment}) {
    final payload = {"userId": userId, "eventId": eventId, "reason": reason};
    if (comment != null) payload['comment'] = comment;
    return post("$serviceUrl/join-events", payload);
  }

  Future<WayaRequestResponse> joinedUsers({required String id, required int page, int? limit = 10}) {
    return get("$serviceUrl/join-events/get?eventId=$id&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getSingleEvent(String id) {
    return get("$serviceUrl/events/get-event?id=$id");
  }

  Future<WayaRequestResponse> follow(String id) {
    return post("$serviceUrl/follow/$id", null);
  }

  Future<WayaRequestResponse> unfollow(String id) {
    return post("$serviceUrl/follow/$id/unfollow", null);
  }

  Future<WayaRequestResponse> getFollow(String id) {
    return get("$serviceUrl/follow/status/$id");
  }
}
