import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';

class ShopDisputeRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> openTicket(
      {required String reasonCategory,
      required String details,
      required String userId,
      Order? orderedItem,
      required String disputeType,
      required String reference,
      String? sellerId,
      String? media}) async {
    final Map<dynamic, dynamic> payload = {
      "reasonCategory": reasonCategory,
      "details": details,
      "userId": userId,
      "disputeType": disputeType,
      "reference": reference,
    };

    final metadata = {};

    if (orderedItem != null) {
      metadata['orderedItem'] = orderedItem.toJson();
    }

    if (sellerId != null) payload['sellerId'] = sellerId;
    if (media != null) payload['media'] = media;
    if (metadata.isNotEmpty) payload['metadata'] = metadata;

    print(payload);

    return post("$serviceUrl/client/dispute", payload);
  }

  Future<WayaRequestResponse> getUserDisputes(
      { int? page = 1, int? limit = 10}) async {
    return get("$serviceUrl/client/dispute?limit=1000&page=$page");
  }

  //
  ///
  Future<WayaRequestResponse> getSingleDispute({required String id}) async {
    return get("$serviceUrl/client/dispute/$id");
  }

  Future<WayaRequestResponse> updateTicket(
      {required String reasonCategory,
      required String details,
      required String userId,
      Order? orderedItem,
      required String disputeType,
      required String reference,
      String? sellerId,
      required String disputeId,
      String? media}) async {
    final Map<dynamic, dynamic> payload = {
      "reasonCategory": reasonCategory,
      "details": details,
      "userId": userId,
      "disputeType": disputeType,
      "reference": reference,
    };

    final metadata = {};

    if (orderedItem != null) {
      metadata['orderedItem'] = orderedItem.toJson();
    }

    if (sellerId != null) payload['sellerId'] = sellerId;
    if (media != null) payload['media'] = media;
    if (metadata.isNotEmpty) payload['metadata'] = metadata;

    print(payload);

    return patch("$serviceUrl/client/dispute/$disputeId", payload);
  }

  Future<WayaRequestResponse> escalate(
      {required String id, required String escalatedBy}) async {
    return post("$serviceUrl/client/dispute/escalate-to-mediator/$id",
        {"escalatedBy": escalatedBy});
  }
}
