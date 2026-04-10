import 'dio_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;
  final AppInterceptor interceptor;

  DioClient(this.dio, this.interceptor) {
    dio.options = BaseOptions(
      baseUrl: "https://api.example.com",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
    dio.interceptors.add(interceptor);
  }
}
