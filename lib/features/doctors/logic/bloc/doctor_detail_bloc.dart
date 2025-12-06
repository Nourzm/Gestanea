import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/doctors/logic/utils/map_helper.dart'
    as map_helper;
import 'package:gestanea/features/doctors/logic/utils/phone_helper.dart'
    as phone_helper;
import 'doctor_detail_event.dart';
import 'doctor_detail_state.dart';

class DoctorDetailBloc extends Bloc<DoctorDetailEvent, DoctorDetailState> {
  DoctorDetailBloc() : super(DoctorDetailInitial()) {
    on<OpenDirections>(_onOpenDirections);
    on<MakePhoneCall>(_onMakePhoneCall);
  }

  Future<void> _onOpenDirections(
    OpenDirections event,
    Emitter<DoctorDetailState> emit,
  ) async {
    emit(DoctorDetailActionInProgress());
    final success = await map_helper.openDirections(
      event.latitude,
      event.longitude,
    );

    if (success) {
      emit(DoctorDetailActionSuccess('Directions opened'));
    } else {
      emit(DoctorDetailActionFailure('Could not open maps'));
    }
  }

  Future<void> _onMakePhoneCall(
    MakePhoneCall event,
    Emitter<DoctorDetailState> emit,
  ) async {
    if (event.phoneNumber.isEmpty) {
      emit(DoctorDetailActionFailure('Phone number not available'));
      return;
    }

    emit(DoctorDetailActionInProgress());
    final success = await phone_helper.makePhoneCall(event.phoneNumber);

    if (success) {
      emit(DoctorDetailActionSuccess('Call initiated'));
    } else {
      emit(DoctorDetailActionFailure('Could not make phone call'));
    }
  }
}
