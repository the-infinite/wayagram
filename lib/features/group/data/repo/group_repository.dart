
import 'package:wayagram/core/service/repos/base_repository.dart';

import '../../../../core/service/api_service/request_model.dart';

class GroupRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> createGroup(String groupName,
      String groupDesc, bool groupType,
      String coverImage, String profileImage ) {
    final payload = {
      "name": groupName,
      "description": groupName,
      "isPrivate": groupType, //Optional field, if you leave it blank it defaults to false
      "isOpen": false, // this defaults to true if it is not inserted
      "coverImage":  coverImage,
      "profileImage":  profileImage
    };

    return post("$serviceUrl/groups", payload);
  }

  Future<WayaRequestResponse> getUploadImage(image) {
    return get("$serviceUrl/signed-url/$image");
  }

  Future<WayaRequestResponse> putImage(url, image) {
    return put(
      "$url",
      image,
      contentType: 'image/jpeg',
      isBinary: true,
      isWgUrl: false,
      isAuth: false,
    );
  }
}