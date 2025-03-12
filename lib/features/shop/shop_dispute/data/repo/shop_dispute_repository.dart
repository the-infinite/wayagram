import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class ShopDisputeRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> openTicket(
      {required String reasonCategory,
      required String details,
      required String orderNumber,
      required String userId,
      required String disputeType,
      required String reference,
      String? sellerId,
      String? media}) async {
    final payload = {
      "reasonCategory": reasonCategory,
      "details": details,
      "orderNumber": orderNumber,
      "userId": userId,
      "disputeType": disputeType,
      "reference": reference
    };

    if (sellerId != null) payload['sellerId'] = sellerId;
    if (media != null) payload['media'] = media;

    return post("$serviceUrl/client/dispute/open", payload);
  }
}
