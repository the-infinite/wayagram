import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/dto/default.dart';

class UserRepository extends BaseRepository {
  static const serviceUrl = "wayagram-profile/api/v2";
  static final instance = UserRepository._();

  UserRepository._();

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

  Future<WayaRequestResponse> getAllUsers({int? limit = 500}) {
    return get("$serviceUrl//client/users?limit=$limit");
  }
}
