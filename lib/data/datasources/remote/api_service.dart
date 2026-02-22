// lib/data/datasources/remote/api_service.dart
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invoicegen_flutter_app/core/constants/api_endpoints.dart';
import 'package:invoicegen_flutter_app/data/datasources/remote/graphql_queries.dart';

class ApiService {
  final Dio _dio;
  final SharedPreferences _prefs;
  final GraphQLClient _gqlClient;

  ApiService(this._prefs, this._gqlClient) : _dio = Dio() {
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
      print('🔐 Calling: ${ApiEndpoints.baseUrl}/auth/login');

      final response = await _dio.post(
        '/auth/login', // ← CORRECT PATH
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
        final response = await _dio.get('/users/me');
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
    final result = await _gqlClient.query(
      QueryOptions(
        document: gql(GraphQLQueries.me),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      print('❌ GraphQL Error (me): ${result.exception}');
      throw Exception(result.exception.toString());
    }

    final data = result.data?['me'];
    if (data == null) {
      print('ℹ️ No user logged in (me query returned null)');
      throw Exception('Not authenticated');
    }

    return data;
  }

  // ✅ Request Email Verification
  Future<void> requestVerification(String email) async {
    try {
      print('📧 Requesting verification for: $email');
      final response = await _dio.post(
        '/auth/request-verification',
        data: {'email': email},
      );
      print('✅ Verification request success: ${response.data}');
    } catch (e) {
      print('❌ Request verification error: $e');
      throw Exception('Failed to send verification code');
    }
  }

  // ✅ Verify Email with OTP
  Future<void> verifyEmail(String email, String otp) async {
    try {
      print('🔢 Verifying OTP for: $email');
      final response = await _dio.post(
        '/auth/verify-email',
        data: {'email': email, 'otp': otp},
      );
      print('✅ OTP verified: ${response.data}');
    } catch (e) {
      print('❌ Verify OTP error: $e');
      throw Exception('Invalid verification code');
    }
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
      print('📝 Calling: ${ApiEndpoints.baseUrl}/auth/register');

      final response = await _dio.post(
        '/auth/register', // ← CORRECT PATH
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
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.createInvoice),
          variables: {'input': data},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['createInvoice'] ?? {};
    } catch (e) {
      print('❌ Create invoice (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Get invoices
  Future<Map<String, dynamic>> getInvoices({
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final result = await _gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getInvoices),
          variables: {
            'status': status?.toLowerCase(),
            'skip': skip,
            'limit': limit,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final List<dynamic> invoices = result.data?['invoices'] ?? [];

      return {
        'invoices': invoices,
        'total': invoices
            .length, // GraphQL query doesn't currently return total count in this simple version
        'page': (skip ~/ limit) + 1,
        'page_size': limit,
        'total_pages': 1, // Placeholder
      };
    } catch (e) {
      print('❌ Get invoices (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Get invoice details
  Future<Map<String, dynamic>> getInvoiceDetails(String id) async {
    try {
      final response = await _dio.get('/invoices/$id');
      return response.data;
    } catch (e) {
      print('❌ Get invoice details error: $e');
      rethrow;
    }
  }

  // ✅ Update invoice
  Future<Map<String, dynamic>> updateInvoice(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch('/invoices/$id', data: data);
      return response.data;
    } catch (e) {
      print('❌ Update invoice error: $e');
      rethrow;
    }
  }

  // ✅ Delete invoice
  Future<void> deleteInvoice(String id) async {
    try {
      await _dio.delete('/invoices/$id');
    } catch (e) {
      print('❌ Delete invoice error: $e');
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

  // ✅ Business methods (GraphQL)
  Future<List<dynamic>> getBusinessProfiles() async {
    try {
      final result = await _gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getMyBusinesses),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getBusinessProfiles): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['myBusinesses'] ?? [];
    } catch (e) {
      print('❌ getBusinessProfiles (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createBusinessProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.createBusiness),
          variables: {'input': data},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (createBusinessProfile): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['createBusiness'] ?? {};
    } catch (e) {
      print('❌ createBusinessProfile (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateBusinessProfile(
    String businessId,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.updateBusiness),
          variables: {
            'id': businessId,
            'input': data,
          },
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (updateBusinessProfile): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['updateBusiness'] ?? {};
    } catch (e) {
      print('❌ updateBusinessProfile (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<void> deleteBusinessProfile(String businessId) async {
    try {
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.deleteBusiness),
          variables: {'id': businessId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (deleteBusinessProfile): ${result.exception}');
        throw Exception(result.exception.toString());
      }
    } catch (e) {
      print('❌ deleteBusinessProfile (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBusinessProfile(String businessId) async {
    try {
      final result = await _gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getBusiness),
          variables: {'id': businessId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getBusinessProfile): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      final business = result.data?['business'];
      if (business == null) {
        throw Exception('Business profile not found');
      }

      return business;
    } catch (e) {
      print('❌ getBusinessProfile (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Client methods
  Future<List<dynamic>> getClients({String? businessId}) async {
    try {
      final result = await _gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getClients),
          variables: {if (businessId != null) 'businessId': businessId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['clients'] ?? [];
    } catch (e) {
      print('❌ getClients (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createClient(Map<String, dynamic> data) async {
    try {
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.createClient),
          variables: {'input': data},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['createClient'] ?? {};
    } catch (e) {
      print('❌ createClient (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateClient(String clientId, Map<String, dynamic> data) async {
    try {
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.updateClient),
          variables: {
            'id': clientId,
            'input': data,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['updateClient'] ?? {};
    } catch (e) {
      print('❌ updateClient (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<void> deleteClient(String clientId) async {
    try {
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.deleteClient),
          variables: {'id': clientId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
    } catch (e) {
      print('❌ deleteClient (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getInvoicesForClient(String clientId) async {
    try {
      final result = await _gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getInvoicesForClient),
          variables: {'clientId': clientId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['invoices'] ?? [];
    } catch (e) {
      print('❌ getInvoicesForClient (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Product methods
  Future<List<dynamic>> getProducts({String? businessId}) async {
    try {
      final result = await _gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getProducts),
          variables: {
            'filter': {if (businessId != null) 'businessId': businessId},
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['products'] ?? [];
    } catch (e) {
      print('❌ getProducts (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    try {
      final result = await _gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.createProduct),
          variables: {'input': data},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['createProduct'] ?? {};
    } catch (e) {
      print('❌ createProduct (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Payment methods
  Future<Map<String, dynamic>> recordPayment(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/payments/', data: data);
      return response.data;
    } catch (e) {
      print('❌ recordPayment error: $e');
      throw Exception('Record payment failed: $e');
    }
  }

  Future<List<dynamic>> getPayments({String? invoiceId}) async {
    try {
      final response = await _dio.get(
        '/payments/',
        queryParameters: {if (invoiceId != null) 'invoice_id': invoiceId},
      );
      return response.data;
    } catch (e) {
      print('❌ getPayments error: $e');
      throw Exception('Get payments failed: $e');
    }
  }
}