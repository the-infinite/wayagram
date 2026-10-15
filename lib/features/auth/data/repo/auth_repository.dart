import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/features/auth/upgrade_to_business/data/model/upgrade_to_business_model.dart';

part 'auth_repository.g.dart';

class AuthRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = WayaServiceUri.account;
  static const graphServiceUrl = WayaServiceUri.graph;

  AuthRepository(super.ref);

  Future<WayaRequestResponse> register(Register payload) {
    return post(
      '$serviceUrl/client/auth/register',
      payload.toJson(),
    );
  }

  Future<WayaRequestResponse> verifyOtp(VerifyOtp payload) {
    return post(
        '$serviceUrl/client/auth/register/verify-email', payload.toJson());
  }

  Future<WayaRequestResponse> verify(VerifyOtp payload) {
    final data = {...payload.toJson(), "purpose": "USER_RESET_PASSWORD"};
    return post('$serviceUrl/client/auth/verify-otp', data);
  }

  Future<WayaRequestResponse> verifySetPin(VerifyOtp payload) {
    final data = {...payload.toJson(), "purpose": "Transaction-Pin"};
    return post('$serviceUrl/client/auth/verify-otp', data);
  }

  Future<WayaRequestResponse> verifyChangePin(VerifyOtp payload) {
    final data = {...payload.toJson(), "purpose": "Change-Transaction-Pin"};
    return post('$serviceUrl/client/auth/verify-otp', data);
  }

  Future<WayaRequestResponse> verifyChangePassword(VerifyOtp payload) {
    final data = {...payload.toJson(), "purpose": "Reset-Password"};
    return post('$serviceUrl/client/auth/verify-otp', data);
  }

  Future<WayaRequestResponse> verifyPayout(String email, String otp) {
    final payload = {"email": email, "otp": otp, "purpose": "PAYOUT"};
    return post('$serviceUrl/client/auth/verify-otp', payload);
  }

  Future<WayaRequestResponse> resendOtp(
      {String purpose = 'REGISTER_USER', String? email, String? phone}) {
    final payload = {"purpose": purpose};

    if (email != null) payload['email'] = email;
    if (phone != null) payload['phoneNumber'] = phone;

    return post('$serviceUrl/client/auth/resend-otp', payload);
  }

  Future<WayaRequestResponse> oauth(String token, String authType) {
    return post('$serviceUrl/client/auth/login/oauth',
        {"oauthProvider": authType, "token": token});
  }

  Future<WayaRequestResponse> toggle2Fa(
      {required String code, String? purpose}) {
    final payload = {"code": code};

    if (purpose != null) payload['purpose'] = purpose;

    return post('$serviceUrl/client/auth/toggle-2fa', payload);
  }

  Future<WayaRequestResponse> validate2Fa(
      {required String email, required String code, String? purpose}) {
    final payload = {"email": email, "code": code};

    if (purpose != null) payload['purpose'] = purpose;

    return post('$serviceUrl/client/auth/validate-2fa', payload);
  }

  Future<WayaRequestResponse> phoneVerification(String code, String phone) {
    return post('$serviceUrl/client/auth/verify-phone',
        {"otp": code, "phoneNumber": phone, "purpose": 'REGISTER_USER'});
  }

  Future<WayaRequestResponse> verifyEmail(String email) {
    return post('$serviceUrl/client/auth/password/reset-password', {
      "email": email,
    });
  }

  Future<WayaRequestResponse> getOtp(
      {required String purpose, String? email, String? phone}) {
    final payload = {"purpose": purpose};

    if (email != null) payload['email'] = email;
    if (phone != null) payload['phoneNumber'] = phone;

    return post('$serviceUrl/client/auth/resend-otp', payload);
  }

  Future<WayaRequestResponse> verifyCAC(String cacNumber) {
    return post('$serviceUrl/client/kyc/verify-cac-number',
        {"cacNumber": cacNumber, "mode": "basic"});
  }

  Future<WayaRequestResponse> verifyBVN(String bvnNumber) {
    return post('$serviceUrl/client/kyc/verify-bvn',
        {"bvn": bvnNumber, "mode": "basic"});
  }

  Future<WayaRequestResponse> resetPassword(ForgotPassword payload) {
    return post(
        '$serviceUrl/client/auth/password/new-password', payload.toJson());
  }

  Future<WayaRequestResponse> login(
      {required String password,
      String? email,
      String? businessInfo,
      bool? isBusinessLogin}) {
    final payload = <String, dynamic>{};

    if (isBusinessLogin == true && businessInfo != null) {
      if (WayaValidators.isValidEmail(businessInfo) == null) {
        payload['email'] = businessInfo;
      } else {
        payload['businessId'] = businessInfo;
      }

      payload['password'] = password;
    } else {
      payload['email'] = email;
      payload['password'] = password;
    }
    return post('$serviceUrl/client/auth/login', payload);
  }

  Future<WayaRequestResponse> getAllCountries() {
    return get("$serviceUrl/client/location/countries?countryCode=NG");
  }

  Future<WayaRequestResponse> getAllStates() {
    return get("$serviceUrl/client/location/states?countryCode=NG");
  }

  Future<WayaRequestResponse> getAllLGA(
      {required String stateCode, required String countryCode}) {
    return get(
        "$serviceUrl/client/location/lgas?stateCode=$stateCode&countryCode=$countryCode");
  }

  Future<WayaRequestResponse> getAllCities(
      {required String stateCode, required String countryCode}) {
    return get(
        "$serviceUrl/client/location/cities?stateCode=$stateCode&countryCode=$countryCode");
  }

  Future<WayaRequestResponse> businessKyc(dynamic data) {
    return post('$serviceUrl/client/kyc/add-business-kyc', data,
        formdata: true);
  }

  Future<WayaRequestResponse> getAccountType() async {
    return get('$serviceUrl/client/account-types');
  }

  Future<WayaRequestResponse> getBusinessTypes() async {
    return get('$serviceUrl/client/businesses/types/all');
  }

  Future<WayaRequestResponse> upgradeToBusiness(
      {required UpgradeToBusinessModel payload, required String id}) {
    return post(
        '$serviceUrl/client/users/$id/upgrade-to-business', payload.toJson());
  }

  Future<WayaRequestResponse> selectInterest(dynamic data) {
    return patch('$graphServiceUrl/interests/toggle', {"interests": data});
  }

  Future<WayaRequestResponse> getSelectedInterests(
      {required String userId}) async {
    return get('$graphServiceUrl/interests/$userId');
  }

  Future<WayaRequestResponse> getInterestsCategories() async {
    return get("$graphServiceUrl/interests");
  }

  Future<WayaRequestResponse> refreshToken({required String token}) async {
    return post("$serviceUrl/client/auth/refresh-token", {"token": token});
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref);
}
