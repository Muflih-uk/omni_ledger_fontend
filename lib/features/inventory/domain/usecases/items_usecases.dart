import 'package:omni_ledger/features/inventory/domain/repositories/item_repositories.dart';

class ItemsUsecases {
  final ItemRepositories repository;
  ItemsUsecases(this.repository);

  Future<List> call() async {
    return await repository.getItems();
  }
}
