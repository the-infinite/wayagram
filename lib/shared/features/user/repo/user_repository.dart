import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/dto/default.dart';

part 'user_repository.g.dart';

class UserRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = WayaServiceUri.account;

  UserRepository(super.ref);

  Future<WayaRequestResponse> getSearchResults(String query,
      [int limit = 50, int page = 1]) {
    return get(
        "$serviceUrl/client/users/all/search?limit=$limit&page=$page&searchText=$query");
  }

  Future<WayaRequestResponse> updateFcmToken(String token) {
    return post(
        "$serviceUrl/client/users/${ConversationState.self.id}/add-fcm-token",
        {"fcmToken": token});
  }

  Future<WayaRequestResponse> getSocialProfile(String id) {
    return get("$serviceUrl/client/users/$id/profile");
  }

  Future<WayaRequestResponse> getUserDetails(String id) {
    return get("$serviceUrl/client/users/$id");
  }

  Future<WayaRequestResponse> updateUserProfile(UpdateProfileDto data) {
    return patch(
        "$serviceUrl/client/users/${ConversationState.self.id}/profile/update",
        data.toJson());
  }

  Future<WayaRequestResponse> getAllUsers({int? limit = 50000}) {
    return get("$serviceUrl/client/users?limit=$limit");
  }

  Future<WayaRequestResponse> getUserByEmail(String email) {
    return get("$serviceUrl/client/users/all/user-by-email?email=$email");
  }

  Future<WayaRequestResponse> getUserByUsername(String username) {
    return get("$serviceUrl/client/profiles/usernames/$username");
  }

  Future<WayaRequestResponse> getUserByPhone(String phone) {
    return get("$serviceUrl/client/users/all/user-by-phone?phoneNumber=$phone");
  }
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(ref);
}
