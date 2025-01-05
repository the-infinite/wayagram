import 'package:dio/dio.dart';
import 'package:wayagram/core/data/secure_data_source.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final WayaSecureDataSource secureDataSource;
  final String baseURL;
  DioInterceptor(this.dio, this.secureDataSource, this.baseURL);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureDataSource.getToken();
    print('token: $token');
    options.headers['Authorization'] = 'Bearer $token';
    print('options: $options');
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final errData = err.response?.data['data'];

    if (err.response?.data['statusCode'] == 401 ||
        (err.response?.data['statusCode'] == 400 &&
            errData != null &&
            errData is String &&
            errData.contains("token"))) {
      final refreshToken = await secureDataSource.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await dio.post(
              'https://services.staging.wayagram.ng/wayagram-profile/api/v2/client/auth/refresh-token',
              data: {"token": refreshToken});

          final newtoken = response.data['data']['token']['token'];
          final newrefreshToken =
              response.data['data']['token']['refreshToken'];
          print(" new token $newtoken");
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
          print(" new token $e");
          return handler.next(err);
        }
      }
    } else {
      return handler.next(err);
    }
  }
}
