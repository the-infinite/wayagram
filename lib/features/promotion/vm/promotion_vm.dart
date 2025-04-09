import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/promotion/data/models/promotion_plan_response_model.dart';
import 'package:wayagram/features/promotion/data/models/promotion_state.dart';
import 'package:wayagram/features/promotion/data/repo/promotion_repository.dart';

class PromotionVm extends StateNotifier<PromotionState> {
  final Ref ref;
  final PromotionRepository _repository;

  PromotionVm(this.ref, this._repository) : super(PromotionState());

  Future<List<PromotionPlan>?> getPlans() async {
    try {
      final response = await _repository.getPromotionPlans();

      List<PromotionPlan> promoPlans = [];
      if (response.success) {
        PromotionPlansResponse plansResponse =
            PromotionPlansResponse.fromJson(response.data);
        promoPlans = plansResponse.data.plans;
        state = state.copyWith(plans: promoPlans);
      }
      return promoPlans;
    } catch (error) {
      print(error);
      return null;
    }
  }
}

final promoteVmProvider =
    StateNotifierProvider<PromotionVm, PromotionState>((ref) {
  return PromotionVm(ref, PromotionRepository());
});
