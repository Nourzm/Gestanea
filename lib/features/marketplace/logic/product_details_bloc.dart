import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/product_model.dart';
import 'package:gestanea/core/database/models/product_variant_model.dart';
import 'package:gestanea/core/database/models/product_spec_model.dart';
import 'package:gestanea/core/database/models/product_review_model.dart';
import 'package:gestanea/core/services/product_api_service.dart';

// Events
abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetails extends ProductDetailsEvent {
  final ProductModel product;

  const LoadProductDetails(this.product);

  @override
  List<Object?> get props => [product];
}

class SelectColor extends ProductDetailsEvent {
  final int colorIndex;

  const SelectColor(this.colorIndex);

  @override
  List<Object?> get props => [colorIndex];
}

class SelectSize extends ProductDetailsEvent {
  final int sizeIndex;

  const SelectSize(this.sizeIndex);

  @override
  List<Object?> get props => [sizeIndex];
}

class ChangeImage extends ProductDetailsEvent {
  final int imageIndex;

  const ChangeImage(this.imageIndex);

  @override
  List<Object?> get props => [imageIndex];
}

class IncrementQuantity extends ProductDetailsEvent {
  const IncrementQuantity();
}

class DecrementQuantity extends ProductDetailsEvent {
  const DecrementQuantity();
}

class AddToCart extends ProductDetailsEvent {
  const AddToCart();
}

// States
abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;
  final List<ProductVariantModel> colorVariants;
  final List<ProductVariantModel> sizeVariants;
  final List<ProductSpecModel> specs;
  final List<ProductReviewModel> reviews;
  final int selectedColorIndex;
  final int selectedSizeIndex;
  final int currentImageIndex;
  final int quantity;

  const ProductDetailsLoaded({
    required this.product,
    required this.colorVariants,
    required this.sizeVariants,
    required this.specs,
    required this.reviews,
    this.selectedColorIndex = 0,
    this.selectedSizeIndex = 0,
    this.currentImageIndex = 0,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [
    product,
    colorVariants,
    sizeVariants,
    specs,
    reviews,
    selectedColorIndex,
    selectedSizeIndex,
    currentImageIndex,
    quantity,
  ];

  ProductDetailsLoaded copyWith({
    ProductModel? product,
    List<ProductVariantModel>? colorVariants,
    List<ProductVariantModel>? sizeVariants,
    List<ProductSpecModel>? specs,
    List<ProductReviewModel>? reviews,
    int? selectedColorIndex,
    int? selectedSizeIndex,
    int? currentImageIndex,
    int? quantity,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      colorVariants: colorVariants ?? this.colorVariants,
      sizeVariants: sizeVariants ?? this.sizeVariants,
      specs: specs ?? this.specs,
      reviews: reviews ?? this.reviews,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      quantity: quantity ?? this.quantity,
    );
  }
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductAddedToCart extends ProductDetailsState {
  final ProductModel product;
  final int quantity;

  const ProductAddedToCart({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

// BLoC
class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<SelectColor>(_onSelectColor);
    on<SelectSize>(_onSelectSize);
    on<ChangeImage>(_onChangeImage);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      // Fetch data from API instead of mock data
      final allVariants = await ProductApiService.getProductVariants(
        event.product.id,
      );
      final colorVariants = allVariants
          .where((v) => v.type == 'color')
          .toList();
      final sizeVariants = allVariants.where((v) => v.type == 'size').toList();
      final specs = await ProductApiService.getProductSpecs(event.product.id);
      final reviews = await ProductApiService.getProductReviews(
        event.product.id,
      );

      emit(
        ProductDetailsLoaded(
          product: event.product,
          colorVariants: colorVariants,
          sizeVariants: sizeVariants,
          specs: specs,
          reviews: reviews,
        ),
      );
    } catch (e) {
      emit(
        ProductDetailsError('Failed to load product details: ${e.toString()}'),
      );
    }
  }

  void _onSelectColor(SelectColor event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(currentState.copyWith(selectedColorIndex: event.colorIndex));
    }
  }

  void _onSelectSize(SelectSize event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(currentState.copyWith(selectedSizeIndex: event.sizeIndex));
    }
  }

  void _onChangeImage(ChangeImage event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(currentState.copyWith(currentImageIndex: event.imageIndex));
    }
  }

  void _onIncrementQuantity(
    IncrementQuantity event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(currentState.copyWith(quantity: currentState.quantity + 1));
    }
  }

  void _onDecrementQuantity(
    DecrementQuantity event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      if (currentState.quantity > 1) {
        emit(currentState.copyWith(quantity: currentState.quantity - 1));
      }
    }
  }

  void _onAddToCart(AddToCart event, Emitter<ProductDetailsState> emit) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      // In a real app, you would add to cart here via a repository
      emit(
        ProductAddedToCart(
          product: currentState.product,
          quantity: currentState.quantity,
        ),
      );
      // Return to loaded state
      emit(currentState);
    }
  }
}
