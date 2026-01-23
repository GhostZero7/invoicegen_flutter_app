// lib/data/repositories/auth_repository_impl.dart
import 'package:invoicegen_flutter_app/domain/repositories/auth_repository.dart';
import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';
import 'package:invoicegen_flutter_app/data/models/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _apiService.login(email: email, password: password);

    // Use user data from login response if available
    if (response.containsKey('user') && response['user'] != null) {
      return User.fromJson(response['user']);
    }

    // Fallback: try to get user profile
    try {
      final userData = await _apiService.getCurrentUser();
      return User.fromJson(userData);
    } catch (e) {
      // If getCurrentUser fails, create user from token data
      print('⚠️ Could not get user profile, using basic data from response');
      return User.fromJson({
        'email': email,
        'first_name': 'User',
        'last_name': '',
      });
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    final response = await _apiService.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );

    // Use user data from registration response if available
    if (response.containsKey('user') && response['user'] != null) {
      return User.fromJson(response['user']);
    }

    // Fallback: try to get user profile
    try {
      final userData = await _apiService.getCurrentUser();
      return User.fromJson(userData);
    } catch (e) {
      // If getCurrentUser fails, create user from registration data
      print('⚠️ Could not get user profile, using registration data');
      return User.fromJson({
        'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  Future<void> logout() async {
    await _apiService.logout();
  }

  @override
  Future<User> getCurrentUser() async {
    final userData = await _apiService.getCurrentUser();
    return User.fromJson(userData);
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      await _apiService.getCurrentUser();
      return true;
    } catch (e) {
      print('Auth check failed: $e');
      return false;
    }
  }

  @override
  Future<void> requestVerification(String email) async {
    await _apiService.requestVerification(email);
  }

  @override
  Future<void> verifyEmail(String email, String otp) async {
    await _apiService.verifyEmail(email, otp);
  }
}
