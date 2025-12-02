import 'package:gestanea/features/doctors/data/models/doctor_entity.dart';

class SearchDoctorsUseCase {
  List<DoctorEntity> execute(List<DoctorEntity> doctors, String query) {
    if (query.isEmpty) {
      return doctors;
    }

    final lowercaseQuery = query.toLowerCase().trim();

    return doctors.where((doctor) {
      final matchesName = doctor.name.toLowerCase().contains(lowercaseQuery);
      final matchesSpecialty = doctor.specialty.toLowerCase().contains(
        lowercaseQuery,
      );
      return matchesName || matchesSpecialty;
    }).toList();
  }
}
