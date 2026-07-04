import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';

// Events
abstract class MedicinesEvent extends Equatable {
  const MedicinesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMedicinesWithLogs extends MedicinesEvent {
  final List<MedicineModel> medicines;
  final List<MedicineLoggedModel> logs;

  const LoadMedicinesWithLogs({required this.medicines, required this.logs});

  @override
  List<Object?> get props => [medicines, logs];
}

class SelectFilter extends MedicinesEvent {
  final String filter;

  const SelectFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class UpdateScrollVisibility extends MedicinesEvent {
  final bool showFilters;

  const UpdateScrollVisibility(this.showFilters);

  @override
  List<Object?> get props => [showFilters];
}

// States
abstract class MedicinesState extends Equatable {
  const MedicinesState();

  @override
  List<Object?> get props => [];
}

class MedicinesInitial extends MedicinesState {}

class MedicinesDisplayState extends MedicinesState {
  final List<MedicineModel> allMedicines;
  final List<MedicineLoggedModel> logs;
  final List<MedicineModel> filteredMedicines;
  final String selectedFilter;
  final bool showFilters;
  final int allCount;
  final int takenCount;
  final int missedCount;

  const MedicinesDisplayState({
    required this.allMedicines,
    required this.logs,
    required this.filteredMedicines,
    required this.selectedFilter,
    required this.showFilters,
    required this.allCount,
    required this.takenCount,
    required this.missedCount,
  });

  @override
  List<Object?> get props => [
    allMedicines,
    logs,
    filteredMedicines,
    selectedFilter,
    showFilters,
    allCount,
    takenCount,
    missedCount,
  ];

  MedicinesDisplayState copyWith({
    List<MedicineModel>? allMedicines,
    List<MedicineLoggedModel>? logs,
    List<MedicineModel>? filteredMedicines,
    String? selectedFilter,
    bool? showFilters,
    int? allCount,
    int? takenCount,
    int? missedCount,
  }) {
    return MedicinesDisplayState(
      allMedicines: allMedicines ?? this.allMedicines,
      logs: logs ?? this.logs,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      showFilters: showFilters ?? this.showFilters,
      allCount: allCount ?? this.allCount,
      takenCount: takenCount ?? this.takenCount,
      missedCount: missedCount ?? this.missedCount,
    );
  }
}

// BLoC
class MedicinesBloc extends Bloc<MedicinesEvent, MedicinesState> {
  MedicinesBloc() : super(MedicinesInitial()) {
    on<LoadMedicinesWithLogs>(_onLoadMedicinesWithLogs);
    on<SelectFilter>(_onSelectFilter);
    on<UpdateScrollVisibility>(_onUpdateScrollVisibility);
  }

  void _onLoadMedicinesWithLogs(
    LoadMedicinesWithLogs event,
    Emitter<MedicinesState> emit,
  ) {
    final allCount = event.medicines.length;
    final takenCount = event.logs.where((l) => l.status == 'taken').length;
    final missedCount = event.logs.where((l) => l.status == 'missed').length;

    emit(
      MedicinesDisplayState(
        allMedicines: event.medicines,
        logs: event.logs,
        filteredMedicines: event.medicines,
        selectedFilter: 'All',
        showFilters: true,
        allCount: allCount,
        takenCount: takenCount,
        missedCount: missedCount,
      ),
    );
  }

  void _onSelectFilter(SelectFilter event, Emitter<MedicinesState> emit) {
    if (state is MedicinesDisplayState) {
      final currentState = state as MedicinesDisplayState;
      final filtered = _filterMedicines(
        event.filter,
        currentState.allMedicines,
        currentState.logs,
      );

      emit(
        currentState.copyWith(
          selectedFilter: event.filter,
          filteredMedicines: filtered,
        ),
      );
    }
  }

  void _onUpdateScrollVisibility(
    UpdateScrollVisibility event,
    Emitter<MedicinesState> emit,
  ) {
    if (state is MedicinesDisplayState) {
      final currentState = state as MedicinesDisplayState;
      emit(currentState.copyWith(showFilters: event.showFilters));
    }
  }

  List<MedicineModel> _filterMedicines(
    String filter,
    List<MedicineModel> medicines,
    List<MedicineLoggedModel> logs,
  ) {
    if (filter == 'All') {
      return medicines;
    } else if (filter == 'Taken') {
      return medicines.where((med) {
        final log = logs.firstWhere(
          (l) => l.medicineId == med.id,
          orElse: () => MedicineLoggedModel(
            id: '',
            medicineId: '',
            userId: '',
            loggedDate: DateTime.now(),
            status: '',
            loggedAt: DateTime.now(),
          ),
        );
        return log.status == 'taken';
      }).toList();
    } else {
      // Missed
      return medicines.where((med) {
        final log = logs.firstWhere(
          (l) => l.medicineId == med.id,
          orElse: () => MedicineLoggedModel(
            id: '',
            medicineId: '',
            userId: '',
            loggedDate: DateTime.now(),
            status: '',
            loggedAt: DateTime.now(),
          ),
        );
        return log.status == 'missed';
      }).toList();
    }
  }
}
