import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  const Token({
    required this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'] ?? json['accessToken'],
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
      tokenType: json['token_type'] ?? json['tokenType'] ?? 'Bearer',
      expiresIn: json['expires_in'] ?? json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
  };

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType, expiresIn];
}
