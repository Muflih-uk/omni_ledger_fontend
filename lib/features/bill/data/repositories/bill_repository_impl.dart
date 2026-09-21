import 'package:omni_ledger/features/bill/data/data_source/billing_remote_data_source.dart';
import 'package:omni_ledger/features/bill/data/models/bill_model.dart';
import 'package:omni_ledger/features/bill/domain/repositories/bill_repository.dart';

class BillRepositoryImpl extends BillRepository {
  final BillingRemoteDataSource remote;

  BillRepositoryImpl(this.remote);

  @override
  Future<BillModel> createBill(Map<String, dynamic> data) {
    return remote.createBill(data);
  }

  @override
  Future<List<BillModel>> getBills() {
    return remote.getBills();
  }

  @override
  Future<void> togglePaymentStatus(int billId) {
    return remote.togglePaymentStatus(billId);
  }
}