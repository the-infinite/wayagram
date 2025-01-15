import 'package:wayagram/core/service/repos/base_repository.dart';

import '../../../../../core/service/api_service/api_service.dart';

class ChangePasswordRepo extends BaseRepository {
  String get serviceUrl => 'wayagram-profile/api/v2';

  Future<WayaRequestResponse> changePassword(
      {required String oldPassword, required String newPassword, required String confirmPassword}) {
    final payload = {'oldPassword': oldPassword, 'newPassword': newPassword, 'confirmPassword': confirmPassword};
    return post('$serviceUrl/client/auth/password/change-password', payload);
  }
}
