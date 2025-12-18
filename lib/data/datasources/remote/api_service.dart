// lib/data/datasources/remote/api_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invoicegen_flutter_app/core/constants/api_endpoints.dart';

class ApiService {
  final Dio _dio;
  final SharedPreferences _prefs;

  ApiService(this._prefs) : _dio = Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add auth header interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // Add logging
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // ✅ CORRECT LOGIN ENDPOINT
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Calling: ${ApiEndpoints.baseUrl}/auth/auth/login');

      final response = await _dio.post(
        '/auth/auth/login', // ← CORRECT PATH
        data: {'email': email, 'password': password},
      );

      print('✅ Login response: ${response.data}');

      if (response.data?['access_token'] != null) {
        final token = response.data!['access_token'];
        await _prefs.setString('access_token', token);
        print('🔑 Token saved: ${token.substring(0, 20)}...');
        return response.data!;
      }

      throw Exception('Login failed: No access_token received');
    } on DioException catch (e) {
      print('❌ Login DioException: ${e.type}');
      print('❌ Status code: ${e.response?.statusCode}');
      print('❌ Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  // ✅ Get current user (Check if REST or GraphQL)
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      // First try REST endpoint if it exists
      // If not, try GraphQL

      print('👤 Getting current user...');

      // Option 1: Try REST first
      try {
        final response = await _dio.get('/api/v1/users/me');
        print('✅ User via REST: ${response.data}');
        return response.data;
      } catch (restError) {
        print('⚠️ REST endpoint failed: $restError');

        // Option 2: Try GraphQL
        return await getCurrentUserViaGraphQL();
      }
    } catch (e) {
      print('❌ Get user error: $e');
      rethrow;
    }
  }

  // GraphQL version for getting user
  Future<Map<String, dynamic>> getCurrentUserViaGraphQL() async {
    const query = '''
      query {
        me {
          id
          email
          first_name: firstName
          last_name: lastName
          phone
          role
          status
          created_at: createdAt
          updated_at: updatedAt
        }
      }
    ''';

    final response = await _dio.post('/graphql', data: {'query': query});

    // Handle null response (user not logged in)
    if (response.data?['data']?['me'] == null) {
      print('ℹ️ No user logged in (me query returned null)');
      throw Exception('Not authenticated');
    }

    if (response.data?['data']?['me'] != null) {
      return response.data!['data']['me'];
    } else if (response.data?['errors'] != null) {
      throw Exception(response.data!['errors'][0]['message']);
    }

    throw Exception('Failed to get user via GraphQL');
  }

  // ✅ Register user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      print('📝 Calling: ${ApiEndpoints.baseUrl}/auth/auth/register');

      final response = await _dio.post(
        '/auth/auth/register', // ← CORRECT PATH
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
        },
      );

      print('✅ Register response: ${response.data}');

      if (response.data?['access_token'] != null) {
        final token = response.data!['access_token'];
        await _prefs.setString('access_token', token);
        return response.data!;
      }

      throw Exception('Registration failed');
    } on DioException catch (e) {
      print('❌ Register DioException: ${e.type}');
      print('❌ Status code: ${e.response?.statusCode}');
      print('❌ Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ Register error: $e');
      rethrow;
    }
  }

  // ✅ Create invoice
  Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> data) async {
    try {
      print('🧾 Calling: ${ApiEndpoints.baseUrl}/invoices/invoices/');

      final response = await _dio.post(
        '/invoices/invoices/', // ← CORRECT PATH
        data: data,
      );

      print('✅ Invoice created: ${response.data}');
      return response.data;
    } catch (e) {
      print('❌ Create invoice error: $e');
      rethrow;
    }
  }

  // ✅ Check server health
  Future<bool> checkServerHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _prefs.remove('access_token');
  }

  // ✅ Connection testing with detailed diagnostics
  Future<Map<String, dynamic>> checkConnection() async {
    final Map<String, dynamic> results = {
      'baseUrl': ApiEndpoints.baseUrl,
      'success': false,
      'endpoints': <String, Map<String, dynamic>>{},
    };

    try {
      final endpoints =
          results['endpoints'] as Map<String, Map<String, dynamic>>;

      // Test health endpoint
      try {
        final healthResponse = await _dio.get(
          '/health',
          options: Options(validateStatus: (_) => true),
        );
        endpoints['/health'] = {
          'status': healthResponse.statusCode,
          'message': healthResponse.statusCode == 200
              ? 'Health check OK'
              : 'Health endpoint exists',
        };
      } catch (e) {
        endpoints['/health'] = {'error': e.toString()};
      }

      // Test root endpoint
      try {
        final rootResponse = await _dio.get(
          '/',
          options: Options(validateStatus: (_) => true),
        );
        endpoints['/'] = {
          'status': rootResponse.statusCode,
          'message': 'Root endpoint OK',
        };
      } catch (e) {
        endpoints['/'] = {'error': e.toString()};
      }

      // Determine overall success
      final successfulTests = endpoints.values
          .where(
            (endpoint) =>
                endpoint['status'] != null && (endpoint['status'] as int) < 400,
          )
          .length;

      results['success'] = successfulTests > 0;
      results['message'] = successfulTests > 0
          ? 'Connected to backend successfully!'
          : 'Cannot connect to backend.\n\nTroubleshooting:\n• Ensure backend is running\n• Check if phone and PC are on same WiFi\n• Verify firewall allows port 8000';

      return results;
    } on DioException catch (e) {
      String errorMessage;

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Backend might be slow or unreachable.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout. Backend is not responding.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Cannot connect to backend.\n\nTroubleshooting:\n• Ensure backend is running\n• Check if phone and PC are on same WiFi\n• Verify firewall allows port 8000';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage =
            'Backend responded with error: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Network error: ${e.message}';
      }

      return {
        'success': false,
        'message': errorMessage,
        'error': e.type.toString(),
        'baseUrl': ApiEndpoints.baseUrl,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: ${e.toString()}',
        'baseUrl': ApiEndpoints.baseUrl,
      };
    }
  }

  // ✅ Business methods (stub implementations)
  Future<List<dynamic>> getBusinessProfiles() async {
    try {
      final response = await _dio.get('/api/v1/business');
      return response.data;
    } catch (e) {
      print('❌ getBusinessProfiles error: $e');
      throw Exception('Business profiles endpoint not implemented');
    }
  }

  Future<Map<String, dynamic>> createBusinessProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post('/api/v1/business', data: data);
      return response.data;
    } catch (e) {
      print('❌ createBusinessProfile error: $e');
      throw Exception('Create business profile endpoint not implemented');
    }
  }

  // ✅ Invoice methods
  Future<List<dynamic>> getInvoices({
    String? businessId,
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/invoices/invoices/',
        queryParameters: {
          if (businessId != null) 'business_id': businessId,
          if (status != null) 'status': status,
          'skip': skip,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      print('❌ getInvoices error: $e');
      throw Exception('Get invoices failed: $e');
    }
  }

  // ✅ Client methods
  Future<List<dynamic>> getClients({String? businessId}) async {
    try {
      final response = await _dio.get(
        '/api/v1/clients',
        queryParameters: businessId != null
            ? {'business_id': businessId}
            : null,
      );
      return response.data;
    } catch (e) {
      print('❌ getClients error: $e');
      throw Exception('Get clients endpoint not implemented');
    }
  }

  Future<Map<String, dynamic>> createClient(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/v1/clients', data: data);
      return response.data;
    } catch (e) {
      print('❌ createClient error: $e');
      throw Exception('Create client endpoint not implemented');
    }
  }

  // ✅ Product methods
  Future<List<dynamic>> getProducts({String? businessId}) async {
    try {
      final response = await _dio.get(
        '/api/v1/products',
        queryParameters: businessId != null
            ? {'business_id': businessId}
            : null,
      );
      return response.data;
    } catch (e) {
      print('❌ getProducts error: $e');
      throw Exception('Get products endpoint not implemented');
    }
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/v1/products', data: data);
      return response.data;
    } catch (e) {
      print('❌ createProduct error: $e');
      throw Exception('Create product endpoint not implemented');
    }
  }
}
