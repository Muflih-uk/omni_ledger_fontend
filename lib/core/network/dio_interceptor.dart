import 'package:dio/dio.dart';
import 'package:omni_ledger/core/storage/local_storage.dart';

class AppInterceptor extends Interceptor {
  final LocalStorage storage;

  AppInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
