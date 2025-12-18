import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final result = await _apiService.getCurrentUser();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
