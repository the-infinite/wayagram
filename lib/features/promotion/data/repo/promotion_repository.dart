import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/features/promotion/data/models/create_promotion_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';

part 'promotion_repository.g.dart';

class PromotionRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = "wayagram-products/api/v1";

  PromotionRepository(super.ref);

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

  Future<WayaRequestResponse> getPromotions() {
    return get("$serviceUrl/client/promotions?limit=10000");
  }

  Future<WayaRequestResponse> getSinglePromotion({required String promoId}) {
    return get("$serviceUrl/client/promotions/$promoId");
  }
}

@riverpod
PromotionRepository promotionRepository(Ref ref) {
  return PromotionRepository(ref);
}
