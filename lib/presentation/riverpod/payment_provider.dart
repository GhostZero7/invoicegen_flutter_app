import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/data/models/payment.dart';
import 'package:invoicegen_flutter_app/data/repositories/payment_repository.dart';

class PaymentState {
  final List<Payment> payments;
  final bool isLoading;
  final String? error;
  final String? filterStatus;
  final String? filterInvoiceId;

  PaymentState({
    this.payments = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus,
    this.filterInvoiceId,
  });

  PaymentState copyWith({
    List<Payment>? payments,
    bool? isLoading,
    String? error,
    String? filterStatus,
    String? filterInvoiceId,
  }) {
    return PaymentState(
      payments: payments ?? this.payments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterStatus: filterStatus ?? this.filterStatus,
      filterInvoiceId: filterInvoiceId ?? this.filterInvoiceId,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repository;

  PaymentNotifier(this._repository) : super(PaymentState());

  Future<void> fetchPayments({String? invoiceId, String? status}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final payments = await _repository.getPayments(
        invoiceId: invoiceId ?? state.filterInvoiceId,
        status: status ?? state.filterStatus,
      );
      state = state.copyWith(
        payments: payments,
        isLoading: false,
        filterInvoiceId: invoiceId,
        filterStatus: status,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Payment?> getPaymentDetails(String paymentId) async {
    try {
      return await _repository.getPaymentDetails(paymentId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> createPayment(Map<String, dynamic> data) async {
    try {
      await _repository.createPayment(data);
      await fetchPayments(); // Refresh list
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updatePayment(String paymentId, Map<String, dynamic> data) async {
    try {
      await _repository.updatePayment(paymentId, data);
      await fetchPayments(); // Refresh list
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> refundPayment(String paymentId) async {
    try {
      final success = await _repository.refundPayment(paymentId);
      if (success) {
        await fetchPayments(); // Refresh list
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deletePayment(String paymentId) async {
    try {
      final success = await _repository.deletePayment(paymentId);
      if (success) {
        await fetchPayments(); // Refresh list
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  void setFilter({String? invoiceId, String? status}) {
    state = state.copyWith(
      filterInvoiceId: invoiceId,
      filterStatus: status,
    );
    fetchPayments();
  }

  void clearFilters() {
    state = state.copyWith(
      filterInvoiceId: null,
      filterStatus: null,
    );
    fetchPayments();
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final repository = PaymentRepository();
  return PaymentNotifier(repository);
});
