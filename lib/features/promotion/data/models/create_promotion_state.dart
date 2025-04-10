import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/promotion/data/models/create_promotion_model.dart';

class CreatePromotionState {
  final int budget;
  final List<String> gender;
  final String state;
  final List<Select> states;
  final bool isLoading;
  final String userId;
  final String contentId;
  final String contentType;
  final String planId;
  final String plan;
  final List<Select> promotionPlans;
  final String startDate;
  final String endDate;
  final List<Select> ageRangeList;
  final String selectedAgeRanges;
  final TextEditingController name;
  final List<Select> interests;
  final String selectedInterest;
  final bool initialFetching;
  final Select? selectedPlan;
  final String startDateIso;
  final String endDateIso;

  CreatePromotionState(
      {TextEditingController? name,
      this.userId = '',
      this.contentId = '',
      this.contentType = '',
      this.planId = '',
      this.gender = const [],
      this.state = '',
      this.states = const [],
      this.isLoading = false,
      this.ageRangeList = const [],
      this.selectedAgeRanges = '',
      this.startDate = '',
      this.endDate = '',
      this.budget = 0,
      this.promotionPlans = const [],
      this.initialFetching = false,
      this.interests = const [],
      this.selectedPlan,
      this.plan = '',
      this.startDateIso = '',
      this.endDateIso = '',
      this.selectedInterest = ''})
      : name = name ?? TextEditingController();

  CreatePromotionState copyWith(
      {int? budget,
      List<String>? gender,
      String? state,
      List<Select>? states,
      Select? selectedPlan,
      bool? isLoading,
      String? userId,
      String? contentId,
      String? contentType,
      String? planId,
      String? startDate,
      String? endDate,
      String? startDateIso,
      String? endDateIso,
      List<Select>? ageRangeList,
      List<Select>? promotionPlans,
      String? selectedAgeRanges,
      TextEditingController? name,
      bool? initialFetching,
      List<Select>? interests,
      String? plan,
      String? selectedInterest}) {
    return CreatePromotionState(
        budget: budget ?? this.budget,
        gender: gender ?? this.gender,
        state: state ?? this.state,
        startDateIso: startDateIso ?? this.startDateIso,
        endDateIso: endDateIso ?? this.endDateIso,
        states: states ?? this.states,
        selectedPlan: selectedPlan ?? this.selectedPlan,
        isLoading: isLoading ?? this.isLoading,
        userId: userId ?? this.userId,
        contentId: contentId ?? this.contentId,
        contentType: contentType ?? this.contentType,
        planId: planId ?? this.planId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        ageRangeList: ageRangeList ?? this.ageRangeList,
        selectedAgeRanges: selectedAgeRanges ?? this.selectedAgeRanges,
        name: name ?? this.name,
        promotionPlans: promotionPlans ?? this.promotionPlans,
        interests: interests ?? this.interests,
        initialFetching: initialFetching ?? this.initialFetching,
        plan: plan ?? this.plan,
        selectedInterest: selectedInterest ?? this.selectedInterest);
  }

  PromotionTarget get promoTarget {
    return PromotionTarget(
        interests: [selectedInterest],
        locations: [state],
        ageRanges: [selectedAgeRanges],
        gender: gender.isNotEmpty ? gender.first : null);
  }

  CreatePromotionModel get createPromotionModel {
    return CreatePromotionModel(
        budget: budget,
        name: name.text,
        userId: userId,
        planId: planId,
        contentType: contentType,
        startDate: startDateIso,
        endDate: endDateIso,
        contentId: contentId,
        promotionTarget: promoTarget);
  }
}
