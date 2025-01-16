import 'package:flutter/material.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';

class PersonalFirstStepState {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController referenceCode;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController phoneNumber;
  final TextEditingController address;
  final String city;
  final String state;
  final String country;
  final String lga;
  final TextEditingController businessName;
  final TextEditingController businessAddress;
  final String dateOfBirth;
  final String gender;
  final String businessTypeId;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isAgreeToTerm;
  final bool isButtonEnabled;
  final String dateIsoFormat;
  final bool isFocused;
  final bool isConfirmPasswordFocused;
  final bool isPasswordFocused;
  final bool isLoading;
  final User? user;
  final BusinessAccountData? business;
  final bool? isLoadingBusinessType;
  final List<Select> businessTypes;
  final List<Select> countries;
  final List<Select> lgas;
  final List<Select> states;
  final List<Select> cities;

  PersonalFirstStepState(
      {TextEditingController? firstName,
      TextEditingController? lastName,
      TextEditingController? email,
      TextEditingController? referenceCode,
      TextEditingController? password,
      TextEditingController? confirmPassword,
      TextEditingController? phoneNumber,
      TextEditingController? address,
      this.city = '',
      this.state = '',
      this.country = '',
      this.lga = '',
      TextEditingController? businessName,
      TextEditingController? businessAddress,
      this.dateOfBirth = '',
      this.gender = '',
      this.businessTypeId = '',
      this.isPasswordVisible = false,
      this.isConfirmPasswordVisible = false,
      this.isAgreeToTerm = false,
      this.isButtonEnabled = false,
      this.dateIsoFormat = '',
      this.isFocused = false,
      this.isConfirmPasswordFocused = false,
      this.isPasswordFocused = false,
      this.isLoading = false,
      this.isLoadingBusinessType = false,
      this.user,
      this.businessTypes = const [],
      this.countries = const [],
      this.states = const [],
      this.lgas = const [],
      this.cities = const [],
      this.business})
      : firstName = firstName ?? TextEditingController(),
        lastName = lastName ?? TextEditingController(),
        email = email ?? TextEditingController(),
        referenceCode = referenceCode ?? TextEditingController(),
        password = password ?? TextEditingController(),
        confirmPassword = confirmPassword ?? TextEditingController(),
        phoneNumber = phoneNumber ?? TextEditingController(),
        address = address ?? TextEditingController(),
     
        businessName = businessName ?? TextEditingController(),
        businessAddress = businessAddress ?? TextEditingController();

  PersonalFirstStepState copyWith(
      {TextEditingController? firstName,
      TextEditingController? lastName,
      TextEditingController? email,
      TextEditingController? referenceCode,
      TextEditingController? password,
      TextEditingController? confirmPassword,
      TextEditingController? phoneNumber,
      TextEditingController? address,
      String? city,
      String? state,
      String? country,
      String? lga,
      TextEditingController? businessName,
      TextEditingController? businessAddress,
      String? dateOfBirth,
      String? gender,
      String? businessTypeId,
      bool? isPasswordVisible,
      bool? isConfirmPasswordVisible,
      bool? isAgreeToTerm,
      bool? isButtonEnabled,
      String? dateIsoFormat,
      bool? isFocused,
      bool? isConfirmPasswordFocused,
      bool? isPasswordFocused,
      bool? isLoading,
      bool? isLoadingBusinessType,
      List<Select>? countries,
      List<Select>? states,
      List<Select>? lgas,
      List<Select>? businessTypes,
          List<Select>? cities,

      User? user,

      BusinessAccountData? business}) {
    return PersonalFirstStepState(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        referenceCode: referenceCode ?? this.referenceCode,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        city: city ?? this.city,
        state: state ?? this.state,
        lga: lga ?? this.lga,
        country: country ?? this.country,
        businessName: businessName ?? this.businessName,
        businessAddress: businessAddress ?? this.businessAddress,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        businessTypeId: businessTypeId ?? this.businessTypeId,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isConfirmPasswordVisible:
            isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
        isAgreeToTerm: isAgreeToTerm ?? this.isAgreeToTerm,
        isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
        dateIsoFormat: dateIsoFormat ?? this.dateIsoFormat,
        isFocused: isFocused ?? this.isFocused,
        isConfirmPasswordFocused:
            isConfirmPasswordFocused ?? this.isConfirmPasswordFocused,
        isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        businessTypes: businessTypes ?? this.businessTypes,
        countries: countries ?? this.countries,
        states: states ?? this.states,
        lgas: lgas ?? this.lgas,
        isLoadingBusinessType:
            isLoadingBusinessType ?? this.isLoadingBusinessType,
        business: business ?? this.business,
        cities: cities ?? this.cities
        );
  }
}
