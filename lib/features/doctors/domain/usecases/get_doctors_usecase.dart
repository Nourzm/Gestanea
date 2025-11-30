import 'package:gestanea/features/doctors/data/datasources/mock_doctor_data.dart';
import 'package:gestanea/features/doctors/domain/entities/doctor_entity.dart';

class GetDoctorsUseCase {
  List<DoctorEntity> execute() {
    // Get mock data and convert to entities
    return MockDoctorData.doctors
        .map((doctorMap) => DoctorEntity.fromMap(doctorMap))
        .toList();
  }

  DoctorEntity? getDoctorByName(String name) {
    try {
      final doctorMap = MockDoctorData.doctors.firstWhere(
        (doctor) => doctor['name'] == name,
      );
      return DoctorEntity.fromMap(doctorMap);
    } catch (e) {
      return null;
    }
  }

  List<String> getAllSpecialties() {
    return MockDoctorData.doctors
        .map((doctor) => doctor['specialty'] as String)
        .toSet()
        .toList();
  }
}
