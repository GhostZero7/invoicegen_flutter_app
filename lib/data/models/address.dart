import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  const Address({
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
    'street': street,
    'city': city,
    'state': state,
    'postal_code': postalCode,
    'country': country,
  };

  @override
  List<Object?> get props => [street, city, state, postalCode, country];
}
