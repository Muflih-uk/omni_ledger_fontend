import 'package:dio/dio.dart';

abstract class ServerRemoteDataSource {
  Future<void> ping();
}

class ServerRemoteDataSourceImpl implements ServerRemoteDataSource {
  final Dio dio;
  ServerRemoteDataSourceImpl(this.dio);

  @override
  Future<void> ping() async {
    await dio.get('/');
  }
}