import 'package:omni_ledger/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository authRepository;
  RegisterUsecase(this.authRepository);

  Future<void> call(String name, String phone, String password) {
    return authRepository.register(name, phone, password);
  }
}