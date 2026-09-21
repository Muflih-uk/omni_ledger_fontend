import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient({required Dio dio, required AppInterceptor interceptor})
    : dio = dio {
    dio.options = BaseOptions(
      baseUrl: "https://omni-ledger-backend.onrender.com/",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {"Content-Type": "application/json"},
    );

    dio.interceptors.addAll([
      interceptor,
      // LogInterceptor(
      //   request: true,
      //   requestBody: true,
      //   responseBody: true,
      //   error: true,
      // ),
    ]);
  }
}
