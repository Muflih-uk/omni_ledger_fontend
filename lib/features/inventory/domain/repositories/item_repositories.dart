import 'package:omni_ledger/features/inventory/domain/entities/item.dart';

abstract class ItemRepositories {
  Future<List<Item>> getItems();
}
