import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/onboarding_provider.dart';

class PreferencesStep extends ConsumerWidget {
  const PreferencesStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invoice Preferences',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 400.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 8),
          Text(
                'Choose how your invoices will look to your clients.',
                style: theme.textTheme.bodyMedium,
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .moveX(begin: -20, end: 0),
          const SizedBox(height: 32),

          _buildSelectionTitle(context, 'Primary Currency'),
          const SizedBox(height: 12),
          _buildSelectionCard(
                context: context,
                title: 'Zambian Kwacha (K)',
                subtitle: 'Recommended for local transactions',
                isSelected: onboardingState.currency == 'ZMW',
                icon: Icons.money_rounded,
                onTap: () => onboardingNotifier.updatePreferences(
                  currency: 'ZMW',
                  invoiceName: onboardingState.invoiceName,
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .moveY(begin: 10, end: 0),
          const SizedBox(height: 12),
          _buildSelectionCard(
                context: context,
                title: 'US Dollar (\$)',
                subtitle: 'Best for international clients',
                isSelected: onboardingState.currency == 'USD',
                icon: Icons.attach_money_rounded,
                onTap: () => onboardingNotifier.updatePreferences(
                  currency: 'USD',
                  invoiceName: onboardingState.invoiceName,
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .moveY(begin: 10, end: 0),

          const SizedBox(height: 32),

          _buildSelectionTitle(context, 'Document Title'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildChoiceChip(
                  context: context,
                  label: 'INVOICE',
                  isSelected: onboardingState.invoiceName == 'INVOICE',
                  onSelected: (_) => onboardingNotifier.updatePreferences(
                    currency: onboardingState.currency,
                    invoiceName: 'INVOICE',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChoiceChip(
                  context: context,
                  label: 'TAX INVOICE',
                  isSelected: onboardingState.invoiceName == 'TAX INVOICE',
                  onSelected: (_) => onboardingNotifier.updatePreferences(
                    currency: onboardingState.currency,
                    invoiceName: 'TAX INVOICE',
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildSelectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(label),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
