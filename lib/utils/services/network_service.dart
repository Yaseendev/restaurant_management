import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:restautant_client/models/user.dart';
import '../constants.dart';

class NetworkService {
  final Dio _dio;
  NetworkService(this._dio);

  void _addCors(Dio _dio){

    this._dio.options.headers.addAll({
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
      true, // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    });

  }

  Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    _addCors(_dio);
    try {
      Response response = await _dio.post('$kRootUrl/sanctum/token',
          data: {'email': email, 'password': password, 'device_name' : getDeviceType()
      });
      return {
        'user': User(
          email: email,
          authToken: response.data.toString(),
        ),//User.fromJson(response.data['result'], username),
        'error': null
      };
    } catch (e) {
      print(getErrorMessage(e));
      return {'user': null, 'error': getErrorMessage(e)};
    }
  }

  Future<Map<String, dynamic>?> signupUser(
      String email,String name,String zipcode ,String address,String city, String password) async {
    _addCors(_dio);
    try {
      Response response = await _dio.post('$kRootUrl/user/create',
          data: {'name': name,'email': email,'password': password,'address':address,'zipcode':zipcode,'city':city});
      return {
        'user': User(
          email: email,
          name:name,
          zipcode: zipcode,
          address: address,
          city: city,
          authToken: response.data.toString(),
        ),//User.fromJson(response.data['result'], username),
        'error': null
      };
    } catch (e) {
      print(getErrorMessage(e));
      return {'user': null, 'error': getErrorMessage(e)};
    }
  }


//FIXME: needs to be edited
  static String getErrorMessage(error) {
    if (error is Exception) {
      try {
        String networkException;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkException = 'ألغي طلب الإتصال بالمخدم';
              break;
            case DioErrorType.connectTimeout:
              networkException = 'لا يوجد إتصال بالإنترنت';
              // 'لا يمكن الإتصال بالمخدم في هذه الأثناء..حاول لاحقاً';
              break;
            case DioErrorType.other:
              networkException = 'لا يوجد إتصال بالإنترنت';
              break;
            case DioErrorType.receiveTimeout:
              networkException =
                  'Receive timeout in connection with API server';
              break;
            case DioErrorType.response:
              print(error.response!.data);
              switch (error.response!.statusCode) {
                case 400:
                  networkException = error.response!.data.toString();
                  //'إسم المسخدم أو كلمة المرور غير صحيحين';
                  break;
                case 401:
                  networkException = 'Unauthorised request';
                  break;
                case 403:
                  networkException = 'Unauthorised request';
                  break;
                case 404:
                  networkException = 'Not Found';
                  break;
                case 409:
                  networkException = 'Error due to a conflict';
                  break;
                case 408:
                  networkException = 'Connection request timeout';
                  break;
                case 500:
                  networkException = 'Internal Server Error';
                  break;
                case 503:
                  networkException = 'Service is unavailable at the moment';
                  break;
                default:
                  final responseCode = error.response!.statusCode;
                  networkException =
                      'Received invalid status code: $responseCode';
              }
              break;
            case DioErrorType.sendTimeout:
              networkException = 'Send timeout in connection with API server';
              break;
          }
        } else if (error is SocketException) {
          networkException = 'لا يوجد إتصال بالإنترنت';
        } else {
          networkException = 'Unexpected error occurred ${error.toString()}';
        }
        return networkException;
      } on FormatException {
        return 'Unexpected error occurred ${error.toString()}';
      } catch (_) {
        return 'Unexpected error occurred';
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return 'Unable to process the data';
      } else {
        return 'Unexpected error occurred ${error.toString()}';
      }
    }
  }

  String getDeviceType() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (kIsWeb) return 'web browser';
    return 'other';
  }

}
