import 'package:dio/dio.dart';
import 'package:omni_ledger/features/bill/data/models/bill_model.dart';

abstract class BillingRemoteDataSource {
  Future<void> createBill(Map<String, dynamic> data);
  Future<List<BillModel>> getBills(String status);
}

class BillingRemoteDataSourceImpl implements BillingRemoteDataSource {
  final Dio dio;
  BillingRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createBill(Map<String, dynamic> data) async {
    await dio.post("/bills", data: data);
  }

  @override
  Future<List<BillModel>> getBills(String status) async {
    final res = await dio.get(
      status == "paid" ? "/bills/paid" : "/bills/unpaid",
    );

    final List data = res.data;

    return data.map((e) => BillModel.fromJson(e)).toList();
  }
}
