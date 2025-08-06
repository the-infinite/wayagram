import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';

part 'upload_file_repository.g.dart';

class UploadFileRepository extends BaseRepositoryRiverpod {
  static const serviceUrl = WayaServiceUri.graph;

  UploadFileRepository(super.ref);

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

@riverpod
UploadFileRepository uploadFileRepository(Ref ref) {
  return UploadFileRepository(ref);
}
