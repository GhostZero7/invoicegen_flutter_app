import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';
import 'package:invoicegen_flutter_app/data/datasources/remote/api_service_extensions.dart';
import 'package:invoicegen_flutter_app/data/models/invoice.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InvoiceRepository {
  final ApiService _apiService;
  late final ApiServiceExtensions _extensions;

  InvoiceRepository(this._apiService) {
    _extensions = ApiServiceExtensions(GetIt.I<GraphQLClient>());
  }

  Future<List<Invoice>> getInvoices({
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final dynamic result = await _apiService.getInvoices(
        status: status,
        skip: skip,
        limit: limit,
      );

      List<dynamic> invoicesData = [];
      if (result is Map<String, dynamic>) {
        invoicesData = result['invoices'] ?? [];
      } else if (result is List) {
        invoicesData = result;
      }

      return invoicesData.map((json) => Invoice.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Invoice> createInvoice(Map<String, dynamic> data) async {
    try {
      final result = await _apiService.createInvoice(data);
      return Invoice.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Invoice> getInvoiceDetails(String id) async {
    try {
      final result = await _apiService.getInvoiceDetails(id);
      return Invoice.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<Invoice> updateInvoice(String id, Map<String, dynamic> data) async {
    try {
      final result = await _apiService.updateInvoice(id, data);
      return Invoice.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteInvoice(String id) async {
    try {
      await _apiService.deleteInvoice(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getInvoicesForClient(String clientId) async {
    try {
      return await _apiService.getInvoicesForClient(clientId);
    } catch (e) {
      rethrow;
    }
  }

  // Invoice Actions
  Future<List<dynamic>> getInvoiceItems(String invoiceId) async {
    try {
      return await _extensions.getInvoiceItems(invoiceId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendInvoice(String invoiceId) async {
    try {
      return await _extensions.sendInvoice(invoiceId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markInvoiceAsPaid(String invoiceId) async {
    try {
      return await _extensions.markInvoiceAsPaid(invoiceId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> cancelInvoice(String invoiceId) async {
    try {
      return await _extensions.cancelInvoice(invoiceId);
    } catch (e) {
      rethrow;
    }
  }
}
