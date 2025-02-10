import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';

class WayaFileRepository extends BaseRepository {
  static final instance = WayaFileRepository._();
  static const serviceUrl = "wayagram-graph/api/v2";

  // Private constructor.
  WayaFileRepository._();

  /// Internal repository function used to get the signed url for a file upload.
  /// Kind of a nice thing to have generally speaking.
  Future<WayaRequestResponse> _getSignedUrl(File file, [String? name]) {
    final filename = name ?? file.uri.pathSegments.last;
    return get("$serviceUrl/signed-url/$filename");
  }

  /// A helper function used when downloading a file over the network.
  Stream<(double, int)> downloadFile(String url, File output, void Function(bool) onComplete) {
    //? First, we are not downloading this at the moment.
    late final StreamController<(double, int)> controller;

    //? Now, start downloading this file to this path.
    void startDownload() async {
      //? First, do this so that the listeners obtain the zeroth feed.
      controller.add((0, 0));

      //? This is fine.
      httpClient.downloadHttp(
        url,
        output.path,
        (result, total) {
          controller.add((result, total));
        },
      ).then(
        (response) {
          onComplete(response.success);
          controller.close();
        },
      ).catchError(
        (e) {
          controller.close();
        },
      );
    }

    //? This is fine.
    controller = StreamController<(double, int)>(
      onCancel: () => onComplete(false),
      onListen: startDownload,
    );

    //? Start the download itself.
    return controller.stream;
  }

  /// A helper function used to upload a file to a given URL.
  Future<String?> uploadFile(File file, [String? name]) async {
    //? First, get the signed URL
    try {
      final response = await _getSignedUrl(file, name);
      final filename = file.uri.pathSegments.last;
      final extensionIndex = filename.lastIndexOf(".");
      final extension = extensionIndex > -1 ? filename.substring(extensionIndex + 1) : '';
      final fileType = WayaFileExtensions.getMimeType(extension);

      //? Then send this over.
      if (!response.success) {
        return null;
      }

      //? Final output path.
      final data = response.data['data'];
      final uploadUrl = data['url'].toString();
      final outputPath = data['publicUrl'].toString();

      //? Now, we can try.
      final result = await httpClient.putHttp(
        uploadUrl,
        file,
        contentType: fileType.mimeType,
        isAuth: false,
        isWgUrl: false,
        isBinary: true,
      );

      //? If this was fine.
      if (result.success) {
        return outputPath;
      }
    } catch (_) {}

    //? Then fail.
    debugPrint("SendMessageDTO/ Failed to upload file.");

    //? Return null.
    return null;
  }
}
