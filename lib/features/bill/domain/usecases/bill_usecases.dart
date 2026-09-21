import 'package:omni_ledger/features/bill/domain/entities/bill.dart';
import 'package:omni_ledger/features/bill/domain/repositories/bill_repository.dart';

class BillUsecases {
  final BillRepository billRepository;

  BillUsecases(this.billRepository);

  Future<Bill> create(Map<String, dynamic> data) {
    return billRepository.createBill(data);
  }

  Future<List<Bill>> getBills() {
    return billRepository.getBills();
  }

  Future<void> togglePaymentStatus(int billId) {
    return billRepository.togglePaymentStatus(billId);
  }
}