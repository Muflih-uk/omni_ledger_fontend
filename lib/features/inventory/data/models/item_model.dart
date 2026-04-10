import 'package:omni_ledger/features/inventory/domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel({required super.id, required super.name, required super.unitPrice});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json["id"],
      name: json["name"],
      unitPrice: json["unit_price"].toDouble(),
    );
  }
}
