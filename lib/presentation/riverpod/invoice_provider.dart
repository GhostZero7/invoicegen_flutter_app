import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/data/models/invoice.dart';
import 'package:invoicegen_flutter_app/data/repositories/invoice_repository.dart';
import 'package:get_it/get_it.dart';

class InvoiceState {
  final List<Invoice> invoices;
  final bool isLoading;
  final String? error;
  final String? filterStatus;

  InvoiceState({
    this.invoices = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus,
  });

  InvoiceState copyWith({
    List<Invoice>? invoices,
    bool? isLoading,
    String? error,
    String? filterStatus,
  }) {
    return InvoiceState(
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}

class InvoiceNotifier extends StateNotifier<InvoiceState> {
  final InvoiceRepository _repository;

  InvoiceNotifier(this._repository) : super(InvoiceState());

  Future<void> fetchInvoices() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final invoices = await _repository.getInvoices(
        status: state.filterStatus,
      );
      state = state.copyWith(invoices: invoices, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setFilter(String? status) {
    state = state.copyWith(filterStatus: status);
    fetchInvoices();
  }

  Future<bool> createInvoice(Map<String, dynamic> data) async {
    try {
      await _repository.createInvoice(data);
      fetchInvoices();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> fetchInvoicesForClient(String clientId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final invoices = await _repository.getInvoicesForClient(clientId);
      // Convert the dynamic list to Invoice objects
      final invoiceList = invoices.map((json) => Invoice.fromJson(json)).toList();
      state = state.copyWith(invoices: invoiceList, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final invoiceProvider = StateNotifierProvider<InvoiceNotifier, InvoiceState>((
  ref,
) {
  final repository = GetIt.I<InvoiceRepository>();
  return InvoiceNotifier(repository)..fetchInvoices();
});
