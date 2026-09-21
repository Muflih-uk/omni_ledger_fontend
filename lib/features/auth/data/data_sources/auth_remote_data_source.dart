import 'package:dio/dio.dart';
import 'package:omni_ledger/core/exceptions/api_exception.dart';
import 'package:omni_ledger/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String phone, String password);
  Future<void> register(String name, String phone, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String phone, String password) async {
    try {
      final res = await dio.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );

      return UserModel.fromJson(res.data);
    } on DioException catch (e) {
      throw ApiException(_extractErrorMessage(e, "Login failed"));
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }

  @override
  Future<void> register(String name, String phone, String password) async {
    try {
      await dio.post(
        '/auth/register',
        data: {'name': name, 'phone': phone, 'password': password},
      );
    } on DioException catch (e) {
      throw ApiException(_extractErrorMessage(e, "Registration failed"));
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }

  String _extractErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }
    return fallback;
  }
}