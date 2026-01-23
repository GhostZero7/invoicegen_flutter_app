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
  final String? taxId;
  final String? vatNumber;
  final String? registrationNumber;
  final String? website;
  final String? phone;
  final String email;
  final String? logoUrl;
  final String currency;
  final String timezone;
  final String? fiscalYearEnd;
  final String invoicePrefix;
  final String quotePrefix;
  final int nextInvoiceNumber;
  final int nextQuoteNumber;
  final String paymentTermsDefault;
  final String? notesDefault;
  final String? paymentInstructions;
  final bool isActive;
  final bool isPremium;
  final Address? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BusinessProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessType,
    this.taxId,
    this.vatNumber,
    this.registrationNumber,
    this.website,
    this.phone,
    required this.email,
    this.logoUrl,
    required this.currency,
    required this.timezone,
    this.fiscalYearEnd,
    required this.invoicePrefix,
    required this.quotePrefix,
    required this.nextInvoiceNumber,
    required this.nextQuoteNumber,
    required this.paymentTermsDefault,
    this.notesDefault,
    this.paymentInstructions,
    required this.isActive,
    required this.isPremium,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      businessName: json['business_name'] as String,
      businessType: json['business_type'] as String,
      taxId: json['tax_id'] as String?,
      vatNumber: json['vat_number'] as String?,
      registrationNumber: json['registration_number'] as String?,
      website: json['website'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String,
      logoUrl: json['logo_url'] as String?,
      currency: json['currency'] as String? ?? 'USD',
      timezone: json['timezone'] as String? ?? 'UTC',
      fiscalYearEnd: json['fiscal_year_end'] as String?,
      invoicePrefix: json['invoice_prefix'] as String? ?? 'INV',
      quotePrefix: json['quote_prefix'] as String? ?? 'QUO',
      nextInvoiceNumber: json['next_invoice_number'] as int? ?? 1,
      nextQuoteNumber: json['next_quote_number'] as int? ?? 1,
      paymentTermsDefault: json['payment_terms_default'] as String? ?? 'net_30',
      notesDefault: json['notes_default'] as String?,
      paymentInstructions: json['payment_instructions'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isPremium: json['is_premium'] as bool? ?? false,
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'business_name': businessName,
    'business_type': businessType,
    'tax_id': taxId,
    'vat_number': vatNumber,
    'registration_number': registrationNumber,
    'website': website,
    'phone': phone,
    'email': email,
    'logo_url': logoUrl,
    'currency': currency,
    'timezone': timezone,
    'fiscal_year_end': fiscalYearEnd,
    'invoice_prefix': invoicePrefix,
    'quote_prefix': quotePrefix,
    'next_invoice_number': nextInvoiceNumber,
    'next_quote_number': nextQuoteNumber,
    'payment_terms_default': paymentTermsDefault,
    'notes_default': notesDefault,
    'payment_instructions': paymentInstructions,
    'is_active': isActive,
    'is_premium': isPremium,
    'address': address?.toJson(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    userId,
    businessName,
    businessType,
    taxId,
    vatNumber,
    registrationNumber,
    website,
    phone,
    email,
    logoUrl,
    currency,
    timezone,
    fiscalYearEnd,
    invoicePrefix,
    quotePrefix,
    nextInvoiceNumber,
    nextQuoteNumber,
    paymentTermsDefault,
    notesDefault,
    paymentInstructions,
    isActive,
    isPremium,
    address,
    createdAt,
    updatedAt,
  ];
}
