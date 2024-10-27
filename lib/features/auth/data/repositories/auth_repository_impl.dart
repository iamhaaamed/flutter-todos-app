import 'package:dio/dio.dart';
import 'package:flutter_todos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_todos_app/common/constants/api_constants.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
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
