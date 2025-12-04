import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/models/medicine.dart';
import 'package:gestanea/core/models/medicine_log.dart';
import 'package:gestanea/core/repositories/medicine_repository.dart';
import 'package:gestanea/core/repositories/user_repository.dart';
import 'package:gestanea/core/utils/service_locator.dart';
import 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineRepository _medicineRepository;
  final UserRepository _userRepository;

  MedicineCubit({
    MedicineRepository? medicineRepository,
    UserRepository? userRepository,
  })  : _medicineRepository = medicineRepository ?? getIt<MedicineRepository>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(MedicineInitial()) {
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    emit(MedicineLoading());
    
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isFailure) {
      emit(MedicineError(userResult.message ?? 'Failed to get user'));
      return;
    }

    final userId = userResult.data!.id;
    final medicinesResult = await _medicineRepository.getMedicines(userId);

    if (medicinesResult.isSuccess) {
      // Load logs for each medicine
      final medicines = medicinesResult.data ?? [];
      final List<MedicineLog> allLogs = [];
      
      for (var medicine in medicines) {
        final logsResult = await _medicineRepository.getMedicineLogs(medicine.id);
        if (logsResult.isSuccess) {
          allLogs.addAll(logsResult.data ?? []);
        }
      }

      emit(MedicineLoaded(
        medicines: medicines,
        medicineLogs: allLogs,
      ));
    } else {
      emit(MedicineError(medicinesResult.message ?? 'Failed to load medicines'));
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    final result = await _medicineRepository.addMedicine(medicine);
    
    if (result.isSuccess) {
      emit(MedicineOperationSuccess(result.message ?? 'Medicine added successfully'));
      await loadMedicines();
    } else {
      emit(MedicineError(result.message ?? 'Failed to add medicine'));
    }
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final result = await _medicineRepository.updateMedicine(medicine);
    
    if (result.isSuccess) {
      emit(MedicineOperationSuccess(result.message ?? 'Medicine updated successfully'));
      await loadMedicines();
    } else {
      emit(MedicineError(result.message ?? 'Failed to update medicine'));
    }
  }

  Future<void> deleteMedicine(String id) async {
    final result = await _medicineRepository.deleteMedicine(id);
    
    if (result.isSuccess) {
      emit(MedicineOperationSuccess(result.message ?? 'Medicine deleted successfully'));
      await loadMedicines();
    } else {
      emit(MedicineError(result.message ?? 'Failed to delete medicine'));
    }
  }

  Future<void> logMedicine(MedicineLog log) async {
    final result = await _medicineRepository.addMedicineLog(log);
    
    if (result.isSuccess) {
      await loadMedicines();
    } else {
      emit(MedicineError(result.message ?? 'Failed to log medicine'));
    }
  }
}
