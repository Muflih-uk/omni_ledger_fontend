import 'package:dio/dio.dart';
import 'package:omni_ledger/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String phone, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String phone, String password) async {
    final res = await dio.post(
      '/auth/login',
      data: {'phone': phone, 'password': password},
    );

    return UserModel.fromJson(res.data);
  }
}
