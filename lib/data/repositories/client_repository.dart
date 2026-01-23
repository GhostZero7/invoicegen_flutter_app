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

  Future<Client> updateClient(String clientId, Map<String, dynamic> data) async {
    try {
      final result = await _apiService.updateClient(clientId, data);
      return Client.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteClient(String clientId) async {
    try {
      await _apiService.deleteClient(clientId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getInvoicesForClient(String clientId) async {
    try {
      return await _apiService.getInvoicesForClient(clientId);
    } catch (e) {
      rethrow;
    }
  }
}
