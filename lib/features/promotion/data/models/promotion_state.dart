import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';

class PromotionState {
  final TextEditingController? budget;
  final TextEditingController minAge;
  final TextEditingController maxAge;
  final String duration;
  final List<String> gender;
  final double rangeStart;
  final double rangeEnds;
  final String city;
  final String state;
  final List<Select> lgas;
  final List<Select> states;
  final List<Select> cities;
  final String lga;
  final bool isLoading;

  PromotionState(
      {TextEditingController? budget,
      TextEditingController? minAge,
      TextEditingController? maxAge,
      this.duration = '',
      this.gender = const [],
      this.city = '',
      this.state = '',
      this.states = const [],
      this.lgas = const [],
      this.cities = const [],
      this.lga = '',
      this.isLoading = false,
      this.rangeEnds = 18,
      this.rangeStart = 32})
      : budget = budget ?? TextEditingController(),
        minAge = minAge ?? TextEditingController(),
        maxAge = maxAge ?? TextEditingController();

  PromotionState copyWith(
      {TextEditingController? budget,
      String? duration,
      TextEditingController? minAge,
      TextEditingController? maxAge,
      String? city,
      String? state,
      bool? isLoading,
      String? lga,
      List<String>? gender,
      List<Select>? states,
      List<Select>? lgas,
      List<Select>? cities,
      double? rangeStart,
      double? rangeEnds}) {
    return PromotionState(
        budget: budget ?? this.budget,
        duration: duration ?? this.duration,
        rangeStart: rangeStart ?? this.rangeStart,
        rangeEnds: rangeEnds ?? this.rangeEnds,
        maxAge: maxAge ?? this.maxAge,
        city: city ?? this.city,
        state: state ?? this.state,
        lga: lga ?? this.lga,
        isLoading: isLoading ?? this.isLoading,
        states: states ?? this.states,
        lgas: lgas ?? this.lgas,
        cities: cities ?? this.cities,
        minAge: minAge ?? this.minAge,
        gender: gender ?? this.gender);
  }
}
