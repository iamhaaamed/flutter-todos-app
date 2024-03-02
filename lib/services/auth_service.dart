import 'package:dio/dio.dart';
import 'package:flutter_todos_app/network/api/api_constants.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<bool> login(String username, String password) async {
    try {
      // Make API request to login endpoint
      Response response = await _dio.get(
        '${ApiConstants.baseUrlDebug}/login',
        queryParameters: {
          'username': username,
          'password': password,
        },
      );
      // Check if login was successful
      if (response.data.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error logging in: $error');
      return false;
    }
  }
}
