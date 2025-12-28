import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final String id;
  final String businessId;
  final String clientId;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final String currency;
  final String status;
  final String? notes;
  final String? paymentTerms;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Invoice({
    required this.id,
    required this.businessId,
    required this.clientId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.currency,
    required this.status,
    this.notes,
    this.paymentTerms,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      businessId: json['business_id'] ?? '',
      clientId: json['client_id'] ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
      invoiceDate: DateTime.parse(
        json['invoice_date'] ?? DateTime.now().toIso8601String(),
      ),
      dueDate: DateTime.parse(
        json['due_date'] ?? DateTime.now().toIso8601String(),
      ),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'DRAFT',
      notes: json['notes'],
      paymentTerms: json['payment_terms'],
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
    'client_id': clientId,
    'invoice_number': invoiceNumber,
    'invoice_date': invoiceDate.toIso8601String(),
    'due_date': dueDate.toIso8601String(),
    'subtotal': subtotal,
    'tax_amount': taxAmount,
    'discount_amount': discountAmount,
    'total_amount': totalAmount,
    'currency': currency,
    'status': status,
    'notes': notes,
    'payment_terms': paymentTerms,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    businessId,
    clientId,
    invoiceNumber,
    invoiceDate,
    dueDate,
    subtotal,
    taxAmount,
    discountAmount,
    totalAmount,
    currency,
    status,
    notes,
    paymentTerms,
    createdAt,
    updatedAt,
  ];
}
