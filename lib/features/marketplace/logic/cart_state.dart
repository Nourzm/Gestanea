import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();
  
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded(this.items);

  @override
  List<Object?> get props => [items];

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
