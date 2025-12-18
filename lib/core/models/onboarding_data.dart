class OnboardingData {
  String fullName;
  String businessName;
  String email;
  String phone;
  String password;
  String confirmPassword;
  String? country;
  String? currency;
  String? taxId;

  OnboardingData({
    this.fullName = '',
    this.businessName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.country,
    this.currency,
    this.taxId,
  });

  // Validation methods
  String? validateFullName() {
    if (fullName.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (fullName.trim().split(' ').length < 2) {
      return 'Please enter your first and last name';
    }
    return null;
  }

  String? validateBusinessName() {
    if (businessName.trim().isEmpty) {
      return 'Please enter your business name';
    }
    return null;
  }

  String? validateEmail() {
    if (email.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhone() {
    // Phone is optional, so only validate if not empty
    if (phone.trim().isNotEmpty) {
      if (phone.trim().length < 10) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? validatePassword() {
    if (password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? validateConfirmPassword() {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Get first and last name from full name
  String get firstName {
    final parts = fullName.trim().split(' ');
    return parts.first;
  }

  String get lastName {
    final parts = fullName.trim().split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    return '';
  }

  // Convert to registration request
  Map<String, dynamic> toRegistrationRequest() {
    return {
      'email': email.trim(),
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone.trim().isEmpty ? null : phone.trim(),
    };
  }
}
