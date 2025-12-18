import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';

class PaymentRepository {
  final ApiService _apiService;

  PaymentRepository(this._apiService);

  Future<Map<String, dynamic>> recordPayment(Map<String, dynamic> data) async {
    try {
      final result = await _apiService.recordPayment(data);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getPayments({String? invoiceId}) async {
    try {
      final result = await _apiService.getPayments(invoiceId: invoiceId);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
