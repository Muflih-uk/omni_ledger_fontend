import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class BillModel extends Bill {
  BillModel({
    required super.id,
    required super.customerName,
    required super.customerPhone,
    required super.totalAmount,
    required super.paymentStatus,
    required super.createdAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
