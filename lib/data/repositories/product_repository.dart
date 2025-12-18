import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<dynamic>> getProducts({String? businessId}) async {
    try {
      final result = await _apiService.getProducts(businessId: businessId);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    try {
      final result = await _apiService.createProduct(data);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
