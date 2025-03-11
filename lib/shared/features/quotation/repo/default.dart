import 'package:wayagram/core/service/api_service/api_service.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/quotation/data/model/quotation_model.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

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
    required double amount,
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

  Future<WayaRequestResponse> getAllAvailableQuotation([
    int limit = 10,
    int page = 1,
  ]) {
    return get("$serviceUrl/vendor/quotations?limit=$limit&page=$page&shopId=${ShopResource.currentShop.id}");
  }

  Future<WayaRequestResponse> getVendorQuotation(
    String shopId, [
    int limit = 10,
    int page = 1,
    String? category,
    String? status,
  ]) {
    return get(
      "$serviceUrl/vendor/my-quotations?shopId=$shopId&limit=$limit&page=$page${status != null ? '&status=$status' : ''}${category != null ? '&category=$category' : ''}",
    );
  }

  Future<WayaRequestResponse> getBidDashboard({required String shopId}) {
    return get("$serviceUrl/vendor/overview?shopId=$shopId");
  }

  Future<WayaRequestResponse> sendBidAction(BidActionModel action) {
    return patch('$serviceUrl/vendor/bid-response', action.toJson());
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
