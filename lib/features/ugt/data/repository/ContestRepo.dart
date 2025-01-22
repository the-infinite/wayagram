import 'dart:io';

import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/features/auth/data/model/auth_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/auth/upgrade_to_business/data/model/upgrade_to_business_model.dart';

import '../model/create_contest.dart';

class ContestRepo extends BaseRepository {
  static const serviceUrl = "wayagram-profile/api/v2";

  Future<WayaRequestResponse> register(Register payload) {
    return post('$serviceUrl/client/auth/register', payload.toJson());
  }

  Future<WayaRequestResponse> createContest(CreateContestModel payLoad){

    return post('$serviceUrl/contests/create',payLoad.toJson());
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
    } else {
      payload['email'] = email;
      payload['password'] = password;
    }

    return post('$serviceUrl/client/auth/login', payload);
  }













}
