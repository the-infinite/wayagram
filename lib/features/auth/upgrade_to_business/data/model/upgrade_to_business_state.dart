import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/upgrade_to_business/data/model/upgrade_to_business_model.dart';

class UpgradeToBusinessState {
  final TextEditingController contactEmail;
  final TextEditingController name;
  final TextEditingController contactPhone;
  final TextEditingController address;
  final String city;
  final String state;
  final String country;
  final String lga;
  final String businessTypeId;
  final List<Select> businessTypes;
  final List<Select> countries;
  final List<Select> lgas;
  final List<Select> states;
  final List<Select> cities;
  final String? roleId;
  final String? accountTypeId;
  final bool isLoading;

  UpgradeToBusinessState({
    TextEditingController? contactEmail,
    TextEditingController? name,
    TextEditingController? contactPhone,
    TextEditingController? address,
    this.city = '',
    this.state = '',
    this.country = '',
    this.lga = '',
    this.businessTypeId = '',
    this.accountTypeId = '',
    this.roleId = '',
    this.isLoading = false,
    this.businessTypes = const [],
    this.countries = const [],
    this.states = const [],
    this.lgas = const [],
    this.cities = const [],
  })  : address = address ?? TextEditingController(),
        contactEmail = contactEmail ?? TextEditingController(),
        name = name ?? TextEditingController(),
        contactPhone = contactPhone ?? TextEditingController();

  UpgradeToBusinessState copyWith({
    TextEditingController? name,
    TextEditingController? contactPhone,
    TextEditingController? contactEmail,
    String? businessTypeId,
    TextEditingController? address,
    String? city,
    String? state,
    String? country,
    String? lga,
    String? accountTypeId,
    String? roleId,
    List<Select>? countries,
    List<Select>? states,
    List<Select>? lgas,
    List<Select>? businessTypes,
    List<Select>? cities,
    bool? isLoading
  }) {
    return UpgradeToBusinessState(
        name: name ?? this.name,
        contactEmail: contactEmail ?? this.contactEmail,
        contactPhone: contactPhone ?? this.contactPhone,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        lga: lga ?? this.lga,
        country: country ?? this.country,
        businessTypeId: businessTypeId ?? this.businessTypeId,
        businessTypes: businessTypes ?? this.businessTypes,
        countries: countries ?? this.countries,
        states: states ?? this.states,
        lgas: lgas ?? this.lgas,
        cities: cities ?? this.cities,
        accountTypeId: accountTypeId ?? this.accountTypeId,
        isLoading: isLoading ?? this.isLoading,
        roleId: roleId ?? this.roleId);
  }

  UpgradeToBusinessModel get upgradeToBusinessModel {
    return UpgradeToBusinessModel(
        business: Business(
            contactEmail: contactEmail.text,
            contactPhone: contactPhone.text,
            lga: lga,
            country: country,
            city: city,
            address: address.text,
            name: name.text,
            businessTypeId: businessTypeId),
        roleId: roleId,
        accountTypeId: accountTypeId);
  }
}
