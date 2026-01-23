import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/business_provider.dart';

class CreateBusinessScreen extends ConsumerStatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  ConsumerState<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends ConsumerState<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _invoicePrefixController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedBusinessType = 'SOLE_PROPRIETOR';
  String _selectedCurrency = 'USD';
  bool _isLoading = false;

  final List<Map<String, String>> _businessTypes = [
    {'value': 'SOLE_PROPRIETOR', 'label': 'Sole Proprietor'},
    {'value': 'LLC', 'label': 'Limited Liability Company (LLC)'},
    {'value': 'CORPORATION', 'label': 'Corporation'},
    {'value': 'PARTNERSHIP', 'label': 'Partnership'},
    {'value': 'OTHER', 'label': 'Other'},
  ];

  final List<Map<String, String>> _currencies = [
    {'value': 'USD', 'label': 'USD - US Dollar'},
    {'value': 'EUR', 'label': 'EUR - Euro'},
    {'value': 'GBP', 'label': 'GBP - British Pound'},
    {'value': 'CAD', 'label': 'CAD - Canadian Dollar'},
    {'value': 'AUD', 'label': 'AUD - Australian Dollar'},
  ];

  @override
  void initState() {
    super.initState();
    _invoicePrefixController.text = 'INV';
    _paymentTermsController.text = 'Net 30';
    _countryController.text = 'United States';
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _taxNumberController.dispose();
    _registrationNumberController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _invoicePrefixController.dispose();
    _paymentTermsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.white,
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
                'Create Business Profile',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0A0E27) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
          ),

          // Form Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    _buildSectionHeader('Basic Information', isDark),
                    const SizedBox(height: 16),
                    _buildFormCard(isDark, [
                      _buildTextField(
                        controller: _businessNameController,
                        label: 'Business Name',
                        hint: 'Enter your business name',
                        icon: Icons.business,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Business name is required';
                          }
                          return null;
                        },
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: _selectedBusinessType,
                        label: 'Business Type',
                        icon: Icons.category,
                        items: _businessTypes,
                        onChanged: (value) {
                          setState(() {
                            _selectedBusinessType = value!;
                          });
                        },
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Business Email',
                        hint: 'business@example.com',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              hint: '+1 (555) 123-4567',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _websiteController,
                              label: 'Website',
                              hint: 'www.example.com',
                              icon: Icons.language,
                              keyboardType: TextInputType.url,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Tax & Registration Section
                    _buildSectionHeader('Tax & Registration', isDark),
                    const SizedBox(height: 16),
                    _buildFormCard(isDark, [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _taxNumberController,
                              label: 'Tax ID / EIN',
                              hint: '12-3456789',
                              icon: Icons.receipt_long,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _registrationNumberController,
                              label: 'Registration Number',
                              hint: 'REG123456',
                              icon: Icons.badge,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Address Section
                    _buildSectionHeader('Business Address', isDark),
                    const SizedBox(height: 16),
                    _buildFormCard(isDark, [
                      _buildTextField(
                        controller: _streetController,
                        label: 'Street Address',
                        hint: '123 Main Street',
                        icon: Icons.location_on,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _cityController,
                              label: 'City',
                              hint: 'New York',
                              icon: Icons.location_city,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _stateController,
                              label: 'State',
                              hint: 'NY',
                              icon: Icons.map,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _postalCodeController,
                              label: 'Postal Code',
                              hint: '10001',
                              icon: Icons.markunread_mailbox,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _countryController,
                              label: 'Country',
                              hint: 'United States',
                              icon: Icons.public,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Invoice Settings Section
                    _buildSectionHeader('Invoice Settings', isDark),
                    const SizedBox(height: 16),
                    _buildFormCard(isDark, [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _invoicePrefixController,
                              label: 'Invoice Prefix',
                              hint: 'INV',
                              icon: Icons.tag,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Invoice prefix is required';
                                }
                                return null;
                              },
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownField(
                              value: _selectedCurrency,
                              label: 'Default Currency',
                              icon: Icons.attach_money,
                              items: _currencies,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value!;
                                });
                              },
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _paymentTermsController,
                        label: 'Default Payment Terms',
                        hint: 'Net 30',
                        icon: Icons.schedule,
                        isDark: isDark,
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // Notes Section
                    _buildSectionHeader('Additional Notes', isDark),
                    const SizedBox(height: 16),
                    _buildFormCard(isDark, [
                      _buildTextField(
                        controller: _notesController,
                        label: 'Notes',
                        hint: 'Any additional information about your business...',
                        icon: Icons.note,
                        maxLines: 3,
                        isDark: isDark,
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createBusiness,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Create Business Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildFormCard(bool isDark, List<Widget> children) {
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[500],
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<Map<String, String>> items,
    required void Function(String?) onChanged,
    required bool isDark,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
      dropdownColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(
            item['label']!,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
    );
  }

  Future<void> _createBusiness() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final businessData = {
        'business_name': _businessNameController.text.trim(),
        'business_type': _selectedBusinessType,
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        'website': _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
        'tax_number': _taxNumberController.text.trim().isEmpty ? null : _taxNumberController.text.trim(),
        'registration_number': _registrationNumberController.text.trim().isEmpty ? null : _registrationNumberController.text.trim(),
        'address': {
          'street': _streetController.text.trim().isEmpty ? null : _streetController.text.trim(),
          'city': _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
          'state': _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
          'postal_code': _postalCodeController.text.trim().isEmpty ? null : _postalCodeController.text.trim(),
          'country': _countryController.text.trim().isEmpty ? null : _countryController.text.trim(),
        },
        'invoice_prefix': _invoicePrefixController.text.trim(),
        'currency': _selectedCurrency,
        'payment_terms_default': _paymentTermsController.text.trim(),
        'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      };

      final success = await ref.read(businessProvider.notifier).createBusiness(businessData);

      if (success) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Business profile created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create business profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}