import 'package:dio/dio.dart';

class DioClient {
  final String baseUrl;

  DioClient({required this.baseUrl});

  Dio get dio => _getDio();

  Dio _getDio() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
    );
    Dio dio = Dio(options);

    return dio;
  }
}
