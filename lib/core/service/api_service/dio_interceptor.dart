import 'package:dio/dio.dart';
import 'package:wayagram/core/data/secure_data_source.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;
  final WayaSecureDataSource secureDataSource;

  DioInterceptor(this.dio, this.secureDataSource);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = secureDataSource.getToken();
    if (token != null) {
      options.headers['Authoriation'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.data['statusCode'] == 401) {
      final refreshToken = secureDataSource.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await dio.post(
              'wayagram-profile/api/v2/client/auth/refresh-token',
              data: {"token": refreshToken});
          final newtoken = response.data['data']['token']['token'];
          final newrefreshToken =
              response.data['data']['token']['refreshToken'];

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
          return handler.next(err);
        }
      }
    }
  }
}
