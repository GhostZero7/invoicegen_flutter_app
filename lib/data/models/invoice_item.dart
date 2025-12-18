import 'package:equatable/equatable.dart';

class InvoiceItem extends Equatable {
  final String id;
  final String invoiceId;
  final String? productId;
  final String description;
  final int quantity;
  final double unitPrice;
  final double taxRate;
  final double amount;

  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    this.productId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.taxRate,
    required this.amount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      invoiceId: json['invoice_id'],
      productId: json['product_id'],
      description: json['description'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      taxRate: (json['tax_rate'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_id': invoiceId,
    'product_id': productId,
    'description': description,
    'quantity': quantity,
    'unit_price': unitPrice,
    'tax_rate': taxRate,
    'amount': amount,
  };

  @override
  List<Object?> get props => [
    id,
    invoiceId,
    productId,
    description,
    quantity,
    unitPrice,
    taxRate,
    amount,
  ];
}
