import 'package:omni_ledger/core/storage/local_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage storage;

  AuthLocalDataSourceImpl(this.storage);

  @override
  Future<void> saveToken(String token) async {
    await storage.saveToken(token);
  }

  @override
  String? getToken() {
    return storage.getToken();
  }
}
