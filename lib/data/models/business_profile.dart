import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  const Address({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'state': state,
    'country': country,
    'postal_code': postalCode,
  };

  @override
  List<Object?> get props => [street, city, state, country, postalCode];
}

class BusinessProfile extends Equatable {
  final String id;
  final String userId;
  final String businessName;
  final String businessType;
  final String registrationNumber;
  final String? taxNumber;
  final String? email;
  final String? phone;
  final String? website;
  final String? logoUrl;
  final Address? address;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BusinessProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessType,
    required this.registrationNumber,
    this.taxNumber,
    this.email,
    this.phone,
    this.website,
    this.logoUrl,
    this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'],
      userId: json['user_id'],
      businessName: json['business_name'],
      businessType: json['business_type'],
      registrationNumber: json['registration_number'],
      taxNumber: json['tax_number'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      logoUrl: json['logo_url'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      status: json['status'] ?? 'ACTIVE',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'business_name': businessName,
    'business_type': businessType,
    'registration_number': registrationNumber,
    'tax_number': taxNumber,
    'email': email,
    'phone': phone,
    'website': website,
    'logo_url': logoUrl,
    'address': address?.toJson(),
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    userId,
    businessName,
    businessType,
    registrationNumber,
    taxNumber,
    email,
    phone,
    website,
    logoUrl,
    address,
    status,
    createdAt,
    updatedAt,
  ];
}
