import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/data/models/business_profile.dart';
import 'package:invoicegen_flutter_app/data/repositories/business_repository.dart';
import 'package:get_it/get_it.dart';

class BusinessState {
  final List<BusinessProfile> businesses;
  final BusinessProfile? selectedBusiness;
  final bool isLoading;
  final String? error;

  BusinessState({
    this.businesses = const [],
    this.selectedBusiness,
    this.isLoading = false,
    this.error,
  });

  BusinessState copyWith({
    List<BusinessProfile>? businesses,
    BusinessProfile? selectedBusiness,
    bool? isLoading,
    String? error,
  }) {
    return BusinessState(
      businesses: businesses ?? this.businesses,
      selectedBusiness: selectedBusiness ?? this.selectedBusiness,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BusinessNotifier extends StateNotifier<BusinessState> {
  final BusinessRepository _repository;

  BusinessNotifier(this._repository) : super(BusinessState());

  Future<void> fetchBusinesses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _repository.getBusinessProfiles();
      final List<BusinessProfile> profiles = results
          .map((json) => BusinessProfile.fromJson(json as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        businesses: profiles,
        selectedBusiness: profiles.isNotEmpty ? profiles.first : null,
        isLoading: false,
      );
    } catch (e) {
      // Check if it's a 404 error (endpoint not implemented)
      if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        // Gracefully handle missing endpoint - set empty state without error
        state = state.copyWith(
          businesses: [],
          selectedBusiness: null,
          isLoading: false,
          error: null, // Don't show error for missing endpoint
        );
      } else {
        // Show error for other types of failures
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  void selectBusiness(BusinessProfile business) {
    state = state.copyWith(selectedBusiness: business);
  }

  Future<bool> createBusiness(Map<String, dynamic> businessData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.createBusinessProfile(businessData);
      final newBusiness = BusinessProfile.fromJson(result);
      
      state = state.copyWith(
        businesses: [...state.businesses, newBusiness],
        selectedBusiness: newBusiness, // Auto-select the new business
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateBusiness(String businessId, Map<String, dynamic> businessData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.updateBusinessProfile(businessId, businessData);
      final updatedBusiness = BusinessProfile.fromJson(result);
      
      final updatedBusinesses = state.businesses.map((business) {
        return business.id == businessId ? updatedBusiness : business;
      }).toList();
      
      state = state.copyWith(
        businesses: updatedBusinesses,
        selectedBusiness: state.selectedBusiness?.id == businessId 
            ? updatedBusiness 
            : state.selectedBusiness,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteBusiness(String businessId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteBusinessProfile(businessId);
      
      final updatedBusinesses = state.businesses.where((business) => business.id != businessId).toList();
      final newSelectedBusiness = state.selectedBusiness?.id == businessId 
          ? (updatedBusinesses.isNotEmpty ? updatedBusinesses.first : null)
          : state.selectedBusiness;
      
      state = state.copyWith(
        businesses: updatedBusinesses,
        selectedBusiness: newSelectedBusiness,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final businessProvider = StateNotifierProvider<BusinessNotifier, BusinessState>(
  (ref) {
    final repository = GetIt.I<BusinessRepository>();
    return BusinessNotifier(repository)..fetchBusinesses();
  },
);
