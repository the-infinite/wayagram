import 'package:wayagram/features/promotion/data/models/promotion_plan_response_model.dart';
import 'package:wayagram/features/promotion/data/models/promotion_response_model.dart';

class PromotionState {
  final List<PromotionPlanDoc> plans;
  final bool loadingPromos;
  final List<Promotion> allPromotions;
  final Promotion? promotion;

  PromotionState(
      {this.plans = const [],
      this.loadingPromos = false,
      this.promotion,
      this.allPromotions = const []});

  PromotionState copyWith(
      {List<PromotionPlanDoc>? plans,
      bool? loadingPromos,
      Promotion? promotion,
      List<Promotion>? allPromotions}) {
    return PromotionState(
        loadingPromos: loadingPromos ?? this.loadingPromos,
        promotion: promotion ?? this.promotion,
        allPromotions: allPromotions ?? this.allPromotions,
        plans: plans ?? this.plans);
  }
}
