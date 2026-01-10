// lib/features/dashboard/presentation/providers/dashboard_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/pregnancy_dashboard.dart';
import '../../domain/entities/postpartum_dashboard.dart';
import '../../domain/usecases/get_pregnancy_dashboard_usecase.dart';
import '../../domain/usecases/get_postpartum_dashboard_usecase.dart';

class DashboardProvider extends ChangeNotifier {
  final GetPregnancyDashboardUseCase _getPregnancyDashboardUseCase;
  final GetPostpartumDashboardUseCase _getPostpartumDashboardUseCase;

  PregnancyDashboard? _pregnancyDashboard;
  PostpartumDashboard? _postpartumDashboard;
  bool _isLoading = false;
  String? _error;
  String _userId = ''; // Use String instead of int for consistency with database

  // Singleton pattern
  static final DashboardProvider _instance = DashboardProvider._internal();

  factory DashboardProvider({
    GetPregnancyDashboardUseCase? getPregnancyDashboardUseCase,
    GetPostpartumDashboardUseCase? getPostpartumDashboardUseCase,
  }) {
    return _instance;
  }

  DashboardProvider._internal({
    GetPregnancyDashboardUseCase? getPregnancyDashboardUseCase,
    GetPostpartumDashboardUseCase? getPostpartumDashboardUseCase,
  }) : _getPregnancyDashboardUseCase =
           getPregnancyDashboardUseCase ?? GetPregnancyDashboardUseCase(),
       _getPostpartumDashboardUseCase =
           getPostpartumDashboardUseCase ?? GetPostpartumDashboardUseCase();

  static DashboardProvider getInstance() {
    return _instance;
  }

  PregnancyDashboard? get pregnancyDashboard => _pregnancyDashboard;
  PostpartumDashboard? get postpartumDashboard => _postpartumDashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUserId(int userId) {
    _userId = userId.toString();
  }

  void setUserIdString(String userId) {
    _userId = userId;
  }

  Future<void> loadPregnancyDashboard() async {
    if (_userId.isEmpty) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pregnancyDashboard = await _getPregnancyDashboardUseCase.callByStringId(_userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPostpartumDashboard() async {
    if (_userId.isEmpty) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _postpartumDashboard = await _getPostpartumDashboardUseCase.callByStringId(_userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh methods for dashboard updates
  Future<void> refreshPregnancyDashboard() async {
    // Small delay to ensure database is updated
    await Future.delayed(const Duration(milliseconds: 500));
    await loadPregnancyDashboard();
  }

  Future<void> refreshPostpartumDashboard() async {
    // Small delay to ensure database is updated
    await Future.delayed(const Duration(milliseconds: 500));
    await loadPostpartumDashboard();
  }
}
