import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/interface/waya_http_client_interface.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/service/api_service/dio_exceptions.dart';
import 'package:wayagram/core/service/api_service/dio_interceptor.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/storage_service/fast_storage/waya_fast_storage_interface.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

typedef WayaDownloadListener = void Function(double done, int totalSize);

bool _signedOut = false;

class RequestRepeater {
  final Future<WayaRequestResponse> Function(RequestRepeater) repeat;
  int depth;

  RequestRepeater({required this.repeat, this.depth = 3});
}

class DioHttpClient implements WayaHttpClientInterface {
  late final Dio dio;
  final String baseURL = WayaConstants.baseUrl;
  final secureDataSource = WayaSecureDataSource();
  static final _instance = DioHttpClient._internal();

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
    );
    final dio = Dio(options);
    dio.interceptors.add(DioInterceptor(dio, secureDataSource, baseURL));
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
        final result = await _makeRequest(
          dio.get(
            fullRoute,
            data: body,
            queryParameters: params,
          ),
          repeater,
        );

        //? After that, then complete with the result.
        if (!completer.isCompleted) completer.complete(result);
        return result;
      },
    );

    //? Now, trigger our repeater.
    repeater.repeat(repeater);

    //? Our result is the future of this completer.
    return completer.future;
  }

  @override
  Future<WayaRequestResponse> postHttp(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
    void Function({int count, int total})? onSendProgress,
    void Function({int count, int total})? onRecieveProgress,
  }) {
    final completer = Completer<WayaRequestResponse>();
    final repeater = RequestRepeater(
      repeat: (repeater) async {
        if (formdata) {
          body = FormData.fromMap(body as Map<String, dynamic>);
        }
        await _setHeader(
          formdata: formdata,
          formEncoded: formEncoded,
          formDataBoundary: formdata ? (body as FormData).boundary : null,
        );

        //? Finished this.
        final fullRoute = '$baseURL$route';

        params?.removeWhere((key, value) => value == null);

        final result = await _makeRequest(
          dio.post(
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
          ),
          repeater,
        );

        //? Now, complete this with the awaited result.
        if (!completer.isCompleted) completer.complete(result);

        //? Return this one.
        return result;
      },
    );

    //? Now, what we try to do is that we call the repeater's repeat function by default.
    repeater.repeat(repeater);

    // Now, return the future.
    return completer.future;
  }

  Future<WayaRequestResponse> downloadHttp(
      String url, String outputPath, WayaDownloadListener onData) async {
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
              responseType: ResponseType.bytes,
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
        );

        //? After that, then complete with the result.
        if (!completer.isCompleted) completer.complete(result);

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
        if (!completer.isCompleted) completer.complete(result);

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
        final result = await _makeRequest(
          dio.patch(
            fullRoute,
            data: body,
            queryParameters: params,
          ),
          repeater,
        );

        //? After that, then complete with the result.
        if (!completer.isCompleted) completer.complete(result);
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
        if (!completer.isCompleted) completer.complete(result);
        return result;
      },
    );

    //? Now, trigger our repeater.
    repeater.repeat(repeater);

    //? Our result is the future of this completer.
    return completer.future;
  }

  Future<WayaRequestResponse> _makeRequest(
      Future<Response> future, RequestRepeater repeater) async {
    try {
      final response = await future;
      return WayaRequestResponse(
        data: response.data,
        success: response.statusCode?.toString().startsWith('2') ?? false,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401 ||
            (e.response?.data is Map &&
                e.response?.data['statusCode'] == 401)) {
          //> use refresh token to generate a new auth token
          bool success = await refreshToken();

          //? Then try again.
          if (success && repeater.depth > 0) {
            repeater.depth -= 1;
            return repeater.repeat(repeater);
          } else {
            final token = await secureDataSource.getToken();

            //? Always clear session data when something fails.
            if (token != null && !_signedOut) {
              await secureDataSource.deleteAll();
              await WayaFastStorageService().deleteAll();
              await ShopResource.reset();
              _signedOut = true;
              if (WayaNav.context.mounted) {
                await WayaUtils.showModalSheet(
                  WayaNav.context,
                  child: WayaErrorDialog(
                    title:
                        "Your session has expired. To continue, please log in to your account.",
                  ),
                );
              }
              await WayaNav.removeUntilNamed(LoginCoverPage.route);
              _signedOut = false;
            }
            return WayaHttpException.handleDioError(e);
          }
        }
      }
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

      //> persist the tokens
      await secureDataSource.saveToken(newToken);
      await secureDataSource.saveRefreshToken(newRefreshToken);
      return true;
    } catch (_) {
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
