import 'package:omni_ledger/features/splash/domain/repositories/server_repository.dart';

class CheckServerUsecase {
  final ServerRepository serverRepository;
  CheckServerUsecase(this.serverRepository);

  Future<void> call() {
    return serverRepository.checkServer();
  }
}