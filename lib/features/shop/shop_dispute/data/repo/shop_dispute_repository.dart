import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';

class ShopDisputeRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> openTicket(
      {required String reasonCategory,
      required String details,
      String? deliveryToken,
      required String userId,
      List<OrderItem>? orderedItem,
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

    if (deliveryToken != null) metadata['deliveryToken'] = deliveryToken;
    if (orderedItem != null) metadata['orderedItem'] = orderedItem.toString();

    if (sellerId != null) payload['sellerId'] = sellerId;
    if (media != null) payload['media'] = media;
    if (metadata.isNotEmpty) payload['metadata'] = metadata;

    print(payload);

    return post("$serviceUrl/client/dispute", payload);
  }
}
