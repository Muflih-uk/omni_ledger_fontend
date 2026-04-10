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
    try {
      final res = await dio.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );

      print("Response: ${res.data}");

      return UserModel.fromJson(res.data);
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data}");
      print("Status Code: ${e.response?.statusCode}");
      throw Exception("Login failed");
    } catch (e) {
      print("Unknown Error: $e");
      throw Exception("Something went wrong");
    }
  }
}
