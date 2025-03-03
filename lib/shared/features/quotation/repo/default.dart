import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/quotation/data/model/quotation_model.dart';

class QuotationRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2/quotation";
  static final instance = QuotationRepository._();

  QuotationRepository._();

  Future<WayaRequestResponse> createBuyerRequest(CreateBuyerRequest payload) {
    return post("$serviceUrl/buyer/request", payload.toJson());
  }

  Future<WayaRequestResponse> getBuyerRequest([
    int limit = 10,
    int page = 1,
    String? status = "active",
    bool isUser = true,
  ]) {
    return get(
      "$serviceUrl/buyer/requests?isUser=$isUser&page=$page&limit=$limit${status != null ? "&status=$status" : ""}",
    );
  }

  Future<WayaRequestResponse> retrieveBuyRequest(String id) {
    return get("$serviceUrl/buyer/request/retrieve/$id");
  }

  Future<WayaRequestResponse> updateRequestAmount({
    required String id,
    String? amount,
  }) {
    final payload = {"id": id, "amount": amount};
    return patch('$serviceUrl/buyer/request/update-amount', payload);
  }

  Future<WayaRequestResponse> updateCancelRequest({
    required String id,
  }) {
    return patch('$serviceUrl/buyer/request/cancel', {
      "id": id,
    });
  }

  Future<WayaRequestResponse> extendBidTime({required String id, required String time}) {
    final payload = {"id": id, "time": time};
    return patch('$serviceUrl/buyer/request/extend-bid-end', payload);
  }

  Future<WayaRequestResponse> placeBid({
    required String requestId,
    required String vendorId,
    required String amount,
    required String shopId,
  }) {
    final payload = {
      "requestId": requestId, //request id
      "vendorId": vendorId, // user id of the vendor placing the bid
      "bidAmount": amount, // amount
      "shopId": shopId // shop id of the vendor
    };
    return post('$serviceUrl/vendor/bid', payload);
  }

  Future<WayaRequestResponse> getAllAvailableQuotation() {
    return get("$serviceUrl/vendor/quotations?limit=10&page=1");
  }

  Future<WayaRequestResponse> getVendorQuotation(String shopId, String category, String status) {
    return get("$serviceUrl/vendor/my-quotations?shopId=$shopId&limit=10&page=1&status=$status");
  }

  Future<WayaRequestResponse> getBidDashboard({required String shopId}) {
    return get("$serviceUrl/vendor/overview?shopId=$shopId");
  }

  Future<WayaRequestResponse> counterBidResponse({required String bidId, required String amount}) {
    final payload = {"bidId": bidId, "action": "countered", "counterAmount": amount, "lastCounterSentBy": "vendor"};
    return patch('$serviceUrl/vendor/bid-response', payload);
  }

  Future<WayaRequestResponse> acceptBidResponse({required String bidId}) {
    final payload = {
      "bidId": bidId,
      "action": "accepted",
      "lastCounterSentBy": "buyer" //
    };
    return patch('$serviceUrl/vendor/bid-response', payload);
  }

  Future<WayaRequestResponse> rejectBidResponse({required String bidId}) {
    final payload = {
      "bidId": bidId,
      "action": "rejected",
      "lastCounterSentBy": "buyer" //
    };
    return patch('$serviceUrl/vendor/bid-response', payload);
  }

  Future<WayaRequestResponse> retrieveOrder({required String requestId}) {
    return get("$serviceUrl/order/order/$requestId");
  }

  Future<WayaRequestResponse> trackDelivery({required String requestId}) {
    return get("$serviceUrl/order/track-delivery/$requestId");
  }

  Future<WayaRequestResponse> updateOrderStatus({required String status, required String orderId}) {
    final payload = {"status": status};
    return patch('$serviceUrl/order/status/$orderId', payload);
  }

  Future<WayaRequestResponse> updatePickupStatus({required String status, required String orderId}) {
    final payload = {"status": status};
    return patch('$serviceUrl/order/pickup-status/$orderId', payload);
  }

  Future<WayaRequestResponse> updateDeliveryStatus({required String status, required String orderId}) {
    final payload = {"status": status};
    return patch('$serviceUrl/order/delivery-status/$orderId', payload);
  }

  Future<WayaRequestResponse> updatePaymentStatus({required String status, required String orderId}) {
    final payload = {"status": status};
    return patch('$serviceUrl/order/payment-status/$orderId', payload);
  }

  Future<WayaRequestResponse> completeOrder({required String status, required String orderId}) {
    final payload = {"token": status};
    return patch('$serviceUrl/order/complete/$orderId', payload);
  }
}
