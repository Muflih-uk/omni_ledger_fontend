import 'package:dio/dio.dart';
import 'package:omni_ledger/features/inventory/data/models/item_model.dart';

abstract class ItemRemoteDataSource {
  Future<List<ItemModel>> getItems();
  Future<void> createItem(String name, double unitPrice);
}

class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final Dio dio;

  ItemRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ItemModel>> getItems() async {
    final res = await dio.get("/items");
    final List data = res.data;
    return data.map((e) => ItemModel.fromJson(e)).toList();
  }

  @override
  Future<void> createItem(String name, double price) async {
    await dio.post('/items', data: {"name": name, "unit_price": price});
    return;
  }
}
