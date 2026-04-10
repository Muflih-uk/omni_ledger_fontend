import 'package:omni_ledger/features/inventory/domain/entities/item.dart';
import 'package:omni_ledger/features/inventory/domain/repositories/item_repositories.dart';

class ItemsUsecases {
  final ItemRepositories repository;
  ItemsUsecases(this.repository);

  Future<List<Item>> call() async {
    return await repository.getItems();
  }

  Future<void> create(String name, double unitPrice) async {
    return await repository.createItem(name, unitPrice);
  }
}
