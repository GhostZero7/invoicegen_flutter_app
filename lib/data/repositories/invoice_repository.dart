import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';

class InvoiceRepository {
  final ApiService _apiService;

  InvoiceRepository(this._apiService);

  Future<List<dynamic>> getInvoices({
    String? businessId,
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final result = await _apiService.getInvoices(
        businessId: businessId,
        status: status,
        skip: skip,
        limit: limit,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> data) async {
    try {
      final result = await _apiService.createInvoice(data);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
