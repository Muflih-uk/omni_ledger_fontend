import 'package:omni_ledger/features/inventory/data/data_sources/item_remote_data_source.dart';
import 'package:omni_ledger/features/inventory/data/models/item_model.dart';
import 'package:omni_ledger/features/inventory/domain/repositories/item_repositories.dart';

class ItemRepositoryImpl implements ItemRepositories {
  final ItemRemoteDataSource remote;

  ItemRepositoryImpl(this.remote);

  @override
  Future<List<ItemModel>> getItems() async {
    return await remote.getItems();
  }
}
