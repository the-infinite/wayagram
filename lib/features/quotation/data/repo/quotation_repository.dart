import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class QuotationRepository extends BaseRepository {
  static const serviceUrl = "wayagram-shop/api/v2";

  // Future<WayaRequestResponse> createBuyerRequest(CreateBuyerRequest payload) {
  //   return post("$serviceUrl/buyer/request", payload.toJson());
  // }

  Future<WayaRequestResponse> getBuyerRequest(String startDate, String endDate) {
    return get("$serviceUrl/buyer/requests?isUser=true&page=1&limit=1&category=food&status=active&startDate=$startDate&endDate=$endDate");
  }

  Future<WayaRequestResponse> updateRequestAmount({required String id, String? amount,}) {
    final payload = {
      "id": id,
      "amount": amount
    };
    return patch('$serviceUrl/buyer/request/update-amount', payload);
  }

  Future<WayaRequestResponse> updateCancelRequest({required String id,}) {
    final payload = {
      "id": id,
    };
    return patch('$serviceUrl/buyer/request/cancel', payload);
  }

  Future<WayaRequestResponse> extendBidTime({required String id, required String time}) {
    final payload = {
      "id": id,
      "time": time
    };
    return patch('$serviceUrl/buyer/request/extend-bid-end', payload);
  }

  // Future<WayaRequestResponse> placeBid(CreateBuyerRequest payload) {
  //   return post("$serviceUrl/vendor/bid", payload.toJson());
  // }

  Future<WayaRequestResponse> getAllAvailableQuotation() {
    return get("$serviceUrl/vendor/quotations?limit=10&page=1&category=food&startDate=&endDate=&status=&shopId=");
  }

  Future<WayaRequestResponse> getVendorQuotation(String startDate, String endDate, String shopId) {
    return get("$serviceUrl/vendor/my-quotations?shopId=$shopId&limit=&page=&category=&startDate=&endDate=&status=");
  }

  Future<WayaRequestResponse> getBidDashboard(String shopId) {
    return get("$serviceUrl/vendor/overview?shopId=$shopId");
  }

  Future<WayaRequestResponse> counterBidResponse({required String bidId, required String amount}) {
    final payload = {
      "bidId": bidId,
      "action": "countered",
      "counterAmount": amount,
      "lastCounterSentBy": "vendor"
    };
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

  Future<WayaRequestResponse> retrieveOrder(String requestId) {
    return get("$serviceUrl/order/order/$requestId");
  }

  Future<WayaRequestResponse> trackDelivery(String requestId) {
    return get("$serviceUrl/order/track-delivery/$requestId");
  }


  Future<WayaRequestResponse> updateOrderStatus({required String status, required String orderId}) {
    final payload = {
    "status": status
    };
    return patch('$serviceUrl/order/status/$orderId', payload);
  }

  Future<WayaRequestResponse> updatePickupStatus({required String status, required String orderId}) {
    final payload = {
      "status": status
    };
    return patch('$serviceUrl/order/pickup-status/$orderId', payload);
  }

  Future<WayaRequestResponse> updateDeliveryStatus({required String status, required String orderId}) {
    final payload = {
      "status": status
    };
    return patch('$serviceUrl/order/delivery-status/$orderId', payload);
  }

  Future<WayaRequestResponse> updatePaymentStatus({required String status, required String orderId}) {
    final payload = {
      "status": status
    };
    return patch('$serviceUrl/order/payment-status/$orderId', payload);
  }

  Future<WayaRequestResponse> completeOrder({required String status, required String orderId}) {
    final payload = {
      "token": status
    };
    return patch('$serviceUrl/order/complete/$orderId', payload);
  }

}