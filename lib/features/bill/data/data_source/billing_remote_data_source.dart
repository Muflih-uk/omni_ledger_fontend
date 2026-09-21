import 'package:dio/dio.dart';
import 'package:omni_ledger/core/exceptions/api_exception.dart';
import 'package:omni_ledger/features/bill/data/models/bill_model.dart';

abstract class BillingRemoteDataSource {
  Future<BillModel> createBill(Map<String, dynamic> data);
  Future<List<BillModel>> getBills();
  Future<void> togglePaymentStatus(int billId);
}

class BillingRemoteDataSourceImpl implements BillingRemoteDataSource {
  final Dio dio;
  BillingRemoteDataSourceImpl(this.dio);

  @override
  Future<BillModel> createBill(Map<String, dynamic> data) async {
    try {
      final res = await dio.post("/bills", data: data);
      return BillModel.fromJson(res.data);
    } on DioException catch (e) {
      final detail = e.response?.data;
      final message = (detail is Map && detail['detail'] != null)
          ? detail['detail'].toString()
          : "Failed to create bill";
      throw ApiException(message);
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }
@override
  Future<List<BillModel>> getBills() async {
    try {
      final res = await dio.get("/bills");

      final data = res.data;

      List<dynamic> items;
      if (data is List) {
        items = data;
      } else if (data is Map) {
        final raw = data['bills'] ?? data['data'];
        items = raw is List ? raw : <dynamic>[];
      } else {
        throw ApiException("Unexpected response from /bills");
      }

      return items
          .map((e) => BillModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final detail = e.response?.data;
      final message = (detail is Map && detail['detail'] != null)
          ? detail['detail'].toString()
          : "Failed to load bills";
      throw ApiException(message);
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }

  @override
  Future<void> togglePaymentStatus(int billId) async {
    try {
      await dio.patch("/bills/$billId/payment-status");
    } on DioException catch (e) {
      final detail = e.response?.data;
      final message = (detail is Map && detail['detail'] != null)
          ? detail['detail'].toString()
          : "Failed to update payment status";
      throw ApiException(message);
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }
}
