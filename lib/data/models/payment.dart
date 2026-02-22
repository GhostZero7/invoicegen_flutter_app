import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String invoiceId;
  final String paymentNumber;
  final DateTime paymentDate;
  final double amount;
  final String paymentMethod;
  final String? transactionId;
  final String? referenceNumber;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.invoiceId,
    required this.paymentNumber,
    required this.paymentDate,
    required this.amount,
    required this.paymentMethod,
    this.transactionId,
    this.referenceNumber,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? '',
      invoiceId: json['invoice_id'] ?? json['invoiceId'] ?? '',
      paymentNumber: json['payment_number'] ?? json['paymentNumber'] ?? '',
      paymentDate: DateTime.parse(
        json['payment_date'] ?? json['paymentDate'] ?? DateTime.now().toIso8601String(),
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? json['paymentMethod'] ?? 'CASH',
      transactionId: json['transaction_id'] ?? json['transactionId'],
      referenceNumber: json['reference_number'] ?? json['referenceNumber'],
      notes: json['notes'],
      status: json['status'] ?? 'COMPLETED',
      createdAt: DateTime.parse(
        json['created_at'] ?? json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_id': invoiceId,
    'payment_number': paymentNumber,
    'payment_date': paymentDate.toIso8601String(),
    'amount': amount,
    'payment_method': paymentMethod,
    'transaction_id': transactionId,
    'reference_number': referenceNumber,
    'notes': notes,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    paymentNumber,
    paymentDate,
    amount,
    paymentMethod,
    transactionId,
    referenceNumber,
    notes,
    status,
    createdAt,
    updatedAt,
  ];
}

// Payment Method Enum
enum PaymentMethod {
  cash,
  bankTransfer,
  creditCard,
  debitCard,
  check,
  paypal,
  stripe,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.stripe:
        return 'Stripe';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  String get apiValue {
    switch (this) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
      case PaymentMethod.creditCard:
        return 'CREDIT_CARD';
      case PaymentMethod.debitCard:
        return 'DEBIT_CARD';
      case PaymentMethod.check:
        return 'CHECK';
      case PaymentMethod.paypal:
        return 'PAYPAL';
      case PaymentMethod.stripe:
        return 'STRIPE';
      case PaymentMethod.other:
        return 'OTHER';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CASH':
        return PaymentMethod.cash;
      case 'BANK_TRANSFER':
        return PaymentMethod.bankTransfer;
      case 'CREDIT_CARD':
        return PaymentMethod.creditCard;
      case 'DEBIT_CARD':
        return PaymentMethod.debitCard;
      case 'CHECK':
        return PaymentMethod.check;
      case 'PAYPAL':
        return PaymentMethod.paypal;
      case 'STRIPE':
        return PaymentMethod.stripe;
      default:
        return PaymentMethod.other;
    }
  }
}

// Payment Status Enum
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  cancelled;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get apiValue {
    return name.toUpperCase();
  }

  static PaymentStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return PaymentStatus.pending;
      case 'COMPLETED':
        return PaymentStatus.completed;
      case 'FAILED':
        return PaymentStatus.failed;
      case 'REFUNDED':
        return PaymentStatus.refunded;
      case 'CANCELLED':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.completed;
    }
  }
}
