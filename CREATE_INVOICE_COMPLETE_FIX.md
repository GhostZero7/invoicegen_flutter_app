# Create Invoice Screen - Complete Fix

## Issues Found:
1. ❌ Client selection not working - `_selectClient` method exists but incomplete
2. ❌ Item selection not working - `_addItem` method incomplete  
3. ❌ Missing `_selectDate` method
4. ❌ Missing `_saveInvoice` method
5. ❌ No inline client creation option
6. ❌ No inline item creation option

## Solution:

The `create_invoice_screen.dart` file appears to be truncated. The methods `_selectClient` and `_addItem` are partially implemented but the file ends abruptly.

### Required Actions:

1. **Complete the file** - The file should end around line 912 but methods are incomplete
2. **Add missing methods** - `_selectDate` and `_saveInvoice` are completely missing
3. **Add inline creation** - Allow creating clients and items on-the-fly

### Quick Fix:

Since the file is very large and partially corrupted, I recommend:

**Option 1: Add the missing methods at the end of the class**

Add these methods before the final closing brace `}` of `_CreateInvoiceScreenState`:

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

**Option 2: For inline client/item creation**

This requires more extensive changes. I'll create a separate simplified create invoice screen that includes inline creation.

## Status:
- ⏳ Investigating file corruption
- ⏳ Need to complete missing methods
- ⏳ Need to add inline creation features

## Next Steps:
1. Check if the file is complete by counting lines
2. Add missing methods
3. Test client selection
4. Test item selection
5. Add inline creation dialogs
