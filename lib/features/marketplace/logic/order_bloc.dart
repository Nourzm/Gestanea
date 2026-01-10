import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class InitializeOrder extends OrderEvent {
  final String productName;
  final String productImage;
  final String selectedColor;
  final String? selectedColorHex;
  final String selectedSize;
  final int quantity;
  final double productPrice;

  const InitializeOrder({
    required this.productName,
    required this.productImage,
    required this.selectedColor,
    this.selectedColorHex,
    required this.selectedSize,
    required this.quantity,
    required this.productPrice,
  });

  @override
  List<Object?> get props => [
    productName,
    productImage,
    selectedColor,
    selectedColorHex,
    selectedSize,
    quantity,
    productPrice,
  ];
}

class UpdateFullName extends OrderEvent {
  final String fullName;

  const UpdateFullName(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class UpdatePhone extends OrderEvent {
  final String phone;

  const UpdatePhone(this.phone);

  @override
  List<Object?> get props => [phone];
}

class UpdateAddress extends OrderEvent {
  final String address;

  const UpdateAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateCity extends OrderEvent {
  final String city;

  const UpdateCity(this.city);

  @override
  List<Object?> get props => [city];
}

class UpdateInstructions extends OrderEvent {
  final String instructions;

  const UpdateInstructions(this.instructions);

  @override
  List<Object?> get props => [instructions];
}

class SelectPaymentMethod extends OrderEvent {
  final String paymentMethod;

  const SelectPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class CalculateTotals extends OrderEvent {
  final double subtotal;

  const CalculateTotals(this.subtotal);

  @override
  List<Object?> get props => [subtotal];
}

class ValidateForm extends OrderEvent {
  const ValidateForm();
}

class PlaceOrder extends OrderEvent {
  const PlaceOrder();
}

// States
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String instructions;
  final String paymentMethod;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String productName;
  final String productImage;
  final String selectedColor;
  final String? selectedColorHex;
  final String selectedSize;
  final int quantity;
  final double productPrice;

  const OrderInitial({
    this.fullName = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.instructions = '',
    this.paymentMethod = 'cash',
    this.subtotal = 0.0,
    this.deliveryFee = 0.00,
    this.total = 0.0,
    this.productName = '',
    this.productImage = '',
    this.selectedColor = '',
    this.selectedColorHex,
    this.selectedSize = '',
    this.quantity = 1,
    this.productPrice = 0.0,
  });

  @override
  List<Object?> get props => [
    fullName,
    phone,
    address,
    city,
    instructions,
    paymentMethod,
    subtotal,
    deliveryFee,
    total,
    productName,
    productImage,
    selectedColor,
    selectedColorHex,
    selectedSize,
    quantity,
    productPrice,
  ];

  OrderInitial copyWith({
    String? fullName,
    String? phone,
    String? address,
    String? city,
    String? instructions,
    String? paymentMethod,
    double? subtotal,
    double? deliveryFee,
    double? total,
    String? productName,
    String? productImage,
    String? selectedColor,
    String? selectedColorHex,
    String? selectedSize,
    int? quantity,
    double? productPrice,
  }) {
    return OrderInitial(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      instructions: instructions ?? this.instructions,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedColorHex: selectedColorHex ?? this.selectedColorHex,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      productPrice: productPrice ?? this.productPrice,
    );
  }
}

class OrderFormValid extends OrderState {
  final OrderInitial orderData;

  const OrderFormValid(this.orderData);

  @override
  List<Object?> get props => [orderData];
}

class OrderFormInvalid extends OrderState {
  final OrderInitial orderData;
  final String errorMessage;

  const OrderFormInvalid(this.orderData, this.errorMessage);

  @override
  List<Object?> get props => [orderData, errorMessage];
}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final String orderId;

  const OrderPlaced(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderInitial()) {
    on<InitializeOrder>(_onInitializeOrder);
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdatePhone>(_onUpdatePhone);
    on<UpdateAddress>(_onUpdateAddress);
    on<UpdateCity>(_onUpdateCity);
    on<UpdateInstructions>(_onUpdateInstructions);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<CalculateTotals>(_onCalculateTotals);
    on<ValidateForm>(_onValidateForm);
    on<PlaceOrder>(_onPlaceOrder);
  }

  OrderInitial _getCurrentData() {
    final currentState = state;
    if (currentState is OrderInitial) {
      return currentState;
    } else if (currentState is OrderFormValid) {
      return currentState.orderData;
    } else if (currentState is OrderFormInvalid) {
      return currentState.orderData;
    }
    return const OrderInitial();
  }

  void _onInitializeOrder(InitializeOrder event, Emitter<OrderState> emit) {
    final currentData = _getCurrentData();
    final subtotal = event.productPrice * event.quantity;
    final deliveryFee = 500.00;
    final total = subtotal + deliveryFee;

    emit(
      currentData.copyWith(
        productName: event.productName,
        productImage: event.productImage,
        selectedColor: event.selectedColor,
        selectedColorHex: event.selectedColorHex,
        selectedSize: event.selectedSize,
        quantity: event.quantity,
        productPrice: event.productPrice,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
      ),
    );
  }

  void _onUpdateFullName(UpdateFullName event, Emitter<OrderState> emit) {
    final currentData = _getCurrentData();
    emit(currentData.copyWith(fullName: event.fullName));
  }

  void _onUpdatePhone(UpdatePhone event, Emitter<OrderState> emit) {
    final currentData = _getCurrentData();
    emit(currentData.copyWith(phone: event.phone));
  }

  void _onUpdateAddress(UpdateAddress event, Emitter<OrderState> emit) {
    final currentData = _getCurrentData();
    emit(currentData.copyWith(address: event.address));
  }

  void _onUpdateCity(UpdateCity event, Emitter<OrderState> emit) {
    final currentData = _getCurrentData();
    emit(currentData.copyWith(city: event.city));
  }

  void _onUpdateInstructions(
    UpdateInstructions event,
    Emitter<OrderState> emit,
  ) {
    final currentData = _getCurrentData();
    emit(currentData.copyWith(instructions: event.instructions));
  }

  void _onSelectPaymentMethod(
    SelectPaymentMethod event,
    Emitter<OrderState> emit,
  ) {
    final currentData = _getCurrentData();
    emit(currentData.copyWith(paymentMethod: event.paymentMethod));
  }

  void _onCalculateTotals(CalculateTotals event, Emitter<OrderState> emit) {
    final currentData = _getCurrentData();
    final deliveryFee = 500.00;
    final total = event.subtotal + deliveryFee;

    emit(
      currentData.copyWith(
        subtotal: event.subtotal,
        deliveryFee: deliveryFee,
        total: total,
      ),
    );
  }

  void _onValidateForm(ValidateForm event, Emitter<OrderState> emit) {
    final currentData = _getCurrentData();

    if (currentData.fullName.isEmpty) {
      emit(OrderFormInvalid(currentData, 'Full name is required'));
      return;
    }

    if (currentData.phone.isEmpty) {
      emit(OrderFormInvalid(currentData, 'Phone number is required'));
      return;
    }

    if (currentData.address.isEmpty) {
      emit(OrderFormInvalid(currentData, 'Address is required'));
      return;
    }

    if (currentData.city.isEmpty) {
      emit(OrderFormInvalid(currentData, 'City is required'));
      return;
    }

    emit(OrderFormValid(currentData));
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    final currentData = _getCurrentData();

    // Validate first
    if (currentData.fullName.isEmpty ||
        currentData.phone.isEmpty ||
        currentData.address.isEmpty ||
        currentData.city.isEmpty) {
      emit(OrderFormInvalid(currentData, 'Please fill in all required fields'));
      return;
    }

    emit(OrderPlacing());

    try {
      // Simulate placing order (in real app, call repository)
      await Future.delayed(const Duration(seconds: 2));

      // Generate order ID
      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      emit(OrderPlaced(orderId));
    } catch (e) {
      emit(OrderError('Failed to place order: ${e.toString()}'));
      emit(currentData);
    }
  }
}
