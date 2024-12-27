import 'dart:developer' as logger;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wayagram/core/interface/waya_http_client_interface.dart';
import 'package:wayagram/core/service/api_service/dio_exceptions.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

class DioHttpClient implements WayaHttpClientInterface {
  late final Dio dio;
  final String baseURL = WayaConstants.baseUrl;

  DioHttpClient() {
    dio = initializeDio();
  }

  Dio initializeDio() {
    final options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );
    return Dio(options);
  }

  @override
  Future<WayaRequestResponse> getHttp(String route,
      {Map<String, dynamic>? body, Map<String, dynamic>? params, bool formdata = false, dynamic token}) async {
    _setHeader(
      formdata: formdata,
    );
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '$baseURL$route';
    return _makeRequest(dio.get(
      fullRoute,
      data: body,
      queryParameters: params,
    ));
  }

  @override
  Future<WayaRequestResponse> postHttp(String route, dynamic body,
      {Map<String, dynamic>? params,
      bool formdata = false,
      bool formEncoded = false,
      void Function({int count, int total})? onSendProgress,
      void Function({int count, int total})? onRecieveProgress}) async {
    _setHeader(
      formdata: formdata,
      formEncoded: formEncoded,
    );
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '$baseURL$route';
    if (formdata) {
      body = FormData.fromMap(body as Map<String, dynamic>);
    }

    return _makeRequest(dio.post(
      fullRoute,
      data: body,
      onSendProgress: (count, total) {
        if (onSendProgress != null) onSendProgress(count: count, total: total);
        _showLoadingProgress(count, total);
      },
      onReceiveProgress: ((count, total) {
        if (onRecieveProgress != null) onRecieveProgress(count: count, total: total);
        _showLoadingProgress(count, total);
      }),
      queryParameters: params,
    ));
  }

  @override
  Future<WayaRequestResponse> putHttp(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
  }) async {
    _setHeader(
      formdata: formdata,
      formEncoded: formEncoded,
    );
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '$baseURL$route';
    if (formdata) {
      body = FormData.fromMap(body as Map<String, dynamic>);
    }

    return _makeRequest(dio.put(
      fullRoute,
      data: body,
      queryParameters: params,
    ));
  }

  @override
  Future<WayaRequestResponse> patchHttp(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
  }) async {
    _setHeader(
      formdata: formdata,
      formEncoded: formEncoded,
    );
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '$baseURL$route';
    if (formdata) {
      body = FormData.fromMap(body as Map<String, dynamic>);
    }

    return _makeRequest(dio.patch(
      fullRoute,
      data: body,
      queryParameters: params,
    ));
  }

  @override
  Future deleteHttp(
    String route, {
    Map<String, dynamic>? params,
  }) async {
    _setHeader();
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '$baseURL$route';

    return _makeRequest(dio.delete(
      fullRoute,
      queryParameters: params,
    ));
  }

  Future<WayaRequestResponse> _makeRequest(Future<Response> future) async {
    try {
      final response = await future;
      logger.log('data: ${response.data}');
      return WayaRequestResponse(
        data: response.data,
        success: response.statusCode?.toString().startsWith('2') ?? false,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return WayaHttpException.handleDioError(e);
    }
  }

  void _setHeader({
    bool formdata = false,
    bool formEncoded = false,
  }) {
    dio.options.headers = {
      'content-type': formdata
          ? 'multipart/form-data'
          : formEncoded
              ? 'application/x-www-form-urlencoded'
              : 'application/json',
      'Accept': '*/*',
      'Authorization': 'token',
    };
  }

  Map<String, dynamic>? sanitizeParams(Map<String, dynamic>? params) {
    return params?..removeWhere((key, value) => value == null);
  }

  String buildFullRoute(String route) => '$baseURL$route';

  void dispose() => dio.close(force: true);

  void resetDio() => dio = initializeDio();

  void _showLoadingProgress(int received, int total) {
    if (total != -1 && kDebugMode) {
      debugPrint('${(received / total * 100).toStringAsFixed(0)}%');
    }
  }
}
