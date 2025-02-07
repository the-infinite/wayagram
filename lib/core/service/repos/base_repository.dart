import 'package:wayagram/core/service/api_service/dio_http_client.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/logger_service.dart';

abstract class BaseRepository {
  final _logger = getLogger('BaseRepository');
  final DioHttpClient httpClient;

  BaseRepository() : httpClient = DioHttpClient();

  Future<WayaRequestResponse> get(String route, {Map<String, dynamic>? params}) {
    print(' route ${route}');
    return httpClient.getHttp(route, params: params);
  }

  Future<WayaRequestResponse> post(String route, dynamic body,
      {Map<String, dynamic>? params,
      bool formdata = false,
      bool formEncoded = false,
      void Function({int count, int total})? onSendProgress,
      void Function({int count, int total})? onRecieveProgress}) {
    _logger.i('Registering user base $body');
    return httpClient.postHttp(route, body,
        params: params,
        formdata: formdata,
        formEncoded: formEncoded,
        onSendProgress: onSendProgress,
        onRecieveProgress: onRecieveProgress);
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
    return httpClient.patchHttp(route, body, params: params, formdata: formdata, formEncoded: formEncoded);
  }

  Future<WayaRequestResponse> delete(String route, {dynamic body, Map<String, dynamic>? params}) {
    return httpClient.deleteHttp(route, params: params, body: body) as Future<WayaRequestResponse>;
  }
}
