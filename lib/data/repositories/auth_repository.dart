import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';
import 'package:invoicegen_flutter_app/data/models/user.dart';
import 'package:invoicegen_flutter_app/domain/repositories/auth_repository.dart'
    as domain;

class AuthRepositoryImpl implements domain.AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      await _apiService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      final userData = await _apiService.getCurrentUser();
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      await _apiService.login(email: email, password: password);
      final userData = await _apiService.getCurrentUser();
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> requestVerification(String email) async {
    try {
      await _apiService.requestVerification(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyEmail(String email, String otp) async {
    try {
      await _apiService.verifyEmail(email, otp);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final userData = await _apiService.getCurrentUser();
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      await _apiService.getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }
}
