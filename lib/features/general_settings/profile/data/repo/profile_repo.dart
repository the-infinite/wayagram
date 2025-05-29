import 'dart:typed_data';

import 'package:dio/dio.dart' as waya;
import 'package:http_parser/http_parser.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';

class ProfileRepo extends BaseRepository {
  String get serviceUrl => WayaServiceUri.account;
  String get serviceUrl2 => WayaServiceUri.product;

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

  Future<WayaRequestResponse> updateEmailOrPhone(
      {required String userId, required String purpose, required String otp, String? email, String? phone}) {
    final payload = {"purpose": purpose, "otp": otp};

    if (email != null) payload['newEmail'] = email;
    if (phone != null) payload['newPhoneNumber'] = phone;

    print(payload);

    return patch('$serviceUrl/client/users/$userId/email-or-phone/update', payload, showErrors: true);
  }

  Future<WayaRequestResponse> updateProfileRepo(
      {required String userId,
      String? username,
      String? displayName,
      String? bio,
      String? coverPhoto,
      bool? isPublic}) {
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
    if (coverPhoto != null) {
      payload['coverImage'] = coverPhoto;
    }

    return patch('$serviceUrl/client/users/$userId/profile/update', payload);
  }

  Future<WayaRequestResponse> getUserDataRepo({required String userId}) async {
    return get("$serviceUrl/client/users/$userId");
  }

  Future<WayaRequestResponse> postSupportDetails(payload) async {
    return post("$serviceUrl2/client/support", payload, formdata: false);
  }

  Future<WayaRequestResponse> removeCoverPhoto() async {
    return patch(
      "$serviceUrl/client/profiles/${ConversationState.self.id}/remove-imagaes",
      {
        "fields": ["coverImage"]
      },
      showErrors: true,
    );
  }

  Future<WayaRequestResponse> postDisputeDetails(payload) async {
    return post("$serviceUrl2/client/dispute", payload, formdata: false);
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

  Future<WayaRequestResponse> getBusinessDataRepo({required String userId}) async {
    return get("$serviceUrl/client/businesses/user-business/$userId");
  }
}
