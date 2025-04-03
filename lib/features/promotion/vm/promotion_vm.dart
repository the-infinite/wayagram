import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/upgrade_to_business/vm/upgrade_to_business_vm.dart';
import 'package:wayagram/features/promotion/data/models/promotion_state.dart';

class PromotionVm extends StateNotifier<PromotionState> {
  final Ref ref;
  PromotionVm(this.ref) : super(PromotionState());

  final List<Select> genderOptions = [
    Select(label: "All", value: "All"),
    Select(label: "Male", value: "Male"),
    Select(label: "Female", value: "Female")
  ];

  final List<Select> durationOption = [
    Select(label: "Daily", value: "Daily"),
    Select(label: "Weekly", value: "Weekly"),
    Select(label: "Monthly", value: "Monthly")
  ];

  void setRangeStart(double value) {
    state = state.copyWith(rangeStart: value);
  }

  void setRangeEnd(double value) {
    state = state.copyWith(rangeEnds: value);
  }

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
    String _state = state.state;
    state = state.copyWith(state: value.label);

    if (_state.isNotEmpty && value.label != _state) {
      state.copyWith(cities: []);
      state = state.copyWith(city: '');
      state.copyWith(lgas: []);
      state = state.copyWith(lga: '');
    }
    await getAllLGA(stateCode: value.value, countryCode: 'NG');
    await getAllCiites(stateCode: value.value, countryCode: 'NG');
  }

  void selectLGA(Select value) {
    state = state.copyWith(lga: value.value);
  }

  Future<void> selectCity(Select value) async {
    state = state.copyWith(city: value.label);
  }

  Future<void> getAllStates() async {
    final response =
        await ref.read(upgradeToBusinessVmProvider.notifier).fetchStates();

    if (response != null) {
      state = state.copyWith(states: response);
    }
  }

  Future<void> getAllCiites(
      {required String stateCode, required String countryCode}) async {
    final response = await ref
        .read(upgradeToBusinessVmProvider.notifier)
        .fetchCities(stateCode, countryCode);

    if (response != null) {
      state = state.copyWith(cities: response);
    }
  }

  Future<void> getAllLGA(
      {required String stateCode, required String countryCode}) async {
    final response = await ref
        .read(upgradeToBusinessVmProvider.notifier)
        .fetchLGA(stateCode, countryCode);

    if (response != null) {
      state = state.copyWith(lgas: response);
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
    StateNotifierProvider<PromotionVm, PromotionState>((ref) {
  return PromotionVm(ref);
});
