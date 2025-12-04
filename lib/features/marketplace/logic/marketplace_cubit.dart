import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/repositories/marketplace_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'marketplace_state.dart';

class MarketplaceCubit extends Cubit<MarketplaceState> {
  final MarketplaceRepository _marketplaceRepository;

  MarketplaceCubit({MarketplaceRepository? marketplaceRepository})
      : _marketplaceRepository = marketplaceRepository ?? getIt<MarketplaceRepository>(),
        super(MarketplaceInitial()) {
    loadMarketplace();
  }

  Future<void> loadMarketplace() async {
    emit(MarketplaceLoading());
    
    final categoriesResult = await _marketplaceRepository.getCategories();
    final productsResult = await _marketplaceRepository.getAllProducts();

    if (categoriesResult.isSuccess && productsResult.isSuccess) {
      emit(MarketplaceLoaded(
        categories: categoriesResult.data ?? [],
        products: productsResult.data ?? [],
      ));
    } else {
      emit(MarketplaceError('Failed to load marketplace'));
    }
  }

  Future<void> searchProducts(String query) async {
    emit(MarketplaceLoading());
    
    final result = await _marketplaceRepository.searchProducts(query);
    final categoriesResult = await _marketplaceRepository.getCategories();

    if (result.isSuccess) {
      emit(MarketplaceLoaded(
        categories: categoriesResult.data ?? [],
        products: result.data ?? [],
      ));
    } else {
      emit(MarketplaceError(result.message ?? 'Failed to search products'));
    }
  }
}
