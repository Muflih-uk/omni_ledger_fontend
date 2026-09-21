import 'package:omni_ledger/features/inventory/domain/entities/item.dart';

abstract class ItemRepositories {
  Future<List<Item>> getItems();
  Future<void> createItem(String name, double price);
  Future<void> updateItem(int id, String name, double price);
  Future<void> deleteItem(int id);
}