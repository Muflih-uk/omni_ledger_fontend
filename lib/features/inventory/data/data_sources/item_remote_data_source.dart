import 'package:dio/dio.dart';
import 'package:omni_ledger/core/exceptions/api_exception.dart';
import 'package:omni_ledger/features/inventory/data/models/item_model.dart';

abstract class ItemRemoteDataSource {
  Future<List<ItemModel>> getItems();
  Future<void> createItem(String name, double unitPrice);
  Future<void> updateItem(int id, String name, double unitPrice);
  Future<void> deleteItem(int id);
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
    try {
      await dio.post('/items', data: {"name": name, "unit_price": price});
    } on DioException catch (e) {
      throw ApiException(_extractErrorMessage(e, "Failed to create item"));
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }

  @override
  Future<void> updateItem(int id, String name, double price) async {
    try {
      await dio.put(
        '/items/$id',
        data: {"name": name, "unit_price": price},
      );
    } on DioException catch (e) {
      throw ApiException(_extractErrorMessage(e, "Failed to update item"));
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }

  @override
  Future<void> deleteItem(int id) async {
    try {
      await dio.delete('/items/$id');
    } on DioException catch (e) {
      throw ApiException(_extractErrorMessage(e, "Failed to delete item"));
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }

  String _extractErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }
    return fallback;
  }
}