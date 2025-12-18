import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String invoiceId;
  final String paymentMethod;
  final double amount;
  final String currency;
  final String status;
  final DateTime paymentDate;
  final String? referenceNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.invoiceId,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentDate,
    this.referenceNumber,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      invoiceId: json['invoice_id'],
      paymentMethod: json['payment_method'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'COMPLETED',
      paymentDate: DateTime.parse(json['payment_date']),
      referenceNumber: json['reference_number'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_id': invoiceId,
    'payment_method': paymentMethod,
    'amount': amount,
    'currency': currency,
    'status': status,
    'payment_date': paymentDate.toIso8601String(),
    'reference_number': referenceNumber,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    paymentMethod,
    amount,
    currency,
    status,
    paymentDate,
    referenceNumber,
    notes,
    createdAt,
    updatedAt,
  ];
}
