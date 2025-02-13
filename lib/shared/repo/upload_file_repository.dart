import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class UploadFileRepository extends BaseRepository {
  static const serviceUrl = "wayagram-graph/api/v2";

  Future<WayaRequestResponse> getUploadUrl({required String fileName}) {
    return get("$serviceUrl/signed-url/$fileName");
  }

  Future<WayaRequestResponse> putFile(
      {required String url,
      required dynamic file,
      required String contentType}) {
    return put(
      url,
      file,
      contentType: contentType,
      isBinary: true,
      isWgUrl: false,
      isAuth: false,
    );
  }
}
