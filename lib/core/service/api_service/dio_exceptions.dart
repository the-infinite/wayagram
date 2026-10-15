import 'package:dio/dio.dart';
import 'package:wayagram/core/service/api_service/request_model.dart';

class WayaHttpException {
  static WayaRequestResponse handleDioError(DioException e) {
    String? message;
    try {
      message = e.response?.data['errors'] != null
          ? e.response?.data['errors'][0]
          : e.response?.data['message'];
    } catch (_) {}

    final errorMessage = {
          DioExceptionType.connectionTimeout: "Connection Timeout",
          DioExceptionType.receiveTimeout: "Connection Timeout",
          DioExceptionType.sendTimeout: "Connection Timeout",
          DioExceptionType.unknown:
              "An unknown error occurred. Please check your internet and try again.",
        }[e.type] ??
        e.response?.statusMessage ??
        "An error occurred.";
    return WayaRequestResponse(
      success: false,
      data: e.response?.data,
      responseCodeError: message ?? errorMessage,
      statusCode: e.response?.statusCode,
    );
  }
}
