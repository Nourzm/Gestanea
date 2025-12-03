import 'package:flutter_bloc/flutter_bloc.dart';

enum QuantityEvent { increment, decrement }

class ProductQuantityBloc extends Bloc<QuantityEvent, int> {
  ProductQuantityBloc() : super(1) {
    on<QuantityEvent>((event, emit) {
      switch (event) {
        case QuantityEvent.increment:
          emit(state + 1);
          break;
        case QuantityEvent.decrement:
          if (state > 1) {
            emit(state - 1);
          }
          break;
      }
    });
  }
}
