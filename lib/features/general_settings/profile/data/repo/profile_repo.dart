import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class ProfileRepo extends BaseRepository {
  String get serviceUrl => 'wayagram-profile/api/v2';

  Future<WayaRequestResponse> updateAccount({
    required String userId,
    String? dob,
    String? address,
  }) {
    final payload = dob == null
        ? {
            'address': address,
          }
        : {
            'dob': dob,
          };

    return patch('$serviceUrl/client/users/$userId/update', payload);
  }

  Future<WayaRequestResponse> updateProfile(
      {required String userId, String? username, String? displayName, String? bio, bool? isPublic}) {
    final payload = <String, dynamic>{};

    if (username != null) {
      payload['username'] = username;
    }
    if (displayName != null) {
      payload['displayName'] = displayName;
    }
    if (bio != null) {
      payload['bio'] = bio;
    }
    if (isPublic != null) {
      payload['isPublic'] = isPublic;
    }

    return patch('$serviceUrl/client/users/$userId/profile/update', payload);
  }
}
