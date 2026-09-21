import 'package:omni_ledger/features/splash/domain/repositories/server_repository.dart';

import '../data_sources/server_remote_data_source.dart';

class ServerRepositoryImpl implements ServerRepository {
  final ServerRemoteDataSource remote;

  ServerRepositoryImpl(this.remote);

  @override
  Future<void> checkServer() {
    return remote.ping();
  }
}