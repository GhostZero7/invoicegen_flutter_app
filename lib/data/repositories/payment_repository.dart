import 'package:invoicegen_flutter_app/data/datasources/remote/api_service_extensions.dart';
import 'package:invoicegen_flutter_app/data/models/payment.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PaymentRepository {
  late final ApiServiceExtensions _extensions;

  PaymentRepository() {
    _extensions = ApiServiceExtensions(GetIt.I<GraphQLClient>());
  }

  Future<List<Payment>> getPayments({
    String? invoiceId,
    String? status,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _extensions.getPayments(
        invoiceId: invoiceId,
        status: status,
        skip: skip,
        limit: limit,
      );

      return result.map((json) => Payment.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Payment> getPaymentDetails(String paymentId) async {
    try {
      final result = await _extensions.getPaymentDetails(paymentId);
      return Payment.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Payment> createPayment(Map<String, dynamic> data) async {
    try {
      final result = await _extensions.createPayment(data);
      return Payment.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Payment> updatePayment(String paymentId, Map<String, dynamic> data) async {
    try {
      final result = await _extensions.updatePayment(paymentId, data);
      return Payment.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> refundPayment(String paymentId) async {
    try {
      return await _extensions.refundPayment(paymentId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deletePayment(String paymentId) async {
    try {
      return await _extensions.deletePayment(paymentId);
    } catch (e) {
      rethrow;
    }
  }
}
