import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/onboarding_provider.dart';

class VerificationStep extends ConsumerStatefulWidget {
  const VerificationStep({super.key});

  @override
  ConsumerState<VerificationStep> createState() => _VerificationStepState();
}

class _VerificationStepState extends ConsumerState<VerificationStep> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _updateOtp() {
    final otp = _controllers.map((c) => c.text).join();
    ref.read(onboardingProvider.notifier).updateOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify Email',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 400.ms).moveX(begin: -20, end: 0),
          const SizedBox(height: 8),
          Text(
                'We\'ve sent a 6-digit verification code to ${onboardingState.email}. Please enter it below.',
                style: theme.textTheme.bodyMedium,
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .moveX(begin: -20, end: 0),
          const SizedBox(height: 32),

          Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        _updateOtp();
                      },
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .moveY(begin: 10, end: 0),

          const SizedBox(height: 24),

          Center(
            child: TextButton(
              onPressed: () async {
                await onboardingNotifier.requestVerification();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification code resent')),
                  );
                }
              },
              child: const Text('Didn\'t receive a code? Resend'),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

          const SizedBox(height: 32),

          Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Verification ensures your account is secure and tied to a valid email address.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 500.ms)
              .scale(begin: const Offset(0.95, 0.95)),
        ],
      ),
    );
  }
}
