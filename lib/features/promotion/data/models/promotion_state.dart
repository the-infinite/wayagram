import 'package:wayagram/features/promotion/data/models/promotion_plan_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

class PromotionState {
  final List<PromotionPlanDoc> plans;

  PromotionState({this.plans = const []});

  PromotionState copyWith({List<PromotionPlanDoc>? plans}) {
    return PromotionState(plans: plans ?? this.plans);
  }
}

