import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

abstract class BillRepository {
  Future<void> createBill(Map<String, dynamic> data);

  Future<List<Bill>> getBills(String status);
}
