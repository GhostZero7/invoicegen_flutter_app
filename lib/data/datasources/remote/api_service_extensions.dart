// Extension methods for ApiService - Invoice, Payment, Product, Client operations
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:invoicegen_flutter_app/data/datasources/remote/graphql_queries.dart';

class ApiServiceExtensions {
  final GraphQLClient gqlClient;

  ApiServiceExtensions(this.gqlClient);

  // ✅ Invoice Actions (GraphQL)
  
  Future<Map<String, dynamic>> getInvoiceDetails(String invoiceId) async {
    try {
      final result = await gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getInvoice),
          variables: {'id': invoiceId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getInvoiceDetails): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['invoice'] ?? {};
    } catch (e) {
      print('❌ getInvoiceDetails (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getInvoiceItems(String invoiceId) async {
    try {
      final result = await gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getInvoiceItems),
          variables: {'invoiceId': invoiceId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getInvoiceItems): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['invoiceItems'] ?? [];
    } catch (e) {
      print('❌ getInvoiceItems (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateInvoice(String invoiceId, Map<String, dynamic> data) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.updateInvoice),
          variables: {
            'id': invoiceId,
            'input': data,
          },
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (updateInvoice): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['updateInvoice'] ?? {};
    } catch (e) {
      print('❌ updateInvoice (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<bool> deleteInvoice(String invoiceId) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.deleteInvoice),
          variables: {'id': invoiceId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (deleteInvoice): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['deleteInvoice'] ?? false;
    } catch (e) {
      print('❌ deleteInvoice (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<bool> sendInvoice(String invoiceId) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.sendInvoice),
          variables: {'id': invoiceId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (sendInvoice): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['sendInvoice'] ?? false;
    } catch (e) {
      print('❌ sendInvoice (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<bool> markInvoiceAsPaid(String invoiceId) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.markInvoiceAsPaid),
          variables: {'id': invoiceId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (markInvoiceAsPaid): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['markInvoiceAsPaid'] ?? false;
    } catch (e) {
      print('❌ markInvoiceAsPaid (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<bool> cancelInvoice(String invoiceId) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.cancelInvoice),
          variables: {'id': invoiceId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (cancelInvoice): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['cancelInvoice'] ?? false;
    } catch (e) {
      print('❌ cancelInvoice (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Payment methods (GraphQL)

  Future<List<dynamic>> getPayments({String? invoiceId, String? status, int skip = 0, int limit = 50}) async {
    try {
      final result = await gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getPayments),
          variables: {
            if (invoiceId != null) 'invoiceId': invoiceId,
            if (status != null) 'status': status.toUpperCase(),
            'skip': skip,
            'limit': limit,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getPayments): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['payments'] ?? [];
    } catch (e) {
      print('❌ getPayments (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPaymentDetails(String paymentId) async {
    try {
      final result = await gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getPayment),
          variables: {'id': paymentId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getPaymentDetails): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['payment'] ?? {};
    } catch (e) {
      print('❌ getPaymentDetails (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createPayment(Map<String, dynamic> data) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.createPayment),
          variables: {'input': data},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (createPayment): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['createPayment'] ?? {};
    } catch (e) {
      print('❌ createPayment (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updatePayment(String paymentId, Map<String, dynamic> data) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.updatePayment),
          variables: {
            'id': paymentId,
            'input': data,
          },
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (updatePayment): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['updatePayment'] ?? {};
    } catch (e) {
      print('❌ updatePayment (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<bool> refundPayment(String paymentId) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.refundPayment),
          variables: {'id': paymentId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (refundPayment): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['refundPayment'] ?? false;
    } catch (e) {
      print('❌ refundPayment (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<bool> deletePayment(String paymentId) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.deletePayment),
          variables: {'id': paymentId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (deletePayment): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['deletePayment'] ?? false;
    } catch (e) {
      print('❌ deletePayment (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Product methods (GraphQL)

  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final result = await gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getProduct),
          variables: {'id': productId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getProductDetails): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['product'] ?? {};
    } catch (e) {
      print('❌ getProductDetails (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.updateProduct),
          variables: {
            'id': productId,
            'input': data,
          },
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (updateProduct): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['updateProduct'] ?? {};
    } catch (e) {
      print('❌ updateProduct (GraphQL) error: $e');
      rethrow;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      final result = await gqlClient.mutate(
        MutationOptions(
          document: gql(GraphQLQueries.deleteProduct),
          variables: {'id': productId},
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (deleteProduct): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['deleteProduct'] ?? false;
    } catch (e) {
      print('❌ deleteProduct (GraphQL) error: $e');
      rethrow;
    }
  }

  // ✅ Client methods (GraphQL)

  Future<Map<String, dynamic>> getClientDetails(String clientId) async {
    try {
      final result = await gqlClient.query(
        QueryOptions(
          document: gql(GraphQLQueries.getClient),
          variables: {'id': clientId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('❌ GraphQL Error (getClientDetails): ${result.exception}');
        throw Exception(result.exception.toString());
      }

      return result.data?['client'] ?? {};
    } catch (e) {
      print('❌ getClientDetails (GraphQL) error: $e');
      rethrow;
    }
  }
}
