import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class BillItemModel extends BillItem {
  BillItemModel({
    required super.id,
    required super.itemId,
    required super.itemName,
    required super.quantity,
    required super.price,
  });

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      id: json['id'],
      itemId: json['item_id'],
      itemName: json['item_name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class BillModel extends Bill {
  BillModel({
    required super.id,
    required super.customerName,
    required super.customerPhone,
    required super.totalAmount,
    required super.paymentStatus,
    required super.createdAt,
    required super.items,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List? ?? const [])
        .map((e) => BillItemModel.fromJson(e))
        .toList();

    return BillModel(
      id: json['id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']),
      items: items,
    );
  }

  @override
  BillModel copyWithStatus(String status) {
    return BillModel(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
      totalAmount: totalAmount,
      paymentStatus: status,
      createdAt: createdAt,
      items: items,
    );
  }
}