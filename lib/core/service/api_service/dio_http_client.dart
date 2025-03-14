import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wayagram/core/controller/debug_console.dart';

import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/interface/waya_http_client_interface.dart';
import 'package:wayagram/core/service/api_service/dio_exceptions.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/utils/waya_constants.dart';

typedef WayaDownloadListener = void Function(double done, int totalSize);

class RequestRepeater {
  final Future<WayaRequestResponse> Function(RequestRepeater) repeat;

  RequestRepeater({required this.repeat});
}

class DioHttpClient implements WayaHttpClientInterface {
  late final Dio dio;
  final String baseURL = WayaConstants.baseUrl;

  final _logger = getLogger('DioHttpClient');

  final WayaSecureDataSource secureDataSource = WayaSecureDataSource();
  //removing the snackbar
  //final SnackbarService _snackBarService = SnackbarService();

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
  Future<WayaRequestResponse> getHttp(
    String route, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
    bool formdata = false,
    dynamic token,
    bool useBase = true,
  }) {
    final completer = Completer<WayaRequestResponse>();
    final repeater = RequestRepeater(
      repeat: (repeater) async {
        await _setHeader(
          formdata: formdata,
        );
        params?.removeWhere((key, value) => value == null);
        final fullRoute = '${useBase ? baseURL : ''}$route';
        _logger.i('fullRoute: $fullRoute');
        final result = await _makeRequest(
          dio.get(
            fullRoute,
            data: body,
            queryParameters: params,
          ),
          repeater,
        );

        //? After that, then complete with the result.
        completer.complete(result);
        return result;
      },
    );

    //? Now, trigger our repeater.
    repeater.repeat(repeater);

    //? Our result is the future of this completer.
    return completer.future;
  }

  @override
  Future<WayaRequestResponse> postHttp(String route, dynamic body,
      {Map<String, dynamic>? params,
      bool formdata = false,
      bool formEncoded = false,
      void Function({int count, int total})? onSendProgress,
      void Function({int count, int total})? onRecieveProgress}) {
    final completer = Completer<WayaRequestResponse>();
    final repeater = RequestRepeater(
      repeat: (repeater) async {
        //? Since it is form data.
        if (formdata) {
          body = FormData.fromMap(body as Map<String, dynamic>);
          _logger.d("FormData =: ${(body as FormData).fields}, ${body.files}");
        }

        //? This is fine.late
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

        //? This is fine.
        final result = await _makeRequest(
          dio.post(
            fullRoute,
            data: body,
            options: formdata
                ? Options(
                    headers: {
                      Headers.acceptHeader: "*/*",
                      Headers.contentTypeHeader: "multipart/form-data; boundary=${(body as FormData).boundary}"
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
          ),
          repeater,
        );

        //? Now, complete this with the awaited result.
        completer.complete(result);

        //? Return this one.
        return result;
      },
    );

    //? Now, what we try to do is that we call the repeater's repeat function by default.
    repeater.repeat(repeater);

    // Now, return the future.
    return completer.future;
  }

  Future<WayaRequestResponse> downloadHttp(String url, String outputPath, WayaDownloadListener onData) async {
    final completer = Completer<WayaRequestResponse>();
    final repeater = RequestRepeater(
      repeat: (repeater) async {
        await _setHeader(isAuth: false);
        final result = await _makeRequest(
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
          repeater,
          false,
        );

        //? After that, then complete with the result.
        completer.complete(result);

        //? Return a result.
        return result;
      },
    );

    //? Now, trigger our repeater.
    repeater.repeat(repeater);

    //? Our result is the future of this completer.
    return completer.future;
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
  }) {
    final completer = Completer<WayaRequestResponse>();
    final repeater = RequestRepeater(
      repeat: (repeater) async {
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

        final result = await _makeRequest(
          dio.put(
            fullRoute,
            data: body,
            queryParameters: params,
          ),
          repeater,
        );

        //? After that, then complete with the result.
        completer.complete(result);

        //? Return a result.
        return result;
      },
    );

    //? Now, trigger our repeater.
    repeater.repeat(repeater);

    //? Our result is the future of this completer.
    return completer.future;
  }

  @override
  Future<WayaRequestResponse> patchHttp(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
  }) async {
    final completer = Completer<WayaRequestResponse>();
    final repeater = RequestRepeater(
      repeat: (repeater) async {
        await _setHeader(
          formdata: formdata,
          formEncoded: formEncoded,
        );
        params?.removeWhere((key, value) => value == null);
        final fullRoute = '$baseURL$route';
        if (formdata) {
          body = FormData.fromMap(body as Map<String, dynamic>);
        }
        _logger.i('fullRoute: $fullRoute');
        final result = await _makeRequest(
          dio.patch(
            fullRoute,
            data: body,
            queryParameters: params,
          ),
          repeater,
        );

        //? After that, then complete with the result.
        completer.complete(result);
        return result;
      },
    );

    //? Now, trigger our repeater.
    repeater.repeat(repeater);

    //? Our result is the future of this completer.
    return completer.future;
  }

  @override
  Future<WayaRequestResponse> deleteHttp(
    String route, {
    Object? body,
    Map<String, dynamic>? params,
  }) async {
    final completer = Completer<WayaRequestResponse>();
    final repeater = RequestRepeater(
      repeat: (repeater) async {
        await _setHeader();
        params?.removeWhere((key, value) => value == null);
        final fullRoute = '$baseURL$route';
        final result = await _makeRequest(
          dio.delete(
            fullRoute,
            data: body,
            queryParameters: params,
          ),
          repeater,
        );

        //? After that, then complete with the result.
        completer.complete(result);
        return result;
      },
    );

    //? Now, trigger our repeater.
    repeater.repeat(repeater);

    //? Our result is the future of this completer.
    return completer.future;
  }

  Future<WayaRequestResponse> _makeRequest(Future<Response> future, RequestRepeater repeater,
      [bool showErrors = true, int depth = 3]) async {
    try {
      final response = await future;
      _logger.i('data: ${response.data}');
      return WayaRequestResponse(
        data: response.data,
        success: response.statusCode?.toString().startsWith('2') ?? false,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      _logger.e('URI: ${e.requestOptions.uri.toString()}');
      _logger.e('statusCode: ${e.response}');
      if (e.response != null) {
        var message = 'An unknown error occurred';

        if (e.response?.data['statusCode'] == 401 || e.response?.statusCode == 401) {
          //> use refresh token to generate a new auth token
          bool success = await refreshToken();

          //? Then try again.
          if (success && depth > 0) {
            return repeater.repeat(repeater);
          }

          //? Since it failed, probably redirect the user to the login screen.
          else {
            //> return error if not successful
            return WayaHttpException.handleDioError(e);
          }
        }

        try {
          message = e.response?.data['errors'] != null ? e.response?.data['errors'][0] : e.response?.data['message'];
          _logger.e('errors: ${e.response?.data['errors']}');
        } catch (_) {}
        _logger.e('message: $message, ${e.response?.data}');

        //? If this should show errors.
        if (showErrors) {}

        //? If this is in the staging environment.
        if (!WayaConstants.isProduction) {
          WayaDebugConsoleController.instance.addDebugEvent(
            WayaDebugEvent(
              type: WayaDebugEventType.http,
              module: WayaDebugEventModule.unknown,
              message: e.response?.data['errors'] != null
                  ? e.response?.data['errors'][0]
                  : e.response?.data['message'] ?? e.message ?? e.toString(),
              raw: e,
              stackTrace: e.stackTrace,
              timestamp: DateTime.now(),
            ),
          );
        }
      }

      //? Handle this error.
      return WayaHttpException.handleDioError(e);
    }
  }

  //> Function to refresh token
  Future<bool> refreshToken() async {
    final refreshToken = await secureDataSource.getRefreshToken();

    //> if there no refresh token --- return false
    if (refreshToken == null) return false;

    try {
      final response = await dio.post(
        "${baseURL}wayagram-profile/api/v2/client/auth/refresh-token",
        data: {"token": refreshToken},
      );

      //> access the token from the response
      final newToken = response.data['data']['token']['token'];
      final newRefreshToken = response.data['data']['token']['refreshToken'];
      _logger.i("New token acquired");

      //> persit the tokens
      await secureDataSource.saveToken(newToken);
      await secureDataSource.saveRefreshToken(newRefreshToken);
      return true;
    } catch (e) {
      _logger.e("Token refresh failed: $e");
      return false;
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
      if (isAuth) 'Authorization': 'Bearer ${await secureDataSource.getToken()}',
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
