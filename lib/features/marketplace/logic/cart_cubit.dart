import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/models/cart_item.dart';
import 'package:gestanea/core/repositories/marketplace_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final MarketplaceRepository _marketplaceRepository;
  final UserRepository _userRepository;

  CartCubit({
    MarketplaceRepository? marketplaceRepository,
    UserRepository? userRepository,
  })  : _marketplaceRepository = marketplaceRepository ?? getIt<MarketplaceRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(CartInitial()) {
    loadCart();
  }

  Future<void> loadCart() async {
    emit(CartLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(CartError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final result = await _marketplaceRepository.getCartItems(userResult.data!.id);
    
    if (result.isSuccess) {
      emit(CartLoaded(result.data ?? []));
    } else {
      emit(CartError(result.message ?? 'Failed to load cart'));
    }
  }

  Future<void> addToCart(CartItem item) async {
    final result = await _marketplaceRepository.addToCart(item);
    
    if (result.isSuccess) {
      await loadCart();
    } else {
      emit(CartError(result.message ?? 'Failed to add to cart'));
    }
  }

  Future<void> removeFromCart(String id) async {
    final result = await _marketplaceRepository.removeFromCart(id);
    
    if (result.isSuccess) {
      await loadCart();
    } else {
      emit(CartError(result.message ?? 'Failed to remove from cart'));
    }
  }

  Future<void> clearCart() async {
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) return;

    final result = await _marketplaceRepository.clearCart(userResult.data!.id);
    
    if (result.isSuccess) {
      await loadCart();
    }
  }
}
