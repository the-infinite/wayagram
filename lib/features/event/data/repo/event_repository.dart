import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/add_event_request_model.dart';
import 'package:wayagram/features/event/data/model/update_event_request_model.dart';

part 'event_repository.g.dart';

class EventRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = WayaServiceUri.graph;

  EventRepository(super.ref);

  Future<WayaRequestResponse> createEvent(AddEventRequestModel payload) {
    return post("$serviceUrl/events/create", payload.toJson(), formdata: false);
  }

  Future<WayaRequestResponse> getEvents({int? limit = 500, int? page = 1}) {
    return get("$serviceUrl/events/get-event?limit=$limit&page=$page");
  }

  ///client/events/invite
  Future<WayaRequestResponse> inviteUsers(
      {required List<String> userIds,
      required String eventLink,
      required String eventTitle}) {
    return post("$serviceUrl/events/invite",
        {"userIds": userIds, "eventTitle": eventTitle, "eventLink": eventLink});
  }

  Future<WayaRequestResponse> getUserEvents(
      {required String userId, required int page}) {
    return get("$serviceUrl/events/get-event?userId=$userId&page=$page");
  }

  Future<WayaRequestResponse> getEventWithStatus(
      {required String status, required int page, required int limit}) {
    return get(
        "$serviceUrl/events/get-event?eventstatus=$status&status=active&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> requestForEventPayout(String eventId) {
    return post('$serviceUrl/events-transactions', {"eventId": eventId},
        formdata: false);
  }

  Future<WayaRequestResponse> getPayoutTransactions(String eventId) {
    return get(
        '$serviceUrl/events-transactions/get-transactions?eventId=$eventId');
  }

  ///events-transactions/get-payouts
  Future<WayaRequestResponse> getPayouts(String eventId) {
    return get('$serviceUrl/events-transactions/get-payouts?eventId=$eventId');
  }

  Future<WayaRequestResponse> editEvent(
      UpdateEventRequestModel payload, String id) {
    return patch("$serviceUrl/events/edit-event/$id", payload.toJson(),
        formdata: false);
  }

  Future<WayaRequestResponse> joinEvent(
      {required String userId, required String eventId}) {
    return post(
        "$serviceUrl/join-events", {"userId": userId, "eventId": eventId});
  }

  Future<WayaRequestResponse> reportEvent(
      {required String userId,
      required String eventId,
      required String reason,
      String? comment}) {
    final payload = {"eventId": eventId, "reason": reason};
    if (comment != null) payload['comment'] = comment;
    return post("$serviceUrl/reports/create", payload);
  }

  Future<WayaRequestResponse> joinedUsers(
      {required String id, int? page = 100, int? limit = 10}) {
    return get(
        "$serviceUrl/join-events/get?eventId=$id&page=$page&limit=$limit&status=completed");
  }

  Future<WayaRequestResponse> pendingApprovals(
      {required String id, int? page = 100, int? limit = 10}) {
    return get(
        "$serviceUrl/join-events/get?eventId=$id&page=$page&limit=$limit&status=completed&approved=false");
  }

  Future<WayaRequestResponse> updateApprovalStatus(
      {required String userId,
      required String eventId,
      required String status}) {
    final payload = {"userId": userId, "eventId": eventId, "action": status};
    return patch("$serviceUrl/join-events/update-member", payload);
  }

  Future<WayaRequestResponse> eventsJoined(
      {required String userId, int? page = 1, int? limit = 10}) {
    return get(
        "$serviceUrl/join-events/get?userId=$userId&page=$page&limit=$limit");
  }

  Future<WayaRequestResponse> getSingleEvent(String id) {
    return get("$serviceUrl/events/get-event?id=$id");
  }

  Future<WayaRequestResponse> updateEventSettings(
      {required bool letEveryoneJoin, required bool approveJoinRequest}) {
    return patch("$serviceUrl/events-settings/update", {
      "letEveryoneJoin": letEveryoneJoin,
      "approveJoinRequest": approveJoinRequest
    });
  }

  Future<WayaRequestResponse> getEventSettings() {
    return get("$serviceUrl/events-settings");
  }
}


@riverpod
EventRepository eventRepository(Ref ref) {
  return EventRepository(ref);
}
