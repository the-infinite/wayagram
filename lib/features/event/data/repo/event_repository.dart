import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/event/data/model/add_event_request_model.dart';

class EventRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> createEvent(AddEventRequestModel payload) {
    return post("$serviceUrl/events/create", payload.toJson(), formdata: true);
  }

  Future<WayaRequestResponse> getEvents() {
    return get("$serviceUrl/events/get-event");
  }

  Future<WayaRequestResponse> getUserEvents(
      {required String userId, required int page}) {
    return get("$serviceUrl/events/get-event?userId=$userId&page=$page");
  }

  Future<WayaRequestResponse> getEventWithStatus({required String status}) {
    return get("$serviceUrl/events/get-event?eventstatus=$status");
  }

  Future<WayaRequestResponse> editEvent(
      AddEventRequestModel payload, String id) {
    return post("$serviceUrl/events/edit-event/$id", payload.toJson(),
        formdata: true);
  }

  ///
}
