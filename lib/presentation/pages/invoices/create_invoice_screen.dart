import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/data/models/client.dart';
import 'package:invoicegen_flutter_app/data/models/product.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/client_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/product_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/invoice_provider.dart';
import 'package:intl/intl.dart';

class CreateInvoiceScreen extends ConsumerStatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  ConsumerState<CreateInvoiceScreen> createState() =>
      _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends ConsumerState<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  Client? _selectedClient;
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  final List<Map<String, dynamic>> _items = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clientProvider.notifier).fetchClients();
      ref.read(productProvider.notifier).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveInvoice,
              child: const Text(
                'SAVE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClientSelector(theme, context, ref),
              const SizedBox(height: 24),
              _buildDateSelectors(context),
              const SizedBox(height: 24),
              const Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _buildItemsList(),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _addItem(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
              const SizedBox(height: 32),
              _buildTotals(theme),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientSelector(
    ThemeData theme,
    BuildContext context,
    WidgetRef ref,
  ) {
    final clientState = ref.watch(clientProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bill To',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (clientState.isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectClient(context, ref),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedClient?.clientName ?? 'Select a Client',
                    style: TextStyle(
                      color: _selectedClient == null ? Colors.grey : null,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (clientState.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Error loading clients: ${clientState.error}',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDateSelectors(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(DateFormat.yMMMd().format(_invoiceDate)),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, false),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Due Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(DateFormat.yMMMd().format(_dueDate)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    if (_items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text('No items yet', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Column(
      children: _items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return ListTile(
          title: Text(item['description']),
          subtitle: Text('${item['quantity']} x ${item['unit_price']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text((item['quantity'] * item['unit_price']).toStringAsFixed(2)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _items.removeAt(index)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotals(ThemeData theme) {
    double subtotal = 0;
    for (var item in _items) {
      subtotal += item['quantity'] * item['unit_price'];
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Subtotal'), Text(subtotal.toStringAsFixed(2))],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              subtotal.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _selectClient(BuildContext context, WidgetRef ref) async {
    final clientState = ref.read(clientProvider);

    // Refresh clients if empty and not loading
    if (clientState.clients.isEmpty && !clientState.isLoading) {
      ref.read(clientProvider.notifier).fetchClients();
    }

    // Wait for the UI logic to handle the state
    if (!mounted) return;

    final selected = await showModalBottomSheet<Client>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(clientProvider);
                if (state.isLoading && state.clients.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.clients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No clients found. Add one first!'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigate to add client screen (TODO)
                          },
                          child: const Text('Add Client'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: state.clients.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        state.clients[index].clientName[0].toUpperCase(),
                      ),
                    ),
                    title: Text(state.clients[index].clientName),
                    subtitle: Text(state.clients[index].email ?? 'No email'),
                    onTap: () => Navigator.pop(context, state.clients[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedClient = selected);
    }
  }

  void _addItem(BuildContext context, WidgetRef ref) async {
    final productState = ref.read(productProvider);

    if (productState.products.isEmpty && !productState.isLoading) {
      ref.read(productProvider.notifier).fetchProducts();
    }

    if (!mounted) return;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        // Form state
        String desc = '';
        double qty = 1;
        double price = 0;
        final qtyController = TextEditingController(text: '1');
        final priceController = TextEditingController(text: '0');
        final descController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Selection
                    Consumer(
                      builder: (context, ref, _) {
                        final state = ref.watch(productProvider);
                        if (state.products.isNotEmpty) {
                          return DropdownButtonFormField<Product>(
                            decoration: const InputDecoration(
                              labelText: 'Select Product (Optional)',
                            ),
                            items: state.products
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(
                                      '${p.productName} (\$${p.price.toStringAsFixed(2)})',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (Product? p) {
                              if (p != null) {
                                setState(() {
                                  desc = p.productName;
                                  price = p.price;
                                  descController.text = p.productName;
                                  priceController.text = p.price.toString();
                                });
                              }
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      onChanged: (v) => desc = v,
                    ),
                    TextField(
                      controller: qtyController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => qty = double.tryParse(v) ?? 1,
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => price = double.tryParse(v) ?? 0,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, {
                    'description': desc,
                    'quantity': qty,
                    'unit_price': price,
                  }),
                  child: const Text('ADD'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result['description'].isNotEmpty) {
      setState(() => _items.add(result));
    }
  }

  void _selectDate(BuildContext context, bool isInvoiceDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate ? _invoiceDate : _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isInvoiceDate) {
          _invoiceDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _saveInvoice() async {
    if (_selectedClient == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a client')));
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final data = {
      'client_id': _selectedClient!.id,
      'invoice_date': DateFormat('yyyy-MM-dd').format(_invoiceDate),
      'due_date': DateFormat('yyyy-MM-dd').format(_dueDate),
      'items': _items,
      'payment_terms': 'net_30',
    };

    final success = await ref
        .read(invoiceProvider.notifier)
        .createInvoice(data);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save invoice')));
      }
    }
  }
}
