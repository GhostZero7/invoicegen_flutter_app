import 'package:invoicegen_flutter_app/data/models/user.dart';

abstract class AuthRepository {
  Future<User> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });

  Future<User> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<User> getCurrentUser();

  Future<bool> isLoggedIn();
}