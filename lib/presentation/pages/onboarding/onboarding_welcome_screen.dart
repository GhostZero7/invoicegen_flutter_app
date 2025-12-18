import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicegen_flutter_app/presentation/cubit/theme_cubit.dart';
import 'package:invoicegen_flutter_app/core/models/onboarding_data.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/onboarding_step1_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/auth/login_screen.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // App Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 16),

              // App Name
              Text('InvoiceGEN', style: Theme.of(context).textTheme.titleLarge),

              const SizedBox(height: 40),

              // Welcome Text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayMedium,
                  children: [
                    const TextSpan(text: 'Welcome to\n'),
                    TextSpan(
                      text: 'InvoiceGEN',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Create professional invoices in seconds and keep your business organized.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              // Features List
              _FeatureCard(
                icon: Icons.bolt,
                title: 'Fast invoice creation',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.people,
                title: 'Client & payment tracking',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.description,
                title: 'Tax-ready records',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.attach_money,
                title: 'Get paid faster',
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              Text(
                'Send invoices instantly and stay on top of your cash flow.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OnboardingStep1Screen(data: OnboardingData()),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ),

              const SizedBox(height: 16),

              // Already have account
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  'I already have an account',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '© InvoiceGEN',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
