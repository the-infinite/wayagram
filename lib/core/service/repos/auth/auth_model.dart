import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class Register {
  String? email;
  String? password;
  String? confirmPassword;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String? city;
  String? state;
  String? country;
  String? dateOfBirth;
  String? gender;
  String? accountTypeId;
  bool? tcAgreement;
  bool? policyAgreement;
  String? referenceCode;

  Register({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.dateOfBirth,
    this.gender,
    this.accountTypeId,
    this.tcAgreement,
    this.policyAgreement,
    this.confirmPassword,
  });

  factory Register.fromJson(Map<String, dynamic> json) =>
      _$RegisterFromJson(json);

  Map<String, dynamic> toJson() {
    final data = _$RegisterToJson(this);
    if (referenceCode == null || referenceCode!.isEmpty) {
      data.remove('referenceCode');
    }

    return data;
  }
}

@JsonSerializable()
class VerifyOtp {
  final String email;
  final String otp;

  VerifyOtp({required this.email, required this.otp});

  factory VerifyOtp.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpFromJson(json);

  Map<String, dynamic> toJson() {
    return _$VerifyOtpToJson(this);
  }
}

@JsonSerializable()
class ForgotPassword {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  ForgotPassword(
      {required this.confirmPassword,
      required this.newPassword,
      required this.email,
      required this.otp});

factory ForgotPassword.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordFromJson(json);

  Map<String, dynamic> toJson() {
    return _$ForgotPasswordToJson(this);
  }
}
