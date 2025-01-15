import 'dart:io';

import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class AuthRepository extends BaseRepository {
  static const serviceUrl = "wayagram-profile/api/v2";

  Future<WayaRequestResponse> register(Register payload) {
    return post('$serviceUrl/client/auth/register', payload.toJson());
  }

  Future<WayaRequestResponse> verifyOtp(VerifyOtp payload) {
    return post(
        '$serviceUrl/client/auth/register/verify-email', payload.toJson());
  }

  Future<WayaRequestResponse> resendOtp(String email) {
    return post('$serviceUrl/client/auth/resend-otp',
        {"email": email, "purpose": 'USER_PASSWORD_RESET'});
  }

  Future<WayaRequestResponse> verifyEmail(String email) {
    return post(
        '$serviceUrl/client/auth/password/reset-password', {"email": email});
  }

  Future<WayaRequestResponse> resetPassword(ForgotPassword payload) {
    return post(
        '$serviceUrl/client/auth/password/new-password', payload.toJson());
  }

  Future<WayaRequestResponse> login(
      {required String password,
      String? email,
      String? businessId,
      bool? isBusinessLogin}) {
    final payload = <String, dynamic>{};
    if (isBusinessLogin == true) {
      payload['businessId'] = businessId;
      payload['password'] = password;
    }
    else {
       payload['email'] = email;
      payload['password'] = password;
    }

    return post('$serviceUrl/client/auth/login', payload);
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
}
