import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/providers/dio_provider.dart';
import 'package:wayagram/core/service/api_service/waya_dio_client.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';

abstract class BaseRepositoryRiverpod {
  final Ref ref;

  BaseRepositoryRiverpod(this.ref);

  WayaDioClient get httpClient => ref.read(dioClientProvider);

  Future<WayaRequestResponse> get(
    String route, {
    Map<String, dynamic>? params,
    bool useBase = true,
  }) {
    return httpClient.getHttp(route, params: params, useBase: useBase);
  }

  Future<WayaRequestResponse> post(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
    void Function({int count, int total})? onSendProgress,
    void Function({int count, int total})? onRecieveProgress,
  }) {
    return httpClient.postHttp(
      route,
      body,
      params: params,
      formdata: formdata,
      formEncoded: formEncoded,
      onSendProgress: onSendProgress,
      onRecieveProgress: onRecieveProgress,
    );
  }

  Future<void> download(
      String url, String outputPath, WayaDownloadListener onData) {
    return httpClient.downloadHttp(url, outputPath, onData);
  }

  Future<WayaRequestResponse> put(
    String route,
    dynamic body, {
    String? contentType,
    Map<String, dynamic>? params,
    bool formdata = false,
    bool isAuth = true,
    bool isWgUrl = true,
    bool isBinary = false,
    bool formEncoded = false,
  }) {
    return httpClient.putHttp(
      route,
      body,
      contentType: contentType,
      params: params,
      formdata: formdata,
      isAuth: isAuth,
      isWgUrl: isWgUrl,
      formEncoded: formEncoded,
      isBinary: isBinary,
    );
  }

  Future<WayaRequestResponse> patch(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
  }) {
    return httpClient.patchHttp(
      route,
      body,
      params: params,
      formdata: formdata,
      formEncoded: formEncoded,
    );
  }

  Future<WayaRequestResponse> delete(
    String route, {
    dynamic body,
    Map<String, dynamic>? params,
  }) {
    return httpClient.deleteHttp(
      route,
      params: params,
      body: body,
    );
  }
}
