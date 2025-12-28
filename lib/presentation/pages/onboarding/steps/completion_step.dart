import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/onboarding_provider.dart';

class CompletionStep extends ConsumerWidget {
  const CompletionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Animation/Icon
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

              Icon(
                    Icons.check_circle_rounded,
                    size: 100,
                    color: theme.colorScheme.primary,
                  )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .scale(delay: 200.ms, duration: 400.ms),
            ],
          ),

          const SizedBox(height: 48),

          Text(
                'You\'re all set!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .moveY(begin: 20, end: 0),

          const SizedBox(height: 16),

          Text(
                'Your professional invoicing profile is ready. You can now start creating invoices and getting paid faster.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms)
              .moveY(begin: 20, end: 0),

          const SizedBox(height: 48),

          ElevatedButton(
                onPressed: () async {
                  final success = await onboardingNotifier.register();
                  if (success) {
                    onboardingNotifier.completeOnboarding();
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to create account. Please try again.',
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
                style:
                    ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 1000.ms)
              .scale(begin: const Offset(0.9, 0.9)),
        ],
      ),
    );
  }
}
