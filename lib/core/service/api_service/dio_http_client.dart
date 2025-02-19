import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/interface/waya_http_client_interface.dart';
import 'package:wayagram/core/service/api_service/dio_exceptions.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/snackbar_service.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

typedef WayaDownloadListener = void Function(double done, int totalSize);

class DioHttpClient implements WayaHttpClientInterface {
  late final Dio dio;
  final String baseURL = WayaConstants.baseUrl;

  final _logger = getLogger('DioHttpClient');

  final WayaSecureDataSource secureDataSource = WayaSecureDataSource();
  final SnackbarService _snackBarService = SnackbarService();

  static final DioHttpClient _instance = DioHttpClient._internal();

  DioHttpClient._internal() {
    dio = initializeDio();
  }

  factory DioHttpClient() {
    return _instance;
  }

  Dio initializeDio() {
    final options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
    final dio = Dio(options);
    //  dio.interceptors.add(DioInterceptor(dio, secureDataSource, baseURL));
    //for proper logging of dio request and response
    /* dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90)); */
    return dio;
  }

  @override
  Future<WayaRequestResponse> getHttp(String route,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? params,
      bool formdata = false,
      dynamic token}) async {
    await _setHeader(
      formdata: formdata,
    );
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '$baseURL$route';
    _logger.i('fullRoute: $fullRoute');
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
    //? Since it is form data.
    if (formdata) {
      body = FormData.fromMap(body as Map<String, dynamic>);
      _logger.d("FormData =: ${(body as FormData).fields}, ${body.files}");
    }

    //? This is fine.
    await _setHeader(
      formdata: formdata,
      formEncoded: formEncoded,
      formDataBoundary: formdata ? (body as FormData).boundary : null,
    );

    //? Finished this.
    final fullRoute = '$baseURL$route';
    _logger.i('fullRoute: $fullRoute');
    _logger.f('headers: ${dio.options.headers}');

    params?.removeWhere((key, value) => value == null);

    return _makeRequest(dio.post(
      fullRoute,
      data: body,
      options: formdata
          ? Options(
              headers: {
                Headers.acceptHeader: "*/*",
                Headers.contentTypeHeader:
                    "multipart/form-data; boundary=${(body as FormData).boundary}"
              },
            )
          : null,
      onSendProgress: (count, total) {
        if (onSendProgress != null) {
          onSendProgress(count: count, total: total);
        }

        // _showLoadingProgress(count, total);
      },
      onReceiveProgress: ((count, total) {
        if (onRecieveProgress != null) {
          onRecieveProgress(count: count, total: total);
        }
        // _showLoadingProgress(count, total);
      }),
      queryParameters: params,
    ));
  }

  Future<WayaRequestResponse> downloadHttp(
      String url, String outputPath, WayaDownloadListener onData) async {
    await _setHeader(isAuth: false);

    // Make the download request.
    return _makeRequest(
      dio.download(
        url,
        outputPath,
        deleteOnError: true,
        options: Options(
          headers: {
            HttpHeaders.acceptEncodingHeader: '*',
          },
        ),
        onReceiveProgress: (count, total) {
          if (total != -1) {
            onData((count * 100) / total, total);
          }
        },
      ),
      false,
    );
  }

  @override
  Future<WayaRequestResponse> putHttp(
    String route,
    dynamic body, {
    String? contentType,
    Map<String, dynamic>? params,
    bool isWgUrl = false,
    bool formdata = false,
    bool isAuth = true,
    bool isBinary = false,
    bool formEncoded = false,
  }) async {
    int? length;

    //? If this is binary, turn the body to a stream.
    if (isBinary) {
      length = await (body as File).length();
      body = body.openRead();
    }

    //? Now, I need you to set the headers correctly. Please add the content length
    //? to headers.
    await _setHeader(
      formdata: formdata,
      contentLength: length,
      isAuth: isAuth,
      contentType: contentType,
      formEncoded: formEncoded,
    );

    //? This is fine.
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '${isWgUrl ? baseURL : ''}$route';
    _logger.i('fullRoute: $fullRoute $body');

    //? If this is formdata but not binary.
    if (!isBinary && formdata) {
      body = FormData.fromMap(body as Map<String, dynamic>);
    }

    //? Make the request.
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
    _logger.i('fullRoute: $fullRoute $body');
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
  Future<WayaRequestResponse> deleteHttp(
    String route, {
    Object? body,
    Map<String, dynamic>? params,
  }) async {
    await _setHeader();
    params?.removeWhere((key, value) => value == null);
    final fullRoute = '$baseURL$route';

    return _makeRequest(dio.delete(
      fullRoute,
      data: body,
      queryParameters: params,
    ));
  }

  Future<WayaRequestResponse> _makeRequest(Future<Response> future,
      [bool showErrors = true]) async {
    try {
      print("vv");
      final response = await future;
      _logger.i('data: ${response.data}');

      print('got here tto');

      print('got here tto${response.data}');
      return WayaRequestResponse(
        data: response.data,
        success: response.statusCode?.toString().startsWith('2') ?? false,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      print('got here');
      _logger.e('statusCode: ${e.response}');
      if (e.response != null) {
        var message = 'An unknown error occurred';

        try {
          message = e.response?.data['errors'] != null
              ? e.response?.data['errors'][0]
              : e.response?.data['message'];
          _logger.e('errors: ${e.response?.data['errors']}');
        } catch (_) {}
        _logger.e('message: $message, ${e.response?.data}');

        // This is fine
        if (showErrors) {
          _snackBarService.showCustomSnackbar(
            message: message,
            variant: SnackbarType.failure,
          );
        }
      }

      return WayaHttpException.handleDioError(e);
    }
  }

  Future<void> _setHeader({
    bool formdata = false,
    bool formEncoded = false,
    bool isAuth = true,
    int? contentLength,
    String? contentType,
    String? formDataBoundary,
  }) async {
    dio.options.headers = {
      if (contentLength != null) Headers.contentLengthHeader: '$contentLength',
      'content-type': contentType ??
          (formdata
              ? 'multipart/form-data${formDataBoundary != null ? '; boundary=$formDataBoundary' : null}'
              : formEncoded
                  ? 'application/x-www-form-urlencoded'
                  : 'application/json'),
      'accept': '*/*',
      'connection': 'keep-alive',
      if (isAuth)
        'Authorization': 'Bearer ${await secureDataSource.getToken()}',
    };
  }

  // token != null ? 'Authorization' : 'Bearer $token': '',
  Map<String, dynamic>? sanitizeParams(Map<String, dynamic>? params) {
    return params?..removeWhere((key, value) => value == null);
  }

  String buildFullRoute(String route) => '$baseURL$route';

  void dispose() => dio.close(force: true);

  void resetDio() => dio = initializeDio();
}
