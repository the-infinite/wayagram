import 'dart:convert';

import 'package:dio/dio.dart';

enum ApiStatus {
  success,
  failure,
}

class ApiResponse {
  final int? code;
  dynamic data;
  dynamic suggestion;
  dynamic profiles;
  final bool isSuccessful;
  String? message;
  String? token;

  ApiResponse({this.code, this.message, this.data, required this.isSuccessful, this.token,this.suggestion,this.profiles});

  static ApiResponse response(Response response) {
    var json = response.data;

    return ApiResponse(
      message: json['message'],
      isSuccessful: json['status'],
      data: json['data'],
      suggestion: json['suggestion'],
      profiles: json['Profiles'],
    );
  }

  static ApiResponse responseFromBody(String json,int isSuccessful) {
    var jsonD = jsonDecode(json);
    return ApiResponse(
      message: jsonD['message'],
      isSuccessful: jsonD['status'],
      data: jsonD['data'],
      suggestion: jsonD['suggestion'],
      profiles: jsonD['Profiles'],
    );
  }

  factory ApiResponse.timeout(Response response) {
    return ApiResponse(
      data: null,
      isSuccessful: false,
      message: 'An error occurred. Please try again',
    );
  }
}

extension ApiError on DioError {
  ApiResponse toApiError({CancelToken? cancelToken}) {
    ApiResponse apiResponse = ApiResponse(isSuccessful: false);
    switch (type) {
      case DioErrorType.connectTimeout:
        if (cancelToken != null) {
          cancelToken.cancel();
        }
        return ApiResponse(
          isSuccessful: false,
          data: null,
          message: "Please check your internet connection or try again later",
        );

      case DioErrorType.receiveTimeout:
        if (cancelToken != null) {
          cancelToken.cancel();
        }
        return ApiResponse(
          isSuccessful: false,
          data: null,
          message: "Please check your internet connection or try again later",
        );

      case DioErrorType.sendTimeout:
        if (cancelToken != null) {
          cancelToken.cancel();
        }
        return ApiResponse(
          isSuccessful: false,
          data: null,
          message: "Please check your internet connection or try again later",
        );

      case DioErrorType.other:
        return ApiResponse(
          isSuccessful: false,
          data: null,
          message: "Please help report this error to Deepend support",
        );

      case DioErrorType.response:
        if (response!.data is Map<String, dynamic>) {
          var val = response!.data;
          return ApiResponse(
            isSuccessful: false,
            message: val['message'] ?? val['error'].values.first[0],
          );
        } else {
          ApiResponse(
            isSuccessful: false,
            data: null,
            message: response!.data.toString(),
          );
        }
        if (response!.statusCode! >= 300 && response!.statusCode! <= 399) {
          apiResponse.message = error.toString();
        }

        if (response!.statusCode! >= 400 && response!.statusCode! <= 499) {
          apiResponse.message = error.toString();
        }
        if (response!.statusCode! >= 500 && response!.statusCode! <= 599) {
          apiResponse.message = error.toString();
        }
        break;
      default:
        apiResponse = response != null
            ? ApiResponse.response(response!)
            : ApiResponse(
                isSuccessful: false,
                data: null,
                message: error.toString(),
              );
        break;
    }
    return apiResponse;
  }
}
