import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/vm/upgrade_to_business_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/promotion/data/models/create_promotion_state.dart';
import 'package:wayagram/features/promotion/vm/promotion_vm.dart';

class CreatePromotionVm extends StateNotifier<CreatePromotionState> {
  final Ref ref;
  CreatePromotionVm(this.ref) : super(CreatePromotionState());

  final List<Select> genderOptions = [
    Select(label: "All", value: "all"),
    Select(label: "Male", value: "male"),
    Select(label: "Female", value: "female")
  ];

  void selectGender(String type) {
    List<String> c = List.from(state.gender);
    if (c.contains(type)) {
      c.remove(type);
    } else {
      c.add(type);
    }
    state = state.copyWith(gender: c);
  }

  Future<void> selectState(Select value) async {
    String finalState = state.state;
    state = state.copyWith(state: value.label);
  }

  Future<void> fetchAndSetInitialState(
      {required String contentType, required String contentId}) async {
    final promoPlans = await ref.read(promoteVmProvider.notifier).getPlans();

    if (promoPlans != null) {
      
    }
    state = state.copyWith(contentId: contentId);
    state = state.copyWith(contentType: contentType);
    state = state.copyWith(userId: ConversationState.self.id);
  }

  Future<void> getAllStates() async {
    final response =
        await ref.read(upgradeToBusinessVmProvider.notifier).fetchStates();

    if (response != null) {
      state = state.copyWith(states: response);
    }
  }

  Future<void> payForPromotion({required BuildContext context}) async {
    try {
      if (context.mounted) {
        return WayaUtils.showNotice(
            context: context,
            title: "Your Promotion is Live!",
            buttonText: "View Promotion Analytics",
            onPress: () {
              // view analytics
            },
            message:
                "Your moment is now being promoted to your selected audience. Track its performance in the analytics section.",
            icon: Image.asset(WayaAssets.images.successPromote.path));
      }
    } catch (error) {
      print(error);
    }
  }
}

final promotionVmProvider =
    StateNotifierProvider<CreatePromotionVm, CreatePromotionState>((ref) {
  return CreatePromotionVm(ref);
});
