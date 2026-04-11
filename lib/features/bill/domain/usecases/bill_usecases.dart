import 'package:omni_ledger/features/bill/domain/repositories/bill_repository.dart';

class BillUsecases {
  final BillRepository billRepository;

  BillUsecases(this.billRepository);

  Future<void> call(Map<String, dynamic> data) {
    return billRepository.createBill(data);
  }

  Future<List> getBills(String status) {
    return billRepository.getBills(status);
  }
}
