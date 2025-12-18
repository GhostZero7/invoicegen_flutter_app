import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatarUrl;
  final bool emailVerified;
  final bool twoFactorEnabled;
  final String role;
  final String status;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.avatarUrl,
    required this.emailVerified,
    required this.twoFactorEnabled,
    required this.role,
    required this.status,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle both snake_case (REST) and CamelCase (GraphQL)
    String getString(String snake, String camel, [String defaultValue = '']) {
      return json[snake] ?? json[camel] ?? defaultValue;
    }

    DateTime? getDateTime(String snake, String camel) {
      final val = json[snake] ?? json[camel];
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    return User(
      id: getString('id', 'id', 'unknown_id'),
      email: getString('email', 'email', ''),
      firstName: getString('first_name', 'firstName', 'User'),
      lastName: getString('last_name', 'lastName', ''),
      phone: json['phone'] ?? json['phone'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      emailVerified: json['email_verified'] ?? json['emailVerified'] ?? false,
      twoFactorEnabled:
          json['two_factor_enabled'] ?? json['twoFactorEnabled'] ?? false,
      role: getString('role', 'role', 'USER'),
      status: getString('status', 'status', 'ACTIVE'),
      lastLoginAt: getDateTime('last_login_at', 'lastLoginAt'),
      createdAt: getDateTime('created_at', 'createdAt') ?? DateTime.now(),
      updatedAt: getDateTime('updated_at', 'updatedAt') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'email_verified': emailVerified,
      'two_factor_enabled': twoFactorEnabled,
      'role': role,
      'status': status,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    bool? emailVerified,
    bool? twoFactorEnabled,
    String? role,
    String? status,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      role: role ?? this.role,
      status: status ?? this.status,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    phone,
    avatarUrl,
    emailVerified,
    twoFactorEnabled,
    role,
    status,
    lastLoginAt,
    createdAt,
    updatedAt,
  ];
}
