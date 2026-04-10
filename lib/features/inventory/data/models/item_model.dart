import 'package:omni_ledger/features/inventory/domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel({required super.id, required super.name, required super.unitPrice});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json["id"] as int,
      name: json["name"] as String,
      unitPrice: (json["unit_price"] as num).toDouble(),
    );
  }
}
