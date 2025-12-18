import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';

class BusinessRepository {
  final ApiService _apiService;

  BusinessRepository(this._apiService);

  Future<List<dynamic>> getBusinessProfiles() async {
    try {
      final result = await _apiService.getBusinessProfiles();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createBusinessProfile(
      Map<String, dynamic> data) async {
    try {
      final result = await _apiService.createBusinessProfile(data);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
