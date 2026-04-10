import 'package:omni_ledger/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:omni_ledger/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:omni_ledger/features/auth/domain/entities/user.dart';
import 'package:omni_ledger/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.remote, this.local);

  @override
  Future<User> login(String phone, String password) async {
    final user = await remote.login(phone, password);
    await local.saveToken(user.accessToken);

    return user;
  }

  @override
  bool isLoggedIn() {
    final token = local.getToken();
    return token != null;
  }
}
