import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';
import 'package:invoicegen_flutter_app/data/models/client.dart';

class ClientRepository {
  final ApiService _apiService;

  ClientRepository(this._apiService);

  Future<List<Client>> getClients({String? businessId}) async {
    try {
      final List<dynamic> result = await _apiService.getClients(
        businessId: businessId,
      );
      return result.map((json) => Client.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Client> createClient(Map<String, dynamic> data) async {
    try {
      final result = await _apiService.createClient(data);
      return Client.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }
}
