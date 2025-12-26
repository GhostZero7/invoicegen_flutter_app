import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/onboarding_provider.dart';

final passwordVisibilityProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

class ContactInfoStep extends ConsumerWidget {
  const ContactInfoStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Security',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 400.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 8),
          Text(
                'Set up your account credentials to access your invoices securely.',
                style: theme.textTheme.bodyMedium,
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .moveX(begin: -20, end: 0),
          const SizedBox(height: 32),

          TextField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'hello@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  onboardingNotifier.updateContactInfo(
                    email: value,
                    phone: onboardingState.phone,
                    countryCode: onboardingState.countryCode,
                    password: onboardingState.password,
                    confirmPassword: onboardingState.confirmPassword,
                  );
                },
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .moveY(begin: 10, end: 0),

          const SizedBox(height: 24),

          TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Minimum 8 characters',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => ref
                        .read(passwordVisibilityProvider.notifier)
                        .update((state) => !state),
                  ),
                ),
                obscureText: !isPasswordVisible,
                onChanged: (value) {
                  onboardingNotifier.updateContactInfo(
                    email: onboardingState.email,
                    phone: onboardingState.phone,
                    countryCode: onboardingState.countryCode,
                    password: value,
                    confirmPassword: onboardingState.confirmPassword,
                  );
                },
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .moveY(begin: 10, end: 0),

          const SizedBox(height: 24),

          TextField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                  errorText:
                      onboardingState.confirmPassword.isNotEmpty &&
                          onboardingState.password !=
                              onboardingState.confirmPassword
                      ? 'Passwords do not match'
                      : null,
                ),
                obscureText: !isPasswordVisible,
                onChanged: (value) {
                  onboardingNotifier.updateContactInfo(
                    email: onboardingState.email,
                    phone: onboardingState.phone,
                    countryCode: onboardingState.countryCode,
                    password: onboardingState.password,
                    confirmPassword: value,
                  );
                },
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .moveY(begin: 10, end: 0),

          const SizedBox(height: 24),

          IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.phone_android_rounded),
                ),
                initialCountryCode: 'ZM',
                onChanged: (phone) {
                  onboardingNotifier.updateContactInfo(
                    email: onboardingState.email,
                    phone: phone.number,
                    countryCode: phone.countryCode,
                    password: onboardingState.password,
                    confirmPassword: onboardingState.confirmPassword,
                  );
                },
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 500.ms)
              .moveY(begin: 10, end: 0),

          const SizedBox(height: 24),

          Row(
            children: [
              Icon(
                Icons.shield_rounded,
                color: theme.colorScheme.primary.withOpacity(0.5),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your account is protected with industry-standard encryption.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
        ],
      ),
    );
  }
}
