import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String businessId;
  final String productName;
  final String? description;
  final String? category;
  final double price;
  final String? sku;
  final String? unit;
  final int? quantity;
  final double? taxRate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.businessId,
    required this.productName,
    this.description,
    this.category,
    required this.price,
    this.sku,
    this.unit,
    this.quantity,
    this.taxRate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      businessId: json['business_id'] ?? '',
      productName: json['product_name'] ?? 'Unnamed Product',
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      sku: json['sku'],
      unit: json['unit'],
      quantity: json['quantity'] != null
          ? (json['quantity'] as num).toInt()
          : null,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'ACTIVE',
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
    'product_name': productName,
    'description': description,
    'category': category,
    'price': price,
    'sku': sku,
    'unit': unit,
    'quantity': quantity,
    'tax_rate': taxRate,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    businessId,
    productName,
    description,
    category,
    price,
    sku,
    unit,
    quantity,
    taxRate,
    status,
    createdAt,
    updatedAt,
  ];
}
