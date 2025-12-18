import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';

class ConnectionService {
  final ApiService _apiService;

  ConnectionService(this._apiService);

  /// Test connection to backend and return detailed status
  Future<ConnectionStatus> testConnection() async {
    final result = await _apiService.checkConnection();
    
    return ConnectionStatus(
      isConnected: result['success'] as bool,
      message: result['message'] as String,
      baseUrl: result['baseUrl'] as String,
      statusCode: result['statusCode'] as int?,
      error: result['error'] as String?,
    );
  }
}

class ConnectionStatus {
  final bool isConnected;
  final String message;
  final String baseUrl;
  final int? statusCode;
  final String? error;

  ConnectionStatus({
    required this.isConnected,
    required this.message,
    required this.baseUrl,
    this.statusCode,
    this.error,
  });

  @override
  String toString() {
    return 'ConnectionStatus(isConnected: $isConnected, message: $message, baseUrl: $baseUrl)';
  }
}
