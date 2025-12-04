import 'package:equatable/equatable.dart';
import 'package:gestanea/core/models/product_category.dart';
import 'package:gestanea/core/models/product.dart';

abstract class MarketplaceState extends Equatable {
  const MarketplaceState();
  
  @override
  List<Object?> get props => [];
}

class MarketplaceInitial extends MarketplaceState {}

class MarketplaceLoading extends MarketplaceState {}

class MarketplaceLoaded extends MarketplaceState {
  final List<ProductCategory> categories;
  final List<Product> products;

  const MarketplaceLoaded({this.categories = const [], this.products = const []});

  @override
  List<Object?> get props => [categories, products];
}

class MarketplaceError extends MarketplaceState {
  final String message;

  const MarketplaceError(this.message);

  @override
  List<Object?> get props => [message];
}
