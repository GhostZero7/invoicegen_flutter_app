import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Branding/Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 80,
              color: theme.colorScheme.primary,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),

          const SizedBox(height: 48),

          // Headline
          Text(
                'invoiceGEN',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: -1,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .moveY(begin: 20, end: 0),

          const SizedBox(height: 16),

          // Subtext
          Text(
                'Effortless invoicing for modern businesses. Create, manage, and track your documents with professional ease.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.5,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 600.ms)
              .moveY(begin: 20, end: 0),
        ],
      ),
    );
  }
}
