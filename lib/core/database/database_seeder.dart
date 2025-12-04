import 'package:uuid/uuid.dart';
import 'package:gestanea/core/database/db_helper.dart';

class DatabaseSeeder {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _uuid = const Uuid();

  // User IDs
  late final String userId;

  // Related IDs
  late final String pregnancyId;
  late final String babyId;

  Future<void> seedDatabase() async {
    final db = await _dbHelper.database;

    // Generate IDs
    userId = _uuid.v4();
    pregnancyId = _uuid.v4();
    babyId = _uuid.v4();

    // Seed in order (respecting foreign keys)
    await _seedUser(db);
    await _seedPregnancy(db);
    await _seedBaby(db);
    await _seedKickCounts(db);
    await _seedBabyGrowth(db);
    await _seedMilestones(db);
    await _seedFeedingLogs(db);
    await _seedVitals(db);
    await _seedSymptoms(db);
    await _seedMoods(db);
    await _seedLabResults(db);
    await _seedRiskAlerts(db);
    await _seedDoctors(db);
    await _seedAppointments(db);
    await _seedMedicines(db);
    await _seedMedicineLogs(db);
    await _seedReminders(db);
    await _seedTips(db);
    await _seedProductCategories(db);
    await _seedProducts(db);
    await _seedProductVariants(db);
    await _seedProductSpecs(db);
    await _seedProductReviews(db);
    await _seedCartItems(db);
    await _seedOrders(db);
  }

