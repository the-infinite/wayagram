import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/features/auth/upgrade_to_business/vm/upgrade_to_business_vm.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/promotion/bottom_sheet/pay_for_promotion.dart';
import 'package:wayagram/features/promotion/data/models/create_promotion_state.dart';
import 'package:wayagram/features/promotion/data/repo/promotion_repository.dart';
import 'package:wayagram/features/promotion/vm/promotion_vm.dart';

class CreatePromotionVm extends StateNotifier<CreatePromotionState> {
  final Ref ref;
  final PromotionRepository _repository;
  CreatePromotionVm(this.ref, this._repository) : super(CreatePromotionState());

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

  void selectStartDate({required String date, required String iso}) {
    state = state.copyWith(startDate: date);
    state = state.copyWith(startDateIso: iso);
  }

  void selectEndDate({required String date, required String iso}) {
    state = state.copyWith(endDate: date);
    state = state.copyWith(endDateIso: iso);
  }

  void update(Select value, String name) {
    switch (name) {
      case "interest":
        state = state.copyWith(selectedInterest: value.value);
      case "ageRanges":
        state = state.copyWith(selectedAgeRanges: value.value);
      case "plan":
        state = state.copyWith(planId: value.value);
        state = state.copyWith(plan: value.label);
        state = state.copyWith(selectedPlan: value);

      default:
        null;
    }
  }

  Future<void> fetchAndSetInitialState(
      {required String contentType, required String contentId}) async {
    try {
      state = state.copyWith(initialFetching: true);
      //> 1
      final promoPlans = await ref
          .read(promoteVmProvider.notifier)
          .getPlans(serviceType: contentType);

      if (promoPlans != null) {
        final selPlans = promoPlans.map((c) {
          return Select(
              label: c.name,
              value: c.id,
              price: double.parse(c.basePrice).toInt());
        }).toList();

        state = state.copyWith(promotionPlans: selPlans);
      }
//> 2
      await getAllStates();

      state = state.copyWith(contentId: contentId);
      state = state.copyWith(contentType: contentType);
      state = state.copyWith(userId: ConversationState.self.id);

//> 3
      final allInterests =
          await ref.read(selectInterestProvider.notifier).getInterest();

      if (allInterests != null) {
        final selInterests = allInterests.keys
            .map((key) => Select(value: key, label: key))
            .toList();

        state = state.copyWith(interests: selInterests);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(initialFetching: false);
    }
  }

  Future<void> getAllStates() async {
    final response =
        await ref.read(upgradeToBusinessVmProvider.notifier).fetchStates();

    if (response != null) {
      state = state.copyWith(states: response);
    }
  }

  Future<void> onSubmit({required BuildContext context}) async {
    try {
      Select selectedPlan =
          state.promotionPlans.firstWhere((c) => c.value == state.planId);
      // set the budget price   planPrice x number of days

      // start date
      DateTime start = DateTime.parse(state.startDate);

      //end date
      DateTime end = DateTime.parse(state.endDate);

// number of days
      int numberOfDays = end.difference(start).inDays;

      if (numberOfDays < 1) {
        return WayaSnackBar.showToast(
            "Start date must be greater than end date");
      }

      int budget = numberOfDays * selectedPlan.price;
      print(budget);
      state = state.copyWith(budget: budget);
      state = state.copyWith(selectedAgeRanges: "18-25");

       print(state.createPromotionModel.toJson());

      // return;

      await WayaUtils.showModalSheet(context,
          child: PayForPromotion(title: state.contentType, budget: budget));
    } catch (error) {
      print(error);
    }
  }

  void reset() {
    state = CreatePromotionState();
  }

  Future<void> payForPromotion({required BuildContext context}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =
          await _repository.createPromotion(state.createPromotionModel);

      if (response.success) {
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
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final promotionVmProvider =
    StateNotifierProvider<CreatePromotionVm, CreatePromotionState>((ref) {
  return CreatePromotionVm(ref, PromotionRepository());
});
