import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/data/models/invoice.dart';
import 'package:invoicegen_flutter_app/data/models/invoice_item.dart';
import 'package:invoicegen_flutter_app/data/models/payment.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/business_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/client_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/invoice_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/payment_provider.dart';
import 'package:invoicegen_flutter_app/presentation/pages/payments/record_payment_screen.dart';
import 'package:invoicegen_flutter_app/core/services/pdf_service.dart';
import 'package:invoicegen_flutter_app/data/repositories/invoice_repository.dart';
import 'package:invoicegen_flutter_app/data/models/client.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class InvoiceDetailsScreen extends ConsumerStatefulWidget {
  final Invoice invoice;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoice,
  });

  @override
  ConsumerState<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends ConsumerState<InvoiceDetailsScreen> {
  List<InvoiceItem> _items = [];
  List<Payment> _payments = [];
  bool _isLoadingItems = true;

  @override
  void initState() {
    super.initState();
    _loadInvoiceItems();
    _loadPayments();
  }

  Future<void> _loadInvoiceItems() async {
    try {
      final items = await ref.read(invoiceProvider.notifier).getInvoiceItems(widget.invoice.id);
      
      setState(() {
        _items = items.map((json) => InvoiceItem.fromJson(json)).toList();
        _isLoadingItems = false;
      });
    } catch (e) {
      print('Error loading invoice items: $e');
      setState(() {
        _isLoadingItems = false;
      });
    }
  }

  Future<void> _loadPayments() async {
    try {
      await ref.read(paymentProvider.notifier).fetchPayments(invoiceId: widget.invoice.id);
      final paymentState = ref.read(paymentProvider);
      
      setState(() {
        _payments = paymentState.payments;
      });
    } catch (e) {
      print('Error loading payments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: widget.invoice.currency);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Invoice Details',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.share, color: Colors.blue, size: 20),
                ),
                onPressed: () => _shareInvoice(context),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                ),
                onPressed: () => _generatePdf(context),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status and Amount Card
                  _buildHeaderCard(isDark, currencyFormat),
                  const SizedBox(height: 24),

                  // Invoice Information
                  _buildSectionHeader('INVOICE INFORMATION', isDark),
                  const SizedBox(height: 12),
                  _buildInfoCard(isDark),
                  const SizedBox(height: 24),

                  // Business & Client Info
                  _buildSectionHeader('PARTIES', isDark),
                  const SizedBox(height: 12),
                  _buildPartiesCard(isDark),
                  const SizedBox(height: 24),

                  // Items
                  _buildSectionHeader('ITEMS', isDark),
                  const SizedBox(height: 12),
                  _buildItemsCard(isDark),
                  const SizedBox(height: 24),

                  // Payment Summary
                  _buildSectionHeader('PAYMENT SUMMARY', isDark),
                  const SizedBox(height: 12),
                  _buildPaymentSummaryCard(isDark, currencyFormat),
                  const SizedBox(height: 24),

                  // Payment History
                  if (_payments.isNotEmpty) ...[
                    _buildSectionHeader('PAYMENT HISTORY', isDark),
                    const SizedBox(height: 12),
                    _buildPaymentHistoryCard(isDark, currencyFormat),
                    const SizedBox(height: 24),
                  ],

                  // Notes
                  if (widget.invoice.notes != null && widget.invoice.notes!.isNotEmpty) ...[
                    _buildSectionHeader('NOTES', isDark),
                    const SizedBox(height: 12),
                    _buildNotesCard(isDark),
                    const SizedBox(height: 24),
                  ],

                  // Action Buttons
                  _buildActionButtons(isDark),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.invoice.invoiceNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Invoice',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              _buildStatusChip(widget.invoice.status),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
              Text(
                currencyFormat.format(widget.invoice.totalAmount),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'paid':
        bgColor = Colors.green.shade400;
        textColor = Colors.white;
        break;
      case 'overdue':
        bgColor = Colors.red.shade400;
        textColor = Colors.white;
        break;
      case 'draft':
        bgColor = Colors.grey.shade400;
        textColor = Colors.white;
        break;
      case 'sent':
        bgColor = Colors.blue.shade400;
        textColor = Colors.white;
        break;
      default:
        bgColor = Colors.orange.shade400;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'Invoice Number',
            widget.invoice.invoiceNumber,
            Icons.receipt_long_outlined,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Invoice Date',
            dateFormat.format(widget.invoice.invoiceDate),
            Icons.calendar_today_outlined,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Due Date',
            dateFormat.format(widget.invoice.dueDate),
            Icons.event_outlined,
            isDark,
            isOverdue: widget.invoice.dueDate.isBefore(DateTime.now()) && 
                       widget.invoice.status.toLowerCase() != 'paid',
          ),
          if (widget.invoice.paymentTerms != null) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              'Payment Terms',
              widget.invoice.paymentTerms!,
              Icons.payment_outlined,
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, bool isDark, {bool isOverdue = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isOverdue ? Colors.red : Colors.blue).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isOverdue ? Colors.red : Colors.blue,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isOverdue 
                      ? Colors.red 
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ],
          ),
        ),
        if (label == 'Invoice Number')
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 18,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPartiesCard(bool isDark) {
    final businessState = ref.watch(businessProvider);
    final clientState = ref.watch(clientProvider);
    
    final business = businessState.selectedBusiness;
    Client? client;
    
    try {
      client = clientState.clients.firstWhere(
        (c) => c.id == widget.invoice.clientId,
      );
    } catch (e) {
      // Client not found
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // From (Business)
          _buildPartyInfo(
            'From',
            business?.businessName ?? 'Your Business',
            business?.email ?? '',
            business?.phone ?? '',
            Icons.business_outlined,
            Colors.blue,
            isDark,
          ),
          const SizedBox(height: 20),
          Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 20),
          // To (Client)
          _buildPartyInfo(
            'To',
            client?.clientName ?? 'Client',
            client?.email ?? '',
            client?.phone ?? '',
            Icons.person_outline,
            Colors.green,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPartyInfo(
    String label,
    String name,
    String email,
    String phone,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
        if (phone.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildItemsCard(bool isDark) {
    if (_isLoadingItems) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'No items available',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Amount',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Items
          ..._items.map((item) => _buildItemRow(item, isDark)),
        ],
      ),
    );
  }

  Widget _buildItemRow(InvoiceItem item, bool isDark) {
    final currencyFormat = NumberFormat.currency(symbol: widget.invoice.currency);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${currencyFormat.format(item.unitPrice)} each',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(item.amount),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(bool isDark, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal',
            currencyFormat.format(widget.invoice.subtotal),
            isDark,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Tax',
            currencyFormat.format(widget.invoice.taxAmount),
            isDark,
          ),
          if (widget.invoice.discountAmount > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Discount',
              '- ${currencyFormat.format(widget.invoice.discountAmount)}',
              isDark,
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Total',
            currencyFormat.format(widget.invoice.totalAmount),
            isDark,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDiscount 
                ? Colors.green 
                : (isTotal ? Colors.blue : (isDark ? Colors.white : Colors.black87)),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        widget.invoice.notes!,
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    // Only show "Record Payment" if invoice is not fully paid
    final canRecordPayment = widget.invoice.status.toLowerCase() != 'paid' && 
                             widget.invoice.amountDue > 0;

    return Column(
      children: [
        if (canRecordPayment) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _recordPayment(context),
              icon: const Icon(Icons.payment),
              label: const Text('Record Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _markAsPaid(context),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Mark as Paid'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _sendReminder(context),
                icon: const Icon(Icons.send_outlined),
                label: const Text('Send Invoice'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildPaymentHistoryCard(bool isDark, NumberFormat currencyFormat) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _payments.map((payment) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.paymentNumber,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormat('MMM dd, yyyy').format(payment.paymentDate)} • ${PaymentMethod.fromString(payment.paymentMethod).displayName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  currencyFormat.format(payment.amount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _recordPayment(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordPaymentScreen(invoice: widget.invoice),
      ),
    );

    if (result == true && mounted) {
      // Reload payments and invoice data
      await _loadPayments();
      // Refresh invoice list
      ref.read(invoiceProvider.notifier).fetchInvoices();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment recorded and invoice updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _generatePdf(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final invoiceRepo = GetIt.I<InvoiceRepository>();
      final fullInvoice = await invoiceRepo.getInvoiceDetails(widget.invoice.id);

      final businessState = ref.read(businessProvider);
      final business = businessState.selectedBusiness;

      final clientState = ref.read(clientProvider);
      Client? client;
      try {
        client = clientState.clients.firstWhere((c) => c.id == widget.invoice.clientId);
      } catch (e) {
        await ref.read(clientProvider.notifier).fetchClients();
        final updatedClientState = ref.read(clientProvider);
        client = updatedClientState.clients.firstWhere(
          (c) => c.id == widget.invoice.clientId,
          orElse: () => throw Exception('Client not found'),
        );
      }

      final invoiceData = fullInvoice.toJson();
      if (!invoiceData.containsKey('items')) {
        invoiceData['items'] = [];
      }

      final businessData = business != null
          ? {
              'business_name': business.businessName,
              'email': business.email,
              'phone': business.phone,
            }
          : null;

      final clientData = {
        'company_name': client.clientName,
        'email': client.email,
        'phone': client.phone,
      };

      final pdf = await PdfService.generateInvoicePdf(
        invoice: invoiceData,
        business: businessData,
        client: clientData,
      );

      if (context.mounted) Navigator.pop(context);
      await PdfService.previewPdf(pdf);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    }
  }

  void _shareInvoice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _markAsPaid(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Paid'),
        content: const Text('Are you sure you want to mark this invoice as paid?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Mark as Paid'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final success = await ref.read(invoiceProvider.notifier).markInvoiceAsPaid(widget.invoice.id);
        
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invoice marked as paid successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Go back to list
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to mark invoice as paid'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _sendReminder(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Invoice'),
        content: const Text('Send this invoice to the client?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final success = await ref.read(invoiceProvider.notifier).sendInvoice(widget.invoice.id);
        
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invoice sent successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to send invoice'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
