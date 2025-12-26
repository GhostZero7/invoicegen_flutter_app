import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/data/datasources/remote/api_service.dart';
import 'package:get_it/get_it.dart';

class OnboardingState {
  final int currentPage;
  final String businessName;
  final String email;
  final String phone;
  final String countryCode;
  final String password;
  final String confirmPassword;
  final String otp;
  final String currency;
  final String invoiceName;
  final bool isCompleted;

  const OnboardingState({
    this.currentPage = 0,
    this.businessName = '',
    this.email = '',
    this.phone = '',
    this.countryCode = '+260',
    this.password = '',
    this.confirmPassword = '',
    this.otp = '',
    this.currency = 'ZMW',
    this.invoiceName = 'INVOICE',
    this.isCompleted = false,
  });

  bool get isBusinessStepValid => businessName.isNotEmpty;
  bool get isContactStepValid =>
      email.isNotEmpty &&
      email.contains('@') &&
      phone.isNotEmpty &&
      password.isNotEmpty &&
      password.length >= 8 &&
      password == confirmPassword;
  bool get isOtpStepValid =>
      otp.length == 6; // Simulation: any 6 digit code for now

  OnboardingState copyWith({
    int? currentPage,
    String? businessName,
    String? email,
    String? phone,
    String? countryCode,
    String? password,
    String? confirmPassword,
    String? otp,
    String? currency,
    String? invoiceName,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otp: otp ?? this.otp,
      currency: currency ?? this.currency,
      invoiceName: invoiceName ?? this.invoiceName,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final ApiService _apiService;

  OnboardingNotifier(this._apiService) : super(const OnboardingState());

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void updateBusinessDetails({required String name}) {
    state = state.copyWith(businessName: name);
  }

  void updateContactInfo({
    required String email,
    required String phone,
    required String countryCode,
    required String password,
    required String confirmPassword,
  }) {
    state = state.copyWith(
      email: email,
      phone: phone,
      countryCode: countryCode,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  Future<bool> requestVerification() async {
    try {
      await _apiService.requestVerification(state.email);
      return true;
    } catch (e) {
      print('Failed to request verification: $e');
      return false;
    }
  }

  Future<bool> verifyOtp() async {
    try {
      await _apiService.verifyEmail(state.email, state.otp);
      return true;
    } catch (e) {
      print('Failed to verify OTP: $e');
      return false;
    }
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  void updatePreferences({
    required String currency,
    required String invoiceName,
  }) {
    state = state.copyWith(currency: currency, invoiceName: invoiceName);
  }

  void completeOnboarding() {
    state = state.copyWith(isCompleted: true);
  }

  void resetOnboarding() {
    state = const OnboardingState();
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
      return OnboardingNotifier(GetIt.I<ApiService>());
    });
