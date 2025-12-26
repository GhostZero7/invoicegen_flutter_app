import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/onboarding_provider.dart';

class BusinessDetailsStep extends ConsumerWidget {
  const BusinessDetailsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Details',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 400.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 8),
          Text(
                'Tell us a bit about your business to personalize your account.',
                style: theme.textTheme.bodyMedium,
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .moveX(begin: -20, end: 0),
          const SizedBox(height: 32),

          FormBuilder(
            key: GlobalKey<FormBuilderState>(),
            onChanged: () {
              // Update state locally or on field change
            },
            child: Column(
              children: [
                FormBuilderTextField(
                      name: 'business_name',
                      decoration: const InputDecoration(
                        labelText: 'Business Name',
                        hintText: 'e.g. Acme Corp',
                        prefixIcon: Icon(Icons.business_rounded),
                      ),
                      onChanged: (value) {
                        onboardingNotifier.updateBusinessDetails(
                          name: value ?? '',
                        );
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                      ]),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms)
                    .moveY(begin: 10, end: 0),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Feature Card placeholder as per requirements: "Show one feature card at a time"
          Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.speed_rounded,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lightning Fast setup',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Get your business up and running in under a minute.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }
}
