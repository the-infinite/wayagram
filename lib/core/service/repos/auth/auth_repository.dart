import 'dart:io';

import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/auth/auth_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class AuthRepository extends BaseRepository {
  Future<WayaRequestResponse> register(Register payload) {
    return post(
        'wayagram-profile/api/v2/client/auth/register', payload.toJson());
  }

  Future<WayaRequestResponse> verifyOtp(VerifyOtp payload) {
    return post('wayagram-profile/api/v2/client/auth/register/verify-email',
        payload.toJson());
  }

  ///
  Future<WayaRequestResponse> resendOtp(String email) {
    return post(
        'wayagram-profile/api/v2/client/auth/resend-otp', {"email": email});
  }

  Future<WayaRequestResponse> verifyEmail(String email) {
    return post('wayagram-profile/api/v2/client/auth/password/reset-password',
        {"email": email});
  }

  Future<WayaRequestResponse> resetPassword(ForgotPassword payload) {
    return post('wayagram-profile/api/v2/client/auth/password/new-password',
        payload.toJson());
  }

  Future<WayaRequestResponse> login(String email, String password) {
    return post('wayagram-profile/api/v2/client/auth/login',
        {"email": email, "password": password});
  }

  //
  Future<WayaRequestResponse> businessKyc(dynamic data) {
    return post('wayagram-profile/api/v2/kyc/add-business-kyc',data, formdata: true);
  }

  Future<WayaRequestResponse> getAccountType() async {
    return get('wayagram-profile/api/v2/client/account-types');
  }

  Future<WayaRequestResponse> getBusinessTypes() async {
    return get('wayagram-profile/api/v2/client/businesses/types/all');
  }
}
