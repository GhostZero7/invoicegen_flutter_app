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

  Future<Map<String, dynamic>> updateBusinessProfile(
      String businessId, Map<String, dynamic> data) async {
    try {
      final result = await _apiService.updateBusinessProfile(businessId, data);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBusinessProfile(String businessId) async {
    try {
      await _apiService.deleteBusinessProfile(businessId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBusinessProfile(String businessId) async {
    try {
      final result = await _apiService.getBusinessProfile(businessId);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
