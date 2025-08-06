import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/config/environment.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/api_service/dio_interceptor.dart';
import 'package:wayagram/core/service/api_service/waya_dio_client.dart';

part 'dio_provider.g.dart';

@riverpod
WayaSecureDataSource secureDataSource(Ref ref) {
  return WayaSecureDataSource();
}

@riverpod
Dio dio(Ref ref) {
  final secureDataSource = ref.watch(secureDataSourceProvider);

  final options = BaseOptions(
    baseUrl: AppEnvironment.apiBaseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 30),
  );

  final dio = Dio(options);
  dio.interceptors
      .add(DioInterceptor(dio, secureDataSource, AppEnvironment.apiBaseUrl));
  return dio;
}

@riverpod
WayaDioClient dioClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  final secureDataSource = ref.watch(secureDataSourceProvider);

  return WayaDioClient(dio, secureDataSource);
}
