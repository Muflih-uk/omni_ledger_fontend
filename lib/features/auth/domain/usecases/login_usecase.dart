import 'package:omni_ledger/features/auth/domain/entities/user.dart';
import 'package:omni_ledger/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository authRepository;
  LoginUsecase(this.authRepository);

  Future<User> call(String phone, String password) {
    return authRepository.login(phone, password);
  }
}
