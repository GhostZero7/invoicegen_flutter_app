import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/invoice_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/business_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/client_provider.dart';
import 'package:invoicegen_flutter_app/presentation/pages/invoices/create_invoice_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/invoices/invoice_details_screen.dart';
import 'package:invoicegen_flutter_app/core/utils/page_transitions.dart';
import 'package:invoicegen_flutter_app/core/services/pdf_service.dart';
import 'package:invoicegen_flutter_app/data/repositories/invoice_repository.dart';
import 'package:invoicegen_flutter_app/data/models/client.dart';
import 'package:invoicegen_flutter_app/data/models/invoice.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class InvoiceListScreen extends ConsumerStatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  ConsumerState<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends ConsumerState<InvoiceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Invoice> _filterInvoices(List<Invoice> invoices) {
    var filtered = invoices;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final clientState = ref.read(clientProvider);
      filtered = filtered.where((invoice) {
        final query = _searchQuery.toLowerCase();
        
        // Search by invoice number and amount
        final invoiceMatch = invoice.invoiceNumber.toLowerCase().contains(query) ||
               invoice.totalAmount.toString().contains(query);
        
        // Search by client name and email
        final client = clientState.clients.where((c) => c.id == invoice.clientId).firstOrNull;
        final clientMatch = client != null && (
          client.clientName.toLowerCase().contains(query) ||
          (client.email?.toLowerCase().contains(query) ?? false)
        );
        
        return invoiceMatch || clientMatch;
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != null && _selectedFilter != 'all') {
      filtered = filtered.where((invoice) {
        return invoice.status.toLowerCase() == _selectedFilter!.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final filteredInvoices = _filterInvoices(state.invoices);

    // Ensure clients are loaded for PDF generation
    ref.listen(invoiceProvider, (previous, next) {
      if (next.invoices.isNotEmpty) {
        ref.read(clientProvider.notifier).fetchClients();
      }
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Search
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Invoices',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0A0E27) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1A1F3A) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search by invoice #, client name, email...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20, top: 8),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1F3A) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: isDark ? Colors.white : Colors.black87,
                      size: 20,
                    ),
                  ),
                  onPressed: () => _showFilterDialog(context, ref, isDark),
                ),
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: () => ref.read(invoiceProvider.notifier).fetchInvoices(),
              child: _buildBody(context, state, filteredInvoices, theme, ref, isDark),
            ),
          ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 80), // Higher to avoid nav bar
        child: FloatingActionButton.extended(
          onPressed: () {
            context.pushSmooth(
              const CreateInvoiceScreen(),
              direction: SlideDirection.bottomToTop,
            );
          },
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.add),
          label: const Text(
            'New Invoice',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    InvoiceState state,
    List<Invoice> filteredInvoices,
    ThemeData theme,
    WidgetRef ref,
    bool isDark,
  ) {
    if (state.isLoading && state.invoices.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null && state.invoices.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.withOpacity(0.6),
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.error}',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    ref.read(invoiceProvider.notifier).fetchInvoices(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredInvoices.isEmpty && _searchQuery.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1F3A) : Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: isDark ? Colors.blue[300] : Colors.blue[600],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No invoices yet',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first invoice to get started',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          if (_selectedFilter != null || _searchQuery.isNotEmpty) ...[
            _buildActiveFilters(isDark),
            const SizedBox(height: 16),
          ],
          
          // Stats Header
          if (state.invoices.isNotEmpty) ...[
            _buildStatsHeader(state, isDark),
            const SizedBox(height: 24),
          ],
          
          // No results message
          if (filteredInvoices.isEmpty && _searchQuery.isNotEmpty) ...[
            _buildNoResults(isDark),
          ] else ...[
            // Invoices List
            ...filteredInvoices.map((invoice) => _buildInvoiceCard(context, invoice, theme, isDark)),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilters(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (_searchQuery.isNotEmpty)
          Chip(
            label: Text('Search: "$_searchQuery"'),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            labelStyle: const TextStyle(color: Colors.blue),
          ),
        if (_selectedFilter != null && _selectedFilter != 'all')
          Chip(
            label: Text('Status: ${_selectedFilter!.toUpperCase()}'),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () {
              setState(() {
                _selectedFilter = null;
              });
            },
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            labelStyle: const TextStyle(color: Colors.green),
          ),
      ],
    );
  }

  Widget _buildNoResults(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No invoices found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(InvoiceState state, bool isDark) {
    final totalInvoices = state.invoices.length;
    final paidInvoices = state.invoices.where((inv) => inv.status.toLowerCase() == 'paid').length;
    final totalAmount = state.invoices.fold<double>(0, (sum, inv) => sum + inv.totalAmount);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total',
              totalInvoices.toString(),
              Icons.receipt_outlined,
              Colors.blue,
              isDark,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          Expanded(
            child: _buildStatItem(
              'Paid',
              paidInvoices.toString(),
              Icons.check_circle_outline,
              Colors.green,
              isDark,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          Expanded(
            child: _buildStatItem(
              'Total Value',
              '\$${totalAmount.toStringAsFixed(0)}',
              Icons.attach_money,
              Colors.purple,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceCard(BuildContext context, dynamic invoice, ThemeData theme, bool isDark) {
    // Get client name
    final clientState = ref.read(clientProvider);
    final client = clientState.clients.where((c) => c.id == invoice.clientId).firstOrNull;
    final clientName = client?.clientName ?? 'Unknown Client';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceDetailsScreen(invoice: invoice),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.invoiceNumber,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                clientName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildStatusChip(invoice.status, theme, isDark),
                      const SizedBox(width: 8),
                      Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            onPressed: () => _generatePdf(context, ref, invoice),
                            tooltip: 'Generate PDF',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Due Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMMMd().format(invoice.dueDate),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${invoice.currency} ${invoice.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme, bool isDark) {
    Color color;
    switch (status.toLowerCase()) {
      case 'paid':
        color = Colors.green;
        break;
      case 'overdue':
        color = Colors.red;
        break;
      case 'draft':
        color = Colors.grey;
        break;
      case 'sent':
        color = Colors.blue;
        break;
      default:
        color = theme.colorScheme.secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref, bool isDark) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    context.showSmoothDialog(
      dialog: AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Filter Invoices',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(
              'All Invoices',
              Icons.receipt_long_outlined,
              () {
                setState(() {
                  _selectedFilter = null;
                });
                Navigator.pop(context);
              },
              isDark,
            ),
            _buildFilterOption(
              'Paid',
              Icons.check_circle_outline,
              () {
                setState(() {
                  _selectedFilter = 'paid';
                });
                Navigator.pop(context);
              },
              isDark,
            ),
            _buildFilterOption(
              'Draft',
              Icons.edit_outlined,
              () {
                setState(() {
                  _selectedFilter = 'draft';
                });
                Navigator.pop(context);
              },
              isDark,
            ),
            _buildFilterOption(
              'Sent',
              Icons.send_outlined,
              () {
                setState(() {
                  _selectedFilter = 'sent';
                });
                Navigator.pop(context);
              },
              isDark,
            ),
            _buildFilterOption(
              'Overdue',
              Icons.warning_amber_outlined,
              () {
                setState(() {
                  _selectedFilter = 'overdue';
                });
                Navigator.pop(context);
              },
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, IconData icon, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context, WidgetRef ref, dynamic invoice) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Fetch full invoice details with items
      final invoiceRepo = GetIt.I<InvoiceRepository>();
      final fullInvoiceResponse = await invoiceRepo.getInvoiceDetails(invoice.id);

      // Get business data
      final businessState = ref.read(businessProvider);
      final business = businessState.selectedBusiness;

      // Get client data
      final clientState = ref.read(clientProvider);
      Client? client;
      try {
        client = clientState.clients.firstWhere(
          (c) => c.id == invoice.clientId,
        );
      } catch (e) {
        // If client not found in state, fetch all clients
        await ref.read(clientProvider.notifier).fetchClients();
        final updatedClientState = ref.read(clientProvider);
        client = updatedClientState.clients.firstWhere(
          (c) => c.id == invoice.clientId,
          orElse: () => throw Exception('Client not found'),
        );
      }

      // Prepare invoice data for PDF
      // Note: Backend should return items in the invoice details response
      final invoiceData = fullInvoiceResponse.toJson();
      
      // If items are not in the response, add empty array
      if (!invoiceData.containsKey('items')) {
        invoiceData['items'] = [];
      }

      // Prepare business data
      final businessData = business != null ? {
        'business_name': business.businessName,
        'email': business.email,
        'phone': business.phone,
      } : null;

      // Prepare client data
      final clientData = {
        'company_name': client.clientName,
        'email': client.email,
        'phone': client.phone,
      };

      // Generate PDF
      final pdf = await PdfService.generateInvoicePdf(
        invoice: invoiceData,
        business: businessData,
        client: clientData,
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Preview PDF
      await PdfService.previewPdf(pdf);
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to generate PDF: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
