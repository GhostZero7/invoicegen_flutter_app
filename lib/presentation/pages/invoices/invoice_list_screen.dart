import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/invoice_provider.dart';
import 'package:intl/intl.dart';
import 'package:invoicegen_flutter_app/presentation/pages/invoices/create_invoice_screen.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoices',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context, ref);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(invoiceProvider.notifier).fetchInvoices(),
        child: _buildBody(context, state, theme, ref), // Pass ref to _buildBody
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateInvoiceScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Added WidgetRef ref parameter to _buildBody to fix scope issue
  Widget _buildBody(
    BuildContext context,
    InvoiceState state,
    ThemeData theme,
    WidgetRef ref,
  ) {
    if (state.isLoading && state.invoices.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            ElevatedButton(
              onPressed: () =>
                  ref.read(invoiceProvider.notifier).fetchInvoices(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.invoices.isEmpty) {
      return const Center(
        child: Text('No invoices found. Create your first one!'),
      );
    }

    return ListView.builder(
      itemCount: state.invoices.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final invoice = state.invoices[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(invoice.status, theme),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Client ID: ${invoice.clientId}'),
                Text('Due: ${DateFormat.yMMMd().format(invoice.dueDate)}'),
              ],
            ),
            trailing: Text(
              '${invoice.currency} ${invoice.totalAmount.toStringAsFixed(2)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            onTap: () {
              // Detail screen later
            },
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Invoices'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All'),
              onTap: () {
                ref.read(invoiceProvider.notifier).setFilter(null);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Paid'),
              onTap: () {
                ref.read(invoiceProvider.notifier).setFilter('paid');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Draft'),
              onTap: () {
                ref.read(invoiceProvider.notifier).setFilter('draft');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
