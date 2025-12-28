import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';
import 'package:invoicegen_flutter_app/data/models/product.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<Product>> getProducts({String? businessId}) async {
    try {
      final List<dynamic> result = await _apiService.getProducts(
        businessId: businessId,
      );
      return result.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> createProduct(Map<String, dynamic> data) async {
    try {
      final result = await _apiService.createProduct(data);
      return Product.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }
}
