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
    return Client(
      id: json['id'],
      businessId: json['business_id'],
      clientName: json['client_name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      taxNumber: json['tax_number'],
      notes: json['notes'],
      status: json['status'] ?? 'ACTIVE',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
