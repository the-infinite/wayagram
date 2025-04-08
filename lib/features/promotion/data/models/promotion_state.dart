import 'package:wayagram/features/promotion/data/models/promotion_plan_response_model.dart';

class PromotionState {
  final List<PromotionPlan> plans;

  PromotionState({this.plans = const []});

  PromotionState copyWith({List<PromotionPlan>? plans}) {
    return PromotionState(plans: plans ?? this.plans);
  }
}
