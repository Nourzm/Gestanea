import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';
import 'package:gestanea/features/marketplace/product_api_service.dart';
import 'package:gestanea/core/services/connectivity_service.dart';

// Events
abstract class MarketplaceEvent extends Equatable {
  const MarketplaceEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarketplaceData extends MarketplaceEvent {
  const LoadMarketplaceData();
}

class SearchProducts extends MarketplaceEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends MarketplaceEvent {
  final String? categoryId;

  const FilterByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

// States
abstract class MarketplaceState extends Equatable {
  const MarketplaceState();

  @override
  List<Object?> get props => [];
}

class MarketplaceInitial extends MarketplaceState {}

class MarketplaceLoading extends MarketplaceState {}

class MarketplaceLoaded extends MarketplaceState {
  final List<ProductCategoryModel> categories;
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final String? selectedCategoryId;
  final String searchQuery;

  const MarketplaceLoaded({
    required this.categories,
    required this.products,
    required this.filteredProducts,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    categories,
    products,
    filteredProducts,
    selectedCategoryId,
    searchQuery,
  ];

  MarketplaceLoaded copyWith({
    List<ProductCategoryModel>? categories,
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return MarketplaceLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MarketplaceError extends MarketplaceState {
  final String message;

  const MarketplaceError(this.message);

  @override
  List<Object?> get props => [message];
}

class MarketplaceOffline extends MarketplaceState {}

// BLoC
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  final ConnectivityService _connectivityService;

  MarketplaceBloc({ConnectivityService? connectivityService})
    : _connectivityService = connectivityService ?? ConnectivityService(),
      super(MarketplaceInitial()) {
    on<LoadMarketplaceData>(_onLoadMarketplaceData);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadMarketplaceData(
    LoadMarketplaceData event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());
    try {
      // Check connectivity first
      final isOnline = await _connectivityService.checkConnectivity();
      if (!isOnline) {
        emit(MarketplaceOffline());
        return;
      }

      // Fetch categories and products from the backend API
      final categories = await ProductApiService.getCategories();
      final products = await ProductApiService.getProducts(isAvailable: true);

      emit(
        MarketplaceLoaded(
          categories: categories,
          products: products,
          filteredProducts: products,
        ),
      );
    } catch (e) {
      // Check if it's a network error
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('socketexception') ||
          errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('unreachable')) {
        emit(MarketplaceOffline());
      } else {
        emit(
          MarketplaceError('Failed to load marketplace data: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state is MarketplaceLoaded) {
      final currentState = state as MarketplaceLoaded;
      final query = event.query.trim();

      emit(MarketplaceLoading());

      try {
        List<ProductModel> searchResults;

        if (query.isEmpty) {
          // If search is empty, fetch all available products
          searchResults = await ProductApiService.getProducts(
            isAvailable: true,
            categoryId: currentState.selectedCategoryId,
          );
        } else {
          // Use backend search API
          searchResults = await ProductApiService.getProducts(
            search: query,
            isAvailable: true,
            categoryId: currentState.selectedCategoryId,
          );
        }

        emit(
          currentState.copyWith(
            products: searchResults,
            filteredProducts: searchResults,
            searchQuery: query,
          ),
        );
      } catch (e) {
        // Check if it's a network error
        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('socketexception') ||
            errorMessage.contains('network') ||
            errorMessage.contains('connection') ||
            errorMessage.contains('unreachable')) {
          emit(MarketplaceOffline());
        } else {
          emit(MarketplaceError('Failed to search products: ${e.toString()}'));
        }
      }
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state is MarketplaceLoaded) {
      final currentState = state as MarketplaceLoaded;

      emit(MarketplaceLoading());

      try {
        // Fetch products with category filter from backend
        final products = await ProductApiService.getProducts(
          isAvailable: true,
          categoryId: event.categoryId,
          search: currentState.searchQuery.isNotEmpty
              ? currentState.searchQuery
              : null,
        );

        emit(
          currentState.copyWith(
            products: products,
            filteredProducts: products,
            selectedCategoryId: event.categoryId,
          ),
        );
      } catch (e) {
        // Check if it's a network error
        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('socketexception') ||
            errorMessage.contains('network') ||
            errorMessage.contains('connection') ||
            errorMessage.contains('unreachable')) {
          emit(MarketplaceOffline());
        } else {
          emit(MarketplaceError('Failed to filter products: ${e.toString()}'));
        }
      }
    }
  }
}
