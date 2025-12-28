import 'package:equatable/equatable.dart';
import 'address.dart';

class Client extends Equatable {
  final String id;
  final String businessId;
  final String clientName;
  final String? email;
  final String? phone;
  final String? website;
  final Address? address;
  final String? taxNumber;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Client({
    required this.id,
    required this.businessId,
    required this.clientName,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.taxNumber,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    final companyName = json['company_name'] as String?;
    final firstName = json['first_name'] as String?;
    final lastName = json['last_name'] as String?;

    // Synthesize client name if not provided
    final synthesizedName =
        companyName ?? '${firstName ?? ''} ${lastName ?? ''}'.trim();

    return Client(
      id: json['id'] ?? '',
      businessId: json['business_id'] ?? '',
      clientName: json['client_name'] ?? synthesizedName,
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      taxNumber: json['tax_number'] ?? json['tax_id'],
      notes: json['notes'],
      status: json['status'] ?? 'ACTIVE',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'business_id': businessId,
    'client_name': clientName,
    'email': email,
    'phone': phone,
    'website': website,
    'address': address?.toJson(),
    'tax_number': taxNumber,
    'notes': notes,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    businessId,
    clientName,
    email,
    phone,
    website,
    address,
    taxNumber,
    notes,
    status,
    createdAt,
    updatedAt,
  ];
}
