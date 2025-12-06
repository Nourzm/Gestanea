import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_category_model.dart';
import '../data/datasources/mock_marketplace_data.dart';

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

// BLoC
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc() : super(MarketplaceInitial()) {
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
      final categories = MockMarketplaceData.getCategories();
      final products = MockMarketplaceData.getProducts();

      emit(
        MarketplaceLoaded(
          categories: categories,
          products: products,
          filteredProducts: products,
        ),
      );
    } catch (e) {
      emit(
        MarketplaceError('Failed to load marketplace data: ${e.toString()}'),
      );
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<MarketplaceState> emit) {
    if (state is MarketplaceLoaded) {
      final currentState = state as MarketplaceLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredProducts: _filterByCategory(
              currentState.products,
              currentState.selectedCategoryId,
            ),
            searchQuery: query,
          ),
        );
        return;
      }

      final searchResults = currentState.products.where((product) {
        return product.productName.toLowerCase().contains(query) ||
            (product.description?.toLowerCase().contains(query) ?? false);
      }).toList();

      final filtered = _filterByCategory(
        searchResults,
        currentState.selectedCategoryId,
      );

      emit(
        currentState.copyWith(filteredProducts: filtered, searchQuery: query),
      );
    }
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<MarketplaceState> emit,
  ) {
    if (state is MarketplaceLoaded) {
      final currentState = state as MarketplaceLoaded;

      List<ProductModel> baseProducts = currentState.products;

      if (currentState.searchQuery.isNotEmpty) {
        final query = currentState.searchQuery.toLowerCase();
        baseProducts = baseProducts.where((product) {
          return product.productName.toLowerCase().contains(query) ||
              (product.description?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      final filtered = _filterByCategory(baseProducts, event.categoryId);

      emit(
        currentState.copyWith(
          filteredProducts: filtered,
          selectedCategoryId: event.categoryId,
        ),
      );
    }
  }

  List<ProductModel> _filterByCategory(
    List<ProductModel> products,
    String? categoryId,
  ) {
    if (categoryId == null || categoryId.isEmpty) {
      return products;
    }
    return products.where((p) => p.categoryId == categoryId).toList();
  }
}
