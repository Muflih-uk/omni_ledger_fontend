import 'package:dio/dio.dart';

abstract class BillingRemoteDataSource {
  Future<void> createBill(Map<String, dynamic> data);
}

class BillingRemoteDataSourceImpl implements BillingRemoteDataSource {
  final Dio dio;
  BillingRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createBill(Map<String, dynamic> data) async {
    await dio.post("/bills", data: data);
  }
}
