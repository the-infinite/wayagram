import 'package:wayagram/core/service/api_service/request_model.dart';

abstract class WayaHttpClientInterface {
  Future<WayaRequestResponse> getHttp(
    String route, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
    bool formdata = false,
  });

  Future<WayaRequestResponse> postHttp(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
    void Function({int count, int total})? onSendProgress,
    void Function({int count, int total})? onRecieveProgress,
  });

  Future<WayaRequestResponse> putHttp(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
  });

  Future<WayaRequestResponse> patchHttp(
    String route,
    dynamic body, {
    Map<String, dynamic>? params,
    bool formdata = false,
    bool formEncoded = false,
  });

  Future deleteHttp(
    String route, {
    Map<String, dynamic>? params,
  });
}
