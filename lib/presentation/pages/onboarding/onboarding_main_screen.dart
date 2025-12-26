import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/onboarding_provider.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/steps/welcome_step.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/steps/business_details_step.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/steps/contact_info_step.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/steps/preferences_step.dart';
import 'package:invoicegen_flutter_app/presentation/pages/onboarding/steps/completion_step.dart';

import 'package:invoicegen_flutter_app/presentation/pages/onboarding/steps/verification_step.dart';

class OnboardingMainScreen extends ConsumerStatefulWidget {
  const OnboardingMainScreen({super.key});

  @override
  ConsumerState<OnboardingMainScreen> createState() =>
      _OnboardingMainScreenState();
}

class _OnboardingMainScreenState extends ConsumerState<OnboardingMainScreen> {
  late PageController _pageController;
  static const int _totalSteps = 6;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    final onboardingState = ref.read(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final currentPage = onboardingState.currentPage;

    String? errorMessage;

    if (currentPage == 1 && !onboardingState.isBusinessStepValid) {
      errorMessage = 'Please enter your business name to proceed.';
    } else if (currentPage == 2) {
      if (!onboardingState.isContactStepValid) {
        if (onboardingState.email.isEmpty ||
            !onboardingState.email.contains('@')) {
          errorMessage = 'Please enter a valid email address.';
        } else if (onboardingState.phone.isEmpty) {
          errorMessage = 'Please enter your phone number.';
        } else if (onboardingState.password.length < 8) {
          errorMessage = 'Password must be at least 8 characters.';
        } else if (onboardingState.password !=
            onboardingState.confirmPassword) {
          errorMessage = 'Passwords do not match.';
        }
      } else {
        // Validating -> Sending OTP
        // Show loading or just wait
        final success = await onboardingNotifier.requestVerification();
        if (!success) {
          errorMessage = 'Failed to send verification code. Please try again.';
        }
      }
    } else if (currentPage == 3 && !onboardingState.isOtpStepValid) {
      errorMessage =
          'Please enter the 6-digit verification code sent to your email.';
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (currentPage < _totalSteps - 1) {
      _pageController.nextPage(duration: 400.ms, curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Thin Progress Bar
            _buildProgressBar(onboardingState.currentPage),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(onboardingProvider.notifier).setPage(index);
                },
                children: const [
                  WelcomeStep(),
                  BusinessDetailsStep(),
                  ContactInfoStep(),
                  VerificationStep(),
                  PreferencesStep(),
                  CompletionStep(),
                ],
              ),
            ),

            // Bottom Navigation Area
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _totalSteps,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      expansionFactor: 4,
                      spacing: 8,
                      dotColor: theme.colorScheme.primary.withOpacity(0.2),
                      activeDotColor: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (onboardingState.currentPage < _totalSteps - 1)
                    ElevatedButton(
                          onPressed: _nextPage,
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
                                shadowColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int currentPage) {
    final theme = Theme.of(context);
    final progress = (currentPage + 1) / _totalSteps;

    return Container(
      height: 4,
      width: double.infinity,
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: 400.ms,
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width * progress,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
