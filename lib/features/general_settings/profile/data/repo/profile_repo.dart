import 'dart:typed_data';

import 'package:dio/dio.dart' as waya;
import 'package:http_parser/http_parser.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class ProfileRepo extends BaseRepository {
  String get serviceUrl => 'wayagram-profile/api/v2';

  Future<WayaRequestResponse> updateAccountRepo({
    required String userId,
    String? dob,
    String? address,
  }) {
    final payload = dob == null
        ? {
            'address': address,
          }
        : {
            'dateOfBirth': dob,
          };

    return patch('$serviceUrl/client/users/$userId/update', payload);
  }

  Future<WayaRequestResponse> updateProfileRepo(
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

  Future<WayaRequestResponse> getUserDataRepo({required String userId}) async {
    return get("$serviceUrl/client/users/$userId");
  }

  Future<WayaRequestResponse> getUserProfileRepo({required String userId}) async {
    return get("$serviceUrl/client/users/$userId/profile");
  }

  Future<WayaRequestResponse> updateProfileImageRepo(
      {required String userId, required Uint8List image, required String fileName}) async {
    waya.MultipartFile pictureImage = waya.MultipartFile.fromBytes(
      image,
      filename: fileName,
      contentType: MediaType('image', 'png'),
    );
    final payload = {'profilePicture': pictureImage};

    return patch('$serviceUrl/client/users/$userId/update-pfp', payload, formdata: true);
  }
}
