import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';

import '../../../../../core/service/api_service/api_service.dart';

part 'change_password_repo.g.dart';

class ChangePasswordRepo extends BaseRepositoryRiverpod {
  String get serviceUrl => 'wayagram-profile/api/v2';

  ChangePasswordRepo(super.ref);

  Future<WayaRequestResponse> changePassword(
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword}) {
    final payload = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword
    };
    return post('$serviceUrl/client/auth/password/change-password', payload);
  }
}

@riverpod
ChangePasswordRepo changePasswordRepository(Ref ref) {
  return ChangePasswordRepo(ref);
}
