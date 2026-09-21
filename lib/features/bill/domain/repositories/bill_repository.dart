import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

abstract class BillRepository {
  Future<Bill> createBill(Map<String, dynamic> data);

  Future<List<Bill>> getBills();

  Future<void> togglePaymentStatus(int billId);
}