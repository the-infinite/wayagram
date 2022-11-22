import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../model/full_user_profile_entity.dart';
import '../model/profile_model_entity.dart';
import 'api_response.dart';
import 'my_pref.dart';


//swagger docs
//Auth swagger https://services.staging.wayagram.ng/auth-service/swagger-ui/index.html#
//Main (profile-group-page) https://services.staging.wayagram.ng/main-service/api-docs/
//graph https://services.staging.wayagram.ng/graph-service/api-docs/
//post https://services.staging.wayagram.ng/post-services/api-docs/
//Chat https://services.staging.wayagram.ng/chats-service/api-docs/
//File resource https://services.staging.wayagram.ng/file-resource-service/api-docs/
//calls https://services.staging.wayagram.ng/calls-service/api-docs/
//dispute https://services.staging.wayagram.ng/social-dispute/api-docs/
//notifications https://services.staging.wayagram.ng/social-notification/api-docs/
//KYC service https://services.staging.wayagram.ng/kyc-service/swagger-ui/index.html
//Account Service https://services.wayagram.ng/account-service/swagger-ui/index.html#/

class Api {
  static const String baseUrl = 'https://services.staging.wayagram.ng/';
  CancelToken token = CancelToken();

  final Dio _client = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Content-Type': 'application/json',
    },
    receiveTimeout: 100000,
  ));

  Future<ApiResponse> postData(String url, {bool hasHeader = false, bool sso = true, body}) async {
    token = CancelToken();
    try {
      var head = {
        'Authorization': MyPref.authToken.val,
        //'Authorization':"serial eyJhbGciOiJIUzUxMiJ9.eyJyb2xlIjpbeyJjcmVhdGVkQXQiOiIxNS0wMi0yMDIyIDA2OjI3OjEzIiwidXBkYXRlZEF0IjoiMTUtMDItMjAyMiAwNjoyNzoxMyIsImNyZWF0ZWRCeSI6Ik1HUiIsIm1vZGlmaWVkQnkiOiJNR1IiLCJpZCI6MTMsIm5hbWUiOiJST0xFX1VTRVIiLCJkZXNjcmlwdGlvbiI6IlVTRVIgUk9MRSIsImRlZmF1bHQiOnRydWV9XSwiaWQiOjEyMjEsInN1YiI6ImdyZWVuMTBAeW9wbWFpbC5jb20iLCJpYXQiOjE2Njg3NjQ2MTIsImV4cCI6MTcwMDMyMjIxMn0.ITr_SLT4Zqm6G9w0c-H9vphGIhxv8hnZFdYTk0uW91eFVqutAkAZjkfwiSOMA70qZVF2NKfjyMgST7OauUd2gQ"
      };
      var link = url;
      if(sso){
        if(url.contains("?")){
          link = '$url&sso_id=${MyPref.userId.val}';
        }else{
          link = '$url/?&sso_id=${MyPref.userId.val}';
        }
      }
      var request = await _client.request(
        link,
        data: body,
        cancelToken: token,
        options: Options(method: 'POST', headers: hasHeader ? head : null,
          contentType: "application/json"
        ),
      );

      return ApiResponse.response(request);
    } on DioError catch (e) {
      return e.toApiError(cancelToken: token);
    } on SocketException {
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: 'No Internet connection',
      );
    } on Exception catch (e) {
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> deleteData(String url, {bool hasHeader = false, bool sso = true, body}) async {
    token = CancelToken();
    var head = {
      'Authorization': MyPref.authToken.val,
      //'Authorization':"serial eyJhbGciOiJIUzUxMiJ9.eyJyb2xlIjpbeyJjcmVhdGVkQXQiOiIxNS0wMi0yMDIyIDA2OjI3OjEzIiwidXBkYXRlZEF0IjoiMTUtMDItMjAyMiAwNjoyNzoxMyIsImNyZWF0ZWRCeSI6Ik1HUiIsIm1vZGlmaWVkQnkiOiJNR1IiLCJpZCI6MTMsIm5hbWUiOiJST0xFX1VTRVIiLCJkZXNjcmlwdGlvbiI6IlVTRVIgUk9MRSIsImRlZmF1bHQiOnRydWV9XSwiaWQiOjEyMjEsInN1YiI6ImdyZWVuMTBAeW9wbWFpbC5jb20iLCJpYXQiOjE2Njg3NjQ2MTIsImV4cCI6MTcwMDMyMjIxMn0.ITr_SLT4Zqm6G9w0c-H9vphGIhxv8hnZFdYTk0uW91eFVqutAkAZjkfwiSOMA70qZVF2NKfjyMgST7OauUd2gQ"
    };
    var link = url;
    if(sso){
      if(url.contains("?")){
        link = '$url&sso_id=${MyPref.userId.val}';
      }else{
        link = '$url/?&sso_id=${MyPref.userId.val}';
      }
    }
    try {
      var request = await _client.request(
        link,
        data: body,
        cancelToken: token,
        options: Options(method: 'DELETE', headers: hasHeader ? head : null,contentType: "application/json"),
      );
      return ApiResponse.response(request);
    } on DioError catch (e) {
      return e.toApiError(cancelToken: token);
    } on SocketException {
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: 'No Internet connection',
      );
    } on Exception catch (e) {
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> putData(String url, {bool hasHeader = false,bool sso = true, body,}) async {
    token = CancelToken();
    var head = {
      'Authorization': MyPref.authToken.val,
      //'Authorization':"serial eyJhbGciOiJIUzUxMiJ9.eyJyb2xlIjpbeyJjcmVhdGVkQXQiOiIxNS0wMi0yMDIyIDA2OjI3OjEzIiwidXBkYXRlZEF0IjoiMTUtMDItMjAyMiAwNjoyNzoxMyIsImNyZWF0ZWRCeSI6Ik1HUiIsIm1vZGlmaWVkQnkiOiJNR1IiLCJpZCI6MTMsIm5hbWUiOiJST0xFX1VTRVIiLCJkZXNjcmlwdGlvbiI6IlVTRVIgUk9MRSIsImRlZmF1bHQiOnRydWV9XSwiaWQiOjEyMjEsInN1YiI6ImdyZWVuMTBAeW9wbWFpbC5jb20iLCJpYXQiOjE2Njg3NjQ2MTIsImV4cCI6MTcwMDMyMjIxMn0.ITr_SLT4Zqm6G9w0c-H9vphGIhxv8hnZFdYTk0uW91eFVqutAkAZjkfwiSOMA70qZVF2NKfjyMgST7OauUd2gQ"
    };
    var link = url;
    if(sso){
      if(url.contains("?")){
        link = '$url&sso_id=${MyPref.userId.val}';
      }else{
        link = '$url/?&sso_id=${MyPref.userId.val}';
      }
    }
    try {
      var request = await _client.request(
        link,
        data: body,
        cancelToken: token,
        options: Options(method: 'PUT', headers: hasHeader ? head : null,contentType: "application/json"),
      );
      return ApiResponse.response(request);
    } on DioError catch (e) {
      return e.toApiError(cancelToken: token);
    } on SocketException {
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: 'No Internet connection',
      );
    } on Exception catch (e) {
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse> getData(String url, {bool hasHeader = false,bool sso = true}) async {
    token = CancelToken();
    try {
      var head = {
        'Authorization': MyPref.authToken.val,
        //'Authorization':"serial eyJhbGciOiJIUzUxMiJ9.eyJyb2xlIjpbeyJjcmVhdGVkQXQiOiIxNS0wMi0yMDIyIDA2OjI3OjEzIiwidXBkYXRlZEF0IjoiMTUtMDItMjAyMiAwNjoyNzoxMyIsImNyZWF0ZWRCeSI6Ik1HUiIsIm1vZGlmaWVkQnkiOiJNR1IiLCJpZCI6MTMsIm5hbWUiOiJST0xFX1VTRVIiLCJkZXNjcmlwdGlvbiI6IlVTRVIgUk9MRSIsImRlZmF1bHQiOnRydWV9XSwiaWQiOjEyMjEsInN1YiI6ImdyZWVuMTBAeW9wbWFpbC5jb20iLCJpYXQiOjE2Njg3NjQ2MTIsImV4cCI6MTcwMDMyMjIxMn0.ITr_SLT4Zqm6G9w0c-H9vphGIhxv8hnZFdYTk0uW91eFVqutAkAZjkfwiSOMA70qZVF2NKfjyMgST7OauUd2gQ"
      };
      var link = url;
      if(sso){
        if(url.contains("?")){
          link = '$url&sso_id=${MyPref.userId.val}';
        }else{
          link = '$url/?&sso_id=${MyPref.userId.val}';
        }
      }
      var request = await _client.request(
        link,
        cancelToken: token,
        options: Options(method: 'GET', headers: hasHeader ? head : null),
      );
      //var response = await http.get(Uri.parse(baseUrl+link), headers: hasHeader ? head : null);
      //return ApiResponse.responseFromBody(response.body, response.statusCode);
      return ApiResponse.response(request);
    } on DioError catch (e) {
      print(e.message);
      return e.toApiError(cancelToken: token);
    } on SocketException {
      print("Error 2");
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: 'No Internet connection',
      );
    } on Exception catch (e) {
      print("Error");
      print(e.toString());
      return ApiResponse(
        data: null,
        isSuccessful: false,
        message: e.toString(),
      );
    }
  }
}

abstract class AppRepo {
  final Api helper = Api();
}