  Future<void> _seedUser(db) async {
    await db.insert('users', {
      'id': userId,
      'email': 'sara@gestanea.app',
      'name': 'Sara Ahmed',
      'phone': '+1234567890',
      'profile_image': null,
      'created_at': DateTime(2024, 1, 1).toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _seedPregnancy(db) async {
    final startDate = DateTime.now().subtract(const Duration(days: 196)); // 28 weeks ago
    final dueDate = DateTime.now().add(const Duration(days: 84)); // 12 weeks from now

    await db.insert('pregnancies', {
      'id': pregnancyId,
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'is_active': 1,
      'medical_conditions': 'Gestational diabetes',
      'notes': 'Regular monitoring required',
      'created_at': startDate.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _seedBaby(db) async {
    final birthDate = DateTime.now().subtract(const Duration(days: 180)); // 6 months ago

    await db.insert('babies', {
      'id': babyId,
      'user_id': userId,
      'name': 'Amira',
      'gender': 'female',
      'birth_date': birthDate.toIso8601String(),
      'birth_weight': 3.2,
      'birth_height': 50.0,
      'blood_type': 'A+',
      'profile_image': null,
      'created_at': birthDate.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _seedKickCounts(db) async {
    for (int i = 0; i < 15; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final startTime = date.subtract(Duration(hours: 10 - (i % 8)));
      final endTime = startTime.add(Duration(minutes: 20 + (i * 3)));
      
      await db.insert('kick_counts', {
        'id': _uuid.v4(),
        'pregnancy_id': pregnancyId,
        'date': date.toIso8601String(),
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'count': 10 + (i % 5),
        'duration_minutes': 20 + (i * 3),
        'notes': i % 3 == 0 ? 'Very active today' : null,
        'created_at': startTime.toIso8601String(),
      });
    }
  }

  Future<void> _seedBabyGrowth(db) async {
    final records = [
      {'months': 0, 'weight': 3.2, 'height': 50.0, 'head': 35.0},
      {'months': 1, 'weight': 4.5, 'height': 54.0, 'head': 37.0},
      {'months': 2, 'weight': 5.6, 'height': 58.0, 'head': 39.0},
      {'months': 3, 'weight': 6.4, 'height': 61.0, 'head': 40.5},
      {'months': 4, 'weight': 7.0, 'height': 63.5, 'head': 41.5},
      {'months': 5, 'weight': 7.5, 'height': 65.5, 'head': 42.5},
      {'months': 6, 'weight': 8.0, 'height': 67.0, 'head': 43.0},
    ];

    for (final record in records) {
      final date = DateTime.now().subtract(Duration(days: (6 - record['months']! as int) * 30));
      await db.insert('baby_growth', {
        'id': _uuid.v4(),
        'baby_id': babyId,
        'date': date.toIso8601String(),
        'weight': record['weight'],
        'height': record['height'],
        'head_circumference': record['head'],
        'notes': null,
        'created_at': date.toIso8601String(),
      });
    }
  }

  Future<void> _seedMilestones(db) async {
    final milestones = [
      {'title': 'First Smile', 'category': 'social', 'age': 2, 'achieved': true, 'days_ago': 120},
      {'title': 'Rolled Over', 'category': 'physical', 'age': 3, 'achieved': true, 'days_ago': 90},
      {'title': 'Sat Up', 'category': 'physical', 'age': 5, 'achieved': true, 'days_ago': 45},
      {'title': 'Crawled', 'category': 'physical', 'age': 6, 'achieved': true, 'days_ago': 15},
      {'title': 'First Word', 'category': 'language', 'age': 6, 'achieved': true, 'days_ago': 10},
      {'title': 'Walking', 'category': 'physical', 'age': 12, 'achieved': false, 'days_ago': null},
      {'title': 'First Steps', 'category': 'physical', 'age': 12, 'achieved': false, 'days_ago': null},
      {'title': 'Running', 'category': 'physical', 'age': 18, 'achieved': false, 'days_ago': null},
    ];

    for (final milestone in milestones) {
      final achievedDate = milestone['achieved'] as bool && milestone['days_ago'] != null
          ? DateTime.now().subtract(Duration(days: milestone['days_ago'] as int))
          : null;

      await db.insert('milestones', {
        'id': _uuid.v4(),
        'baby_id': babyId,
        'title': milestone['title'],
        'description': 'Important developmental milestone',
        'category': milestone['category'],
        'expected_age_months': milestone['age'],
        'achieved': (milestone['achieved'] as bool) ? 1 : 0,
        'achieved_date': achievedDate?.toIso8601String(),
        'notes': null,
        'created_at': DateTime.now().subtract(Duration(days: 180)).toIso8601String(),
      });
    }
  }

  Future<void> _seedFeedingLogs(db) async {
    final types = ['breastfeeding', 'bottle', 'breastfeeding', 'breastfeeding'];
    final sides = ['left', 'right', 'both'];

    for (int i = 0; i < 60; i++) {
      final date = DateTime.now().subtract(Duration(days: i ~/ 8));
      final hour = 6 + (i % 8) * 3;
      final time = DateTime(date.year, date.month, date.day, hour);
      final type = types[i % types.length];

      await db.insert('feeding_logs', {
        'id': _uuid.v4(),
        'baby_id': babyId,
        'date': date.toIso8601String(),
        'time': time.toIso8601String(),
        'type': type,
        'duration_minutes': type == 'breastfeeding' ? 15 + (i % 10) : null,
        'amount_ml': type == 'bottle' ? 120.0 + (i % 20) : null,
        'breast_side': type == 'breastfeeding' ? sides[i % sides.length] : null,
        'notes': null,
        'created_at': time.toIso8601String(),
      });
    }
  }

  Future<void> _seedVitals(db) async {
    final vitalTypes = [
      {'type': 'blood_pressure', 'values': [120, 125, 118, 130, 128, 122, 135], 'unit': 'mmHg'},
      {'type': 'heart_rate', 'values': [72, 75, 70, 78, 76, 74, 80], 'unit': 'bpm'},
      {'type': 'temperature', 'values': [36.6, 36.8, 36.5, 36.7, 37.0, 36.9], 'unit': '°C'},
    ];

    for (final vitalType in vitalTypes) {
      final values = vitalType['values'] as List<num>;
      for (int i = 0; i < values.length; i++) {
        final date = DateTime.now().subtract(Duration(days: i * 4));
        final time = DateTime(date.year, date.month, date.day, 9, 0);

        await db.insert('vitals', {
          'id': _uuid.v4(),
          'user_id': userId,
          'pregnancy_id': pregnancyId,
          'date': date.toIso8601String(),
          'time': time.toIso8601String(),
          'type': vitalType['type'],
          'value': values[i].toDouble(),
          'unit': vitalType['unit'],
          'notes': null,
          'created_at': time.toIso8601String(),
        });
      }
    }
  }

  Future<void> _seedSymptoms(db) async {
    final symptoms = [
      'Nausea', 'Fatigue', 'Back pain', 'Headache', 'Swelling',
      'Heartburn', 'Leg cramps', 'Dizziness', 'Nausea', 'Back pain'
    ];

    for (int i = 0; i < 15; i++) {
      final date = DateTime.now().subtract(Duration(days: i * 2));
      final time = DateTime(date.year, date.month, date.day, 14, 0);

      await db.insert('symptoms', {
        'id': _uuid.v4(),
        'user_id': userId,
        'pregnancy_id': pregnancyId,
        'date': date.toIso8601String(),
        'time': time.toIso8601String(),
        'symptom': symptoms[i % symptoms.length],
        'severity': 1 + (i % 5),
        'notes': null,
        'created_at': time.toIso8601String(),
      });
    }
  }

  Future<void> _seedMoods(db) async {
    final moods = ['happy', 'anxious', 'tired', 'stressed', 'excited', 'calm', 'worried'];

    for (int i = 0; i < 15; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final time = DateTime(date.year, date.month, date.day, 20, 0);

      await db.insert('moods', {
        'id': _uuid.v4(),
        'user_id': userId,
        'pregnancy_id': pregnancyId,
        'date': date.toIso8601String(),
        'time': time.toIso8601String(),
        'mood': moods[i % moods.length],
        'intensity': 1 + (i % 5),
        'notes': null,
        'created_at': time.toIso8601String(),
      });
    }
  }

  Future<void> _seedLabResults(db) async {
    final tests = [
      {'name': 'Hemoglobin', 'value': 11.5, 'unit': 'g/dL', 'range': '12-16', 'status': 'abnormal'},
      {'name': 'Glucose', 'value': 95.0, 'unit': 'mg/dL', 'range': '70-100', 'status': 'normal'},
      {'name': 'Iron', 'value': 45.0, 'unit': 'mcg/dL', 'range': '60-170', 'status': 'abnormal'},
      {'name': 'Hemoglobin', 'value': 12.2, 'unit': 'g/dL', 'range': '12-16', 'status': 'normal'},
      {'name': 'Glucose', 'value': 102.0, 'unit': 'mg/dL', 'range': '70-100', 'status': 'abnormal'},
      {'name': 'Blood Pressure', 'value': 125.0, 'unit': 'mmHg', 'range': '90-120', 'status': 'normal'},
      {'name': 'Thyroid', 'value': 2.5, 'unit': 'mIU/L', 'range': '0.4-4.0', 'status': 'normal'},
    ];

    for (int i = 0; i < tests.length; i++) {
      final test = tests[i];
      final date = DateTime.now().subtract(Duration(days: i * 15));

      await db.insert('lab_results', {
        'id': _uuid.v4(),
        'user_id': userId,
        'pregnancy_id': pregnancyId,
        'date': date.toIso8601String(),
        'test_name': test['name'],
        'value': (test['value']! as num).toDouble(),
        'unit': test['unit'],
        'reference_range': test['range'],
        'status': test['status'],
        'notes': null,
        'created_at': date.toIso8601String(),
      });
    }
  }

  Future<void> _seedRiskAlerts(db) async {
    final alerts = [
      {
        'type': 'High Blood Pressure',
        'severity': 'high',
        'message': 'Blood pressure reading of 135/90 detected',
        'recommendations': 'Consult with your doctor, reduce salt intake, monitor regularly',
        'resolved': false,
      },
      {
        'type': 'Low Iron Levels',
        'severity': 'medium',
        'message': 'Iron levels below normal range',
        'recommendations': 'Take iron supplements, eat iron-rich foods',
        'resolved': false,
      },
      {
        'type': 'Glucose Levels',
        'severity': 'low',
        'message': 'Slightly elevated glucose levels',
        'recommendations': 'Monitor diet, regular exercise',
        'resolved': true,
      },
    ];

    for (int i = 0; i < alerts.length; i++) {
      final alert = alerts[i];
      final createdDate = DateTime.now().subtract(Duration(days: (i + 1) * 7));

      await db.insert('risk_alerts', {
        'id': _uuid.v4(),
        'user_id': userId,
        'pregnancy_id': pregnancyId,
        'alert_type': alert['type'],
        'severity': alert['severity'],
        'message': alert['message'],
        'recommendations': alert['recommendations'],
        'is_resolved': (alert['resolved'] as bool) ? 1 : 0,
        'created_at': createdDate.toIso8601String(),
        'resolved_at': (alert['resolved'] as bool) ? DateTime.now().subtract(Duration(days: 2)).toIso8601String() : null,
      });
    }
  }

  Future<void> _seedDoctors(db) async {
    // This is a subset - add more as needed
    final doctors = [
      {'name': 'Dr. Emily Chen', 'specialty': 'Obstetrician', 'gender': 'female', 'rating': 4.9, 'lat': 40.7580, 'lng': -73.9855, 'years': 15},
      {'name': 'Dr. Michael Brown', 'specialty': 'Pediatrician', 'gender': 'male', 'rating': 4.8, 'lat': 40.7489, 'lng': -73.9680, 'years': 12},
      {'name': 'Dr. Sarah Johnson', 'specialty': 'Gynecologist', 'gender': 'female', 'rating': 4.7, 'lat': 40.7614, 'lng': -73.9776, 'years': 10},
      {'name': 'Dr. David Lee', 'specialty': 'Obstetrician', 'gender': 'male', 'rating': 4.6, 'lat': 40.7529, 'lng': -73.9772, 'years': 18},
      {'name': 'Dr. Jessica Martinez', 'specialty': 'Midwife', 'gender': 'female', 'rating': 4.9, 'lat': 40.7589, 'lng': -73.9851, 'years': 8},
      {'name': 'Dr. Robert Wilson', 'specialty': 'Pediatrician', 'gender': 'male', 'rating': 4.5, 'lat': 40.7549, 'lng': -73.9840, 'years': 20},
      {'name': 'Dr. Amanda Taylor', 'specialty': 'Lactation Consultant', 'gender': 'female', 'rating': 5.0, 'lat': 40.7456, 'lng': -73.9889, 'years': 7},
      {'name': 'Dr. James Anderson', 'specialty': 'Obstetrician', 'gender': 'male', 'rating': 4.4, 'lat': 40.7612, 'lng': -73.9645, 'years': 14},
      {'name': 'Dr. Lisa Thompson', 'specialty': 'Gynecologist', 'gender': 'female', 'rating': 4.8, 'lat': 40.7580, 'lng': -73.9720, 'years': 11},
      {'name': 'Dr. Christopher Garcia', 'specialty': 'Pediatrician', 'gender': 'male', 'rating': 4.7, 'lat': 40.7501, 'lng': -73.9801, 'years': 9},
    ];

    // Store doctor IDs for favorites
    final doctorIds = <String>[];

    for (final doctor in doctors) {
      final doctorId = _uuid.v4();
      doctorIds.add(doctorId);

      await db.insert('doctors', {
        'id': doctorId,
        'name': doctor['name'],
        'specialty': doctor['specialty'],
        'gender': doctor['gender'],
        'phone': '+1-555-${1000 + doctorIds.length}',
        'email': '${(doctor['name'] as String).toLowerCase().replaceAll(' ', '').replaceAll('.', '')}@clinic.com',
        'address': '${100 + doctorIds.length} Medical Plaza, New York, NY',
        'latitude': (doctor['lat']! as num).toDouble(),
        'longitude': (doctor['lng']! as num).toDouble(),
        'rating': (doctor['rating']! as num).toDouble(),
        'years_experience': doctor['years'],
        'photo_url': null,
        'created_at': DateTime.now().subtract(Duration(days: 365)).toIso8601String(),
      });
    }

    // Add 5 favorites
    for (int i = 0; i < 5 && i < doctorIds.length; i++) {
      await db.insert('user_favorite_doctors', {
        'id': _uuid.v4(),
        'user_id': userId,
        'doctor_id': doctorIds[i],
        'favorited_at': DateTime.now().subtract(Duration(days: 30 - i * 5)).toIso8601String(),
      });
    }
  }

  // Continue in next part due to length...
  Future<void> _seedAppointments(db) async {
    final appointments = [
      {'title': 'Prenatal Checkup', 'days': -30, 'status': 'completed'},
      {'title': 'Ultrasound', 'days': -20, 'status': 'completed'},
      {'title': 'Blood Test', 'days': -10, 'status': 'completed'},
      {'title': 'Pediatrician Visit', 'days': -5, 'status': 'completed'},
      {'title': 'Vaccination', 'days': -2, 'status': 'completed'},
      {'title': 'Prenatal Checkup', 'days': 7, 'status': 'scheduled'},
      {'title': 'Growth Check', 'days': 14, 'status': 'scheduled'},
      {'title': 'Lab Results Review', 'days': 21, 'status': 'scheduled'},
      {'title': 'Specialist Consultation', 'days': 28, 'status': 'scheduled'},
      {'title': 'Routine Checkup', 'days': 35, 'status': 'scheduled'},
    ];

    for (final appt in appointments) {
      final date = DateTime.now().add(Duration(days: appt['days'] as int));
      final time = DateTime(date.year, date.month, date.day, 10, 0);

      await db.insert('appointments', {
        'id': _uuid.v4(),
        'user_id': userId,
        'pregnancy_id': (appt['days'] as int) < 0 ? pregnancyId : null,
        'baby_id': (appt['days'] as int) >= -5 ? babyId : null,
        'doctor_id': null,
        'title': appt['title'],
        'description': 'Regular ${appt['title']}',
        'date': date.toIso8601String(),
        'time': time.toIso8601String(),
        'location': 'City Medical Center',
        'status': appt['status'],
        'notes': null,
        'created_at': DateTime.now().subtract(Duration(days: 60)).toIso8601String(),
      });
    }
  }

  Future<void> _seedMedicines(db) async {
    final medicines = [
      {'name': 'Prenatal Vitamins', 'dosage': '1 tablet', 'freq': 'daily', 'times': 1, 'for': 'pregnancy'},
      {'name': 'Iron Supplement', 'dosage': '65mg', 'freq': 'twice daily', 'times': 2, 'for': 'pregnancy'},
      {'name': 'Vitamin D (Baby)', 'dosage': '400 IU', 'freq': 'daily', 'times': 1, 'for': 'baby'},
    ];

    final medicineIds = <String>[];

    for (final med in medicines) {
      final medicineId = _uuid.v4();
      medicineIds.add(medicineId);

      await db.insert('medicines', {
        'id': medicineId,
        'user_id': userId,
        'pregnancy_id': med['for'] == 'pregnancy' ? pregnancyId : null,
        'baby_id': med['for'] == 'baby' ? babyId : null,
        'name': med['name'],
        'dosage': med['dosage'],
        'frequency': med['freq'],
        'times_per_day': med['times'],
        'start_date': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
        'end_date': null,
        'is_active': 1,
        'notes': null,
        'created_at': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
      });
    }
  }

  Future<void> _seedMedicineLogs(db) async {
    // Will be implemented when medicine IDs are available
    // For now, skip to keep seeder simpler
  }

  Future<void> _seedReminders(db) async {
    final reminders = [
      {'title': 'Take prenatal vitamin', 'days': 0, 'hour': 8, 'type': 'medicine'},
      {'title': 'Drink water', 'days': 0, 'hour': 14, 'type': 'custom'},
      {'title': 'Prenatal appointment', 'days': 7, 'hour': 10, 'type': 'appointment'},
      {'title': 'Count kicks', 'days': 1, 'hour': 20, 'type': 'kick_count'},
      {'title': 'Take iron supplement', 'days': 0, 'hour': 20, 'type': 'medicine'},
    ];

    for (final reminder in reminders) {
      final date = DateTime.now().add(Duration(days: reminder['days'] as int));
      final time = DateTime(date.year, date.month, date.day, reminder['hour'] as int, 0);

      await db.insert('reminders', {
        'id': _uuid.v4(),
        'user_id': userId,
        'title': reminder['title'],
        'description': 'Reminder for ${reminder['title']}',
        'date': date.toIso8601String(),
        'time': time.toIso8601String(),
        'type': reminder['type'],
        'is_completed': 0,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // Tips will be added in separate method due to volume
  Future<void> _seedTips(db) async {
    final tips = [
      // Pregnancy tips
      {'title': 'Stay Hydrated', 'content': 'Drink at least 8-10 glasses of water daily during pregnancy.', 'category': 'pregnancy', 'stage': '1st_trimester'},
      {'title': 'Prenatal Vitamins', 'content': 'Take your prenatal vitamins every day, especially folic acid.', 'category': 'pregnancy', 'stage': '1st_trimester'},
      {'title': 'Morning Sickness Relief', 'content': 'Try eating small, frequent meals and keep crackers by your bedside.', 'category': 'pregnancy', 'stage': '1st_trimester'},
      {'title': 'Exercise Safely', 'content': 'Continue moderate exercise like walking or prenatal yoga.', 'category': 'exercise', 'stage': '2nd_trimester'},
      {'title': 'Healthy Diet', 'content': 'Eat a balanced diet rich in fruits, vegetables, and lean proteins.', 'category': 'nutrition', 'stage': '2nd_trimester'},
      {'title': 'Sleep Position', 'content': 'Sleep on your left side to improve blood flow to your baby.', 'category': 'pregnancy', 'stage': '2nd_trimester'},
      {'title': 'Pack Hospital Bag', 'content': 'Start packing your hospital bag around week 35-36.', 'category': 'pregnancy', 'stage': '3rd_trimester'},
      {'title': 'Birth Plan', 'content': 'Discuss your birth plan with your healthcare provider.', 'category': 'pregnancy', 'stage': '3rd_trimester'},
      {'title': 'Pelvic Floor Exercises', 'content': 'Practice Kegel exercises to strengthen pelvic floor muscles.', 'category': 'exercise', 'stage': '3rd_trimester'},
      {'title': 'Monitor Baby Kicks', 'content': 'Count baby kicks daily in the third trimester.', 'category': 'pregnancy', 'stage': '3rd_trimester'},
      
      // Baby care tips
      {'title': 'Tummy Time', 'content': 'Start tummy time from the first week to strengthen neck muscles.', 'category': 'baby_care', 'stage': '0-3months'},
      {'title': 'Feeding on Demand', 'content': 'Newborns need to feed every 2-3 hours.', 'category': 'baby_care', 'stage': '0-3months'},
      {'title': 'Sleep Safety', 'content': 'Always place baby on their back to sleep.', 'category': 'baby_care', 'stage': '0-3months'},
      {'title': 'Skin to Skin', 'content': 'Practice skin-to-skin contact to bond with your baby.', 'category': 'baby_care', 'stage': '0-3months'},
      {'title': 'Introducing Solids', 'content': 'Start introducing solids around 6 months with your pediatrician guidance.', 'category': 'nutrition', 'stage': '3-6months'},
      {'title': 'Baby-Proofing', 'content': 'Start baby-proofing your home as baby becomes mobile.', 'category': 'baby_care', 'stage': '6-12months'},
      
      // Mental health tips
      {'title': 'Self-Care', 'content': 'Take time for yourself every day, even if just 10 minutes.', 'category': 'mental_health', 'stage': null},
      {'title': 'Ask for Help', 'content': 'Do not hesitate to ask for help from family and friends.', 'category': 'mental_health', 'stage': null},
      {'title': 'Join Support Groups', 'content': 'Connect with other moms through support groups.', 'category': 'mental_health', 'stage': null},
    ];

    final tipIds = <String>[];

    for (final tip in tips) {
      final tipId = _uuid.v4();
      tipIds.add(tipId);

      await db.insert('tips', {
        'id': tipId,
        'title': tip['title'],
        'content': tip['content'],
        'category': tip['category'],
        'stage': tip['stage'],
        'image_url': null,
        'created_at': DateTime.now().subtract(Duration(days: 100)).toIso8601String(),
      });
    }

    // Save 10 tips
    for (int i = 0; i < 10 && i < tipIds.length; i++) {
      await db.insert('user_saved_tips', {
        'id': _uuid.v4(),
        'user_id': userId,
        'tip_id': tipIds[i],
        'saved_at': DateTime.now().subtract(Duration(days: 50 - i * 3)).toIso8601String(),
      });
    }
  }

  Future<void> _seedProductCategories(db) async {
    final categories = [
      'Baby Clothes',
      'Toys',
      'Feeding',
      'Nursery',
      'Maternity',
      'Health & Safety',
      'Bath Time',
      'Books',
    ];

    for (final category in categories) {
      await db.insert('product_categories', {
        'id': _uuid.v4(),
        'name': category,
        'icon': null,
        'image_url': null,
        'created_at': DateTime.now().subtract(Duration(days: 200)).toIso8601String(),
      });
    }
  }

  Future<void> _seedProducts(db) async {
    // Get category IDs
    final categories = await db.query('product_categories');
    if (categories.isEmpty) return;

    // Sample products
    final products = [
      {'cat': 0, 'name': 'Organic Cotton Onesie', 'desc': 'Soft organic cotton onesie', 'price': 15.99, 'discount': 10.0},
      {'cat': 0, 'name': 'Baby Sleeper Set', 'desc': 'Comfortable sleeper for newborns', 'price': 24.99, 'discount': 0.0},
      {'cat': 1, 'name': 'Soft Plush Bear', 'desc': 'Cuddly plush bear toy', 'price': 19.99, 'discount': 15.0},
      {'cat': 1, 'name': 'Wooden Building Blocks', 'desc': 'Safe wooden blocks for babies', 'price': 29.99, 'discount': 0.0},
      {'cat': 2, 'name': 'Baby Bottles Set', 'desc': 'Set of 6 anti-colic bottles', 'price': 34.99, 'discount': 20.0},
      {'cat': 2, 'name': 'Breast Pump', 'desc': 'Electric breast pump', 'price': 149.99, 'discount': 25.0},
      {'cat': 3, 'name': 'Convertible Crib', 'desc': '4-in-1 convertible crib', 'price': 299.99, 'discount': 0.0},
      {'cat': 4, 'name': 'Maternity Leggings', 'desc': 'Comfortable maternity leggings', 'price': 32.99, 'discount': 10.0},
    ];

    for (final product in products) {
      final catIndex = product['cat'] as int;
      if (catIndex >= categories.length) continue;

      await db.insert('products', {
        'id': _uuid.v4(),
        'category_id': categories[catIndex]['id'],
        'name': product['name'],
        'description': product['desc'],
        'price': (product['price']! as num).toDouble(),
        'discount_percentage': (product['discount']! as num).toDouble(),
        'image_url': 'https://placeholder.com/product.jpg',
        'rating': 4.0 + (catIndex % 10) / 10.0,
        'reviews_count': 10 + catIndex * 5,
        'stock_quantity': 50 + catIndex * 10,
        'created_at': DateTime.now().subtract(Duration(days: 180)).toIso8601String(),
      });
    }
  }

  Future<void> _seedProductVariants(db) async {
    // Simplified - add variants for first few products
    final products = await db.query('products', limit: 3);
    
    for (final product in products) {
      // Add color variants
      for (final color in ['Pink', 'Blue', 'White']) {
        await db.insert('product_variants', {
          'id': _uuid.v4(),
          'product_id': product['id'],
          'variant_type': 'color',
          'variant_value': color,
          'price_adjustment': null,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      
      // Add size variants
      for (final size in ['Newborn', '0-3M', '3-6M']) {
        await db.insert('product_variants', {
          'id': _uuid.v4(),
          'product_id': product['id'],
          'variant_type': 'size',
          'variant_value': size,
          'price_adjustment': null,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  Future<void> _seedProductSpecs(db) async {
    // Simplified
    final products = await db.query('products', limit: 2);
    
    for (final product in products) {
      await db.insert('product_specs', {
        'id': _uuid.v4(),
        'product_id': product['id'],
        'spec_name': 'Material',
        'spec_value': '100% Cotton',
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _seedProductReviews(db) async {
    // Simplified
    final products = await db.query('products', limit: 3);
    
    for (final product in products) {
      await db.insert('product_reviews', {
        'id': _uuid.v4(),
        'product_id': product['id'],
        'user_id': userId,
        'rating': 4.5,
        'comment': 'Great quality product!',
        'created_at': DateTime.now().subtract(Duration(days: 30)).toIso8601String(),
      });
    }
  }

  Future<void> _seedCartItems(db) async {
    final products = await db.query('products', limit: 5);
    
    for (int i = 0; i < products.length; i++) {
      await db.insert('cart_items', {
        'id': _uuid.v4(),
        'user_id': userId,
        'product_id': products[i]['id'],
        'quantity': i + 1,
        'selected_color': i % 2 == 0 ? 'Pink' : 'Blue',
        'selected_size': i % 3 == 0 ? 'Newborn' : '0-3M',
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _seedOrders(db) async {
    final products = await db.query('products', limit: 3);
    
    final orders = [
      {'number': 'ORD-001', 'amount': 89.97, 'status': 'delivered', 'days': -15},
      {'number': 'ORD-002', 'amount': 145.50, 'status': 'pending', 'days': -2},
      {'number': 'ORD-003', 'amount': 67.89, 'status': 'cancelled', 'days': -30},
    ];

    for (int i = 0; i < orders.length; i++) {
      final order = orders[i];
      final orderId = _uuid.v4();
      final date = DateTime.now().add(Duration(days: order['days'] as int));

      await db.insert('orders', {
        'id': orderId,
        'user_id': userId,
        'order_number': order['number'],
        'total_amount': (order['amount']! as num).toDouble(),
        'status': order['status'],
        'payment_method': 'Credit Card',
        'shipping_address': '123 Main St, New York, NY 10001',
        'created_at': date.toIso8601String(),
        'updated_at': date.toIso8601String(),
      });

      // Add order items
      if (i < products.length) {
        await db.insert('order_items', {
          'id': _uuid.v4(),
          'order_id': orderId,
          'product_id': products[i]['id'],
          'quantity': 2,
          'price': (products[i]['price'] as num).toDouble(),
          'selected_color': 'Blue',
          'selected_size': '0-3M',
          'created_at': date.toIso8601String(),
        });
      }
    }
  }
}
