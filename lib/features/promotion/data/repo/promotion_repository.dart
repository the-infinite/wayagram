import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/promotion/data/models/create_promotion_model.dart';

class PromotionRepository extends BaseRepository {
  static const serviceUrl = "wayagram-products/api/v1";

  Future<WayaRequestResponse> getPromotionPlans() {
    return get(
        "$serviceUrl/client/promotions/plans");
  }

  Future<WayaRequestResponse> createPromotion(CreatePromotionModel payload) {
    return post(
      "$serviceUrl/client/promotions",
      {payload.toJson()},
    );
  }
}
