import 'package:flutter/material.dart';

class PersonalFirstStepState {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController referenceCode;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController phoneNumber;
  final TextEditingController address;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController country;
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

  PersonalFirstStepState({
    TextEditingController? firstName,
    TextEditingController? lastName,
    TextEditingController? email,
    TextEditingController? referenceCode,
    TextEditingController? password,
    TextEditingController? confirmPassword,
    TextEditingController? phoneNumber,
    TextEditingController? address,
    TextEditingController? city,
    TextEditingController? state,
    TextEditingController? country,
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
  })  : firstName = firstName ?? TextEditingController(),
        lastName = lastName ?? TextEditingController(),
        email = email ?? TextEditingController(),
        referenceCode = referenceCode ?? TextEditingController(),
        password = password ?? TextEditingController(),
        confirmPassword = confirmPassword ?? TextEditingController(),
        phoneNumber = phoneNumber ?? TextEditingController(),
        address = address ?? TextEditingController(),
        city = city ?? TextEditingController(),
        state = state ?? TextEditingController(),
        country = country ?? TextEditingController(),
        businessName = businessName ?? TextEditingController(),
        businessAddress = businessAddress ?? TextEditingController();

  PersonalFirstStepState copyWith({
    TextEditingController? firstName,
    TextEditingController? lastName,
    TextEditingController? email,
    TextEditingController? referenceCode,
    TextEditingController? password,
    TextEditingController? confirmPassword,
    TextEditingController? phoneNumber,
    TextEditingController? address,
    TextEditingController? city,
    TextEditingController? state,
    TextEditingController? country,
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
  }) {
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
      country: country ?? this.country,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isAgreeToTerm: isAgreeToTerm ?? this.isAgreeToTerm,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      dateIsoFormat: dateIsoFormat ?? this.dateIsoFormat,
      isFocused: isFocused ?? this.isFocused,
      isConfirmPasswordFocused: isConfirmPasswordFocused ?? this.isConfirmPasswordFocused,
      isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}