# Create Invoice Screen - Missing Methods

The create_invoice_screen.dart file is missing several critical methods. Add these at the end of the `_CreateInvoiceScreenState` class (before the closing brace):

```dart
  Future<void> _selectDate(BuildContext context, bool isInvoiceDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate ? _invoiceDate : _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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

  Future<void> _saveInvoice() async {
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client')),
      );
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    final businessState = ref.read(businessProvider);
    if (businessState.selectedBusiness == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No business profile selected')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final invoiceData = {
        'business_id': businessState.selectedBusiness!.id,
        'client_id': _selectedClient!.id,
        'invoice_date': _invoiceDate.toIso8601String(),
        'due_date': _dueDate.toIso8601String(),
        'payment_terms': 'Net 30',
        'items': _items,
        'discount_type': _discountType,
        'discount_value': double.tryParse(_discountController.text) ?? 0.0,
        'shipping_amount': double.tryParse(_shippingController.text) ?? 0.0,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
        'payment_instructions': _paymentInstructionsController.text.isEmpty
            ? null
            : _paymentInstructionsController.text,
      };

      await ref.read(invoiceProvider.notifier).createInvoice(invoiceData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
```

## Key Issues Found:
1. `_selectClient` method exists but `_addItem` is incomplete
2. `_selectDate` method is missing
3. `_saveInvoice` method is missing
4. No inline client/item creation

## Solution:
Add the above methods to complete the functionality.
