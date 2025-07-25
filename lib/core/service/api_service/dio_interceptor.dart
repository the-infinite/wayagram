import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final WayaSecureDataSource secureDataSource;
  final String baseURL;
  DioInterceptor(this.dio, this.secureDataSource, this.baseURL);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains(WayaConstants.baseUrl)) {
      final token = await secureDataSource.getToken();
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Safely access response data
    dynamic responseData = err.response?.data;
    dynamic errData;
    int? statusCodeFromData;

    // Handle different response data types
    if (responseData is Map<String, dynamic>) {
      errData = responseData['data'];
      statusCodeFromData = responseData['statusCode'];
    } else {
      debugPrint(
          'DioInterceptor: Unexpected response data type: ${responseData.runtimeType}');
      errData = null;
      statusCodeFromData = null;
    }

    if (err.response?.statusCode == 401 ||
        statusCodeFromData == 401 ||
        (statusCodeFromData == 400 &&
            errData != null &&
            errData is String &&
            errData.contains("token"))) {
      final refreshToken = await secureDataSource.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await dio.post(
              '${WayaConstants.baseUrl}wayagram-profile/api/v2/client/auth/refresh-token',
              data: {"token": refreshToken});

          // Safely access nested response data
          dynamic tokenResponseData = response.data;
          if (tokenResponseData is! Map<String, dynamic>) {
            debugPrint('DioInterceptor: Invalid token response data type');
            return handler.next(err);
          }

          final tokenData = tokenResponseData['data'];
          if (tokenData is! Map<String, dynamic>) {
            debugPrint('DioInterceptor: Invalid token data structure');
            return handler.next(err);
          }

          final tokenInfo = tokenData['token'];
          if (tokenInfo is! Map<String, dynamic>) {
            debugPrint('DioInterceptor: Invalid token info structure');
            return handler.next(err);
          }

          final newtoken = tokenInfo['token']?.toString();
          final newrefreshToken = tokenInfo['refreshToken']?.toString();

          if (newtoken == null || newrefreshToken == null) {
            debugPrint('DioInterceptor: Missing token information in response');
            return handler.next(err);
          }

          secureDataSource.saveToken(newtoken);
          secureDataSource.saveRefreshToken(newrefreshToken);

          final retryRequest = err.requestOptions;
          retryRequest.headers['Authorization'] = 'Bearer $newtoken';
          final retryResponse = await dio.request(
            retryRequest.path,
            options: Options(
              method: retryRequest.method,
              headers: retryRequest.headers,
            ),
            data: retryRequest.data,
            queryParameters: retryRequest.queryParameters,
          );

          return handler.resolve(retryResponse);
        } catch (e) {
          debugPrint(" new token $e");
          return handler.next(err);
        }
      }
    } else {
      return handler.next(err);
    }
  }
}
