import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:invoicegen_flutter_app/data/models/product.dart';
import 'package:invoicegen_flutter_app/data/repositories/product_repository.dart';

// State class
class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? error;

  ProductState({this.products = const [], this.isLoading = false, this.error});

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier class
class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repository;

  ProductNotifier(this._repository) : super(ProductState());

  Future<void> fetchProducts({String? businessId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _repository.getProducts(businessId: businessId);
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newProduct = await _repository.createProduct(data);
      state = state.copyWith(
        products: [...state.products, newProduct],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

// Provider
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  return ProductNotifier(GetIt.I<ProductRepository>());
});
