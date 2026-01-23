import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/presentation/cubit/theme_cubit.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Settings state
  String _selectedCurrency = 'USD';
  String _selectedTaxRate = '10';
  String _invoicePrefix = 'INV';
  bool _autoSaveEnabled = true;
  bool _notificationsEnabled = true;
  bool _emailRemindersEnabled = false;
  int _reminderDays = 3;

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'INR'];
  final List<String> _taxRates = ['0', '5', '10', '15', '18', '20', '25'];
  final List<int> _reminderDayOptions = [1, 3, 5, 7, 14];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Settings
            _buildSectionHeader('INVOICE SETTINGS', isDark),
            const SizedBox(height: 12),
            _buildCard(
              isDark,
              [
                _buildDropdownSetting(
                  'Default Currency',
                  _selectedCurrency,
                  _currencies,
                  Icons.attach_money,
                  Colors.green,
                  (value) {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                  },
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildDropdownSetting(
                  'Default Tax Rate (%)',
                  _selectedTaxRate,
                  _taxRates,
                  Icons.percent,
                  Colors.blue,
                  (value) {
                    setState(() {
                      _selectedTaxRate = value!;
                    });
                  },
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildTextFieldSetting(
                  'Invoice Number Prefix',
                  _invoicePrefix,
                  Icons.tag,
                  Colors.purple,
                  (value) {
                    setState(() {
                      _invoicePrefix = value;
                    });
                  },
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // App Preferences
            _buildSectionHeader('APP PREFERENCES', isDark),
            const SizedBox(height: 12),
            _buildCard(
              isDark,
              [
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    return _buildSwitchSetting(
                      'Dark Theme',
                      'Enable dark mode',
                      Icons.dark_mode_outlined,
                      Colors.indigo,
                      themeState.isDarkMode,
                      (value) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      isDark,
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSwitchSetting(
                  'Auto-Save',
                  'Automatically save drafts',
                  Icons.save_outlined,
                  Colors.orange,
                  _autoSaveEnabled,
                  (value) {
                    setState(() {
                      _autoSaveEnabled = value;
                    });
                  },
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Notifications
            _buildSectionHeader('NOTIFICATIONS', isDark),
            const SizedBox(height: 12),
            _buildCard(
              isDark,
              [
                _buildSwitchSetting(
                  'Push Notifications',
                  'Receive app notifications',
                  Icons.notifications_outlined,
                  Colors.red,
                  _notificationsEnabled,
                  (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildSwitchSetting(
                  'Email Reminders',
                  'Send payment reminders via email',
                  Icons.email_outlined,
                  Colors.blue,
                  _emailRemindersEnabled,
                  (value) {
                    setState(() {
                      _emailRemindersEnabled = value;
                    });
                  },
                  isDark,
                ),
                if (_emailRemindersEnabled) ...[
                  const SizedBox(height: 16),
                  _buildDropdownSetting(
                    'Reminder Days Before Due',
                    _reminderDays.toString(),
                    _reminderDayOptions.map((e) => e.toString()).toList(),
                    Icons.calendar_today_outlined,
                    Colors.teal,
                    (value) {
                      setState(() {
                        _reminderDays = int.parse(value!);
                      });
                    },
                    isDark,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Data & Privacy
            _buildSectionHeader('DATA & PRIVACY', isDark),
            const SizedBox(height: 12),
            _buildCard(
              isDark,
              [
                _buildActionSetting(
                  'Export Data',
                  'Download all your data',
                  Icons.download_outlined,
                  Colors.green,
                  () => _showComingSoon(context),
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildActionSetting(
                  'Clear Cache',
                  'Free up storage space',
                  Icons.cleaning_services_outlined,
                  Colors.orange,
                  () => _showClearCacheDialog(context, isDark),
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildActionSetting(
                  'Delete Account',
                  'Permanently delete your account',
                  Icons.delete_forever_outlined,
                  Colors.red,
                  () => _showDeleteAccountDialog(context, isDark),
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // About
            _buildSectionHeader('ABOUT', isDark),
            const SizedBox(height: 12),
            _buildCard(
              isDark,
              [
                _buildActionSetting(
                  'Terms of Service',
                  'Read our terms',
                  Icons.description_outlined,
                  Colors.blue,
                  () => _showComingSoon(context),
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildActionSetting(
                  'Privacy Policy',
                  'Read our privacy policy',
                  Icons.privacy_tip_outlined,
                  Colors.purple,
                  () => _showComingSoon(context),
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildInfoSetting(
                  'App Version',
                  '1.0.0',
                  Icons.info_outline,
                  Colors.grey,
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _saveSettings(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
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

  Widget _buildCard(bool isDark, List<Widget> children) {
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
        children: children,
      ),
    );
  }

  Widget _buildDropdownSetting(
    String label,
    String value,
    List<String> options,
    IconData icon,
    Color iconColor,
    ValueChanged<String?> onChanged,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0A0E27) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            underline: const SizedBox(),
            isDense: true,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            dropdownColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldSetting(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    ValueChanged<String> onChanged,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
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
              const SizedBox(height: 4),
              TextField(
                controller: TextEditingController(text: value),
                onChanged: onChanged,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    bool value,
    ValueChanged<bool> onChanged,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
          activeTrackColor: Colors.blue.withValues(alpha: 0.3),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSetting(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _saveSettings(BuildContext context) {
    // TODO: Implement save settings to backend/local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon')),
    );
  }

  void _showClearCacheDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Clear Cache',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'This will clear all cached data. Are you sure?',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
