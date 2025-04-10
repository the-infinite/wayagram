import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/promotion/data/models/create_promotion_model.dart';

class PromotionRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> getPromotionPlans({required String serviceType}) {
    return get(
        "$serviceUrl/client/promotions/plans?serviceType=$serviceType&limit=1000");
  }

  Future<WayaRequestResponse> createPromotion(CreatePromotionModel payload) {
    return post(
      "$serviceUrl/client/promotions",
      payload.toJson(),
    );
  }

  ///client/promotions
  Future<WayaRequestResponse> getPromotions() {
    return get("$serviceUrl/client/promotions?limit=10000");
  }

  ///client/promotions/id
  Future<WayaRequestResponse> getSinglePromotion({required String promoId}) {
    return get("$serviceUrl/client/promotions/$promoId");
  }
}
