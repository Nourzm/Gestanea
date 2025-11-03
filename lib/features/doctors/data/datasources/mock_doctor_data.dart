class MockDoctorData {
  static final Map<String, dynamic> sampleDoctor = {
    'name': 'Dr. Sarah Johnson',
    'specialty': 'Cardiologist',
    'address': '123 Medical Center Blvd, Downtown',
    'phone_number': '+213 782 758 438',
    'latitude': 36.753769,
    'longitude': 3.058756,
    'distance_km': 0.8,
    'rating': 4.8,
    'total_reviews': 856,
    'opening_hours':
        'Mon-Fri: 9:00 AM - 5:00 PM\nSat: 9:00 AM - 4:00 PM\nSun: Closed',
  };

  // You can add more sample doctors here
  static final List<Map<String, dynamic>> doctors = [
    sampleDoctor,
    {
      'name': 'Dr. Michael Chen',
      'specialty': 'Pediatrician',
      'address': '456 Health Plaza, Medical District',
      'phone_number': '+213 555 123 456',
      'latitude': 36.763769,
      'longitude': 3.068756,
      'distance_km': 1.5,
      'rating': 4.9,
      'total_reviews': 1024,
      'opening_hours':
          'Mon-Fri: 8:00 AM - 6:00 PM\nSat: 10:00 AM - 2:00 PM\nSun: Closed',
    },
    {
      'name': 'Dr. Emily Williams',
      'specialty': 'Dermatologist',
      'address': '789 Care Avenue, Central City',
      'phone_number': '+213 555 789 012',
      'latitude': 36.743769,
      'longitude': 3.048756,
      'distance_km': 2.3,
      'rating': 4.7,
      'total_reviews': 642,
      'opening_hours':
          'Mon-Fri: 9:00 AM - 7:00 PM\nSat: 9:00 AM - 5:00 PM\nSun: Closed',
    },
  ];
}
