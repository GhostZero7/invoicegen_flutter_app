class ApiEndpoints {
  // Use emulator IP for testing (Android)
  //static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  static const String baseUrl = 'http://10.148.32.81:8000';
  // For real device (use your computer's IP):
  // static const String baseUrl = 'http://192.168.x.x:8000'; // Your computer IP

  // For iOS simulator:
  // static const String baseUrl = 'http://localhost:8000';

  // ✅ CORRECT ENDPOINTS (from your screenshot):
  // Auth endpoints - Note the double /auth/auth/
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // Invoice endpoint
  static const String createInvoice = '/invoices/invoices/';

  // GraphQL endpoint (definitely exists)
  static const String graphql = '/graphql';

  // Health check (exists)
  static const String health = '/health';

  // Root endpoint (exists)
  static const String root = '/';
  /*
  // ⚠️ THESE MIGHT NOT EXIST - Check your FastAPI docs:
  // The following endpoints from your original list might return 404
  // Remove or comment them out if they don't exist
  static const String users = '/users'; // ❓ Might not exist
  static const String currentUser = '/users/me'; // ❓ Might not exist
  static const String business = '/business'; // ❓ Might not exist  
  static const String clients = '/clients'; // ❓ Might not exist
  static const String products = '/products'; // ❓ Might not exist
  static const String payments = '/payments'; // ❓ Might not exist
  static const String categories = '/categories'; // ❓ Might not exist
  */
  // Alternative: Use GraphQL for these instead
  static const String getUsersGraphQL = '''
    query {
      users {
        id
        email
        firstName
        lastName
      }
    }
  ''';
}
