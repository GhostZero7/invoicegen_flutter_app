import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';

class ClientRepository {
  final ApiService _apiService;

  ClientRepository(this._apiService);

  Future<List<dynamic>> getClients({String? businessId}) async {
    try {
      final result = await _apiService.getClients(businessId: businessId);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createClient(Map<String, dynamic> data) async {
    try {
      final result = await _apiService.createClient(data);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
