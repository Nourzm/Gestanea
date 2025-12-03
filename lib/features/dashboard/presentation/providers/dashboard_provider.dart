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

  DashboardProvider({
    GetPregnancyDashboardUseCase? getPregnancyDashboardUseCase,
    GetPostpartumDashboardUseCase? getPostpartumDashboardUseCase,
  }) : _getPregnancyDashboardUseCase =
           getPregnancyDashboardUseCase ?? GetPregnancyDashboardUseCase(),
       _getPostpartumDashboardUseCase =
           getPostpartumDashboardUseCase ?? GetPostpartumDashboardUseCase();

  PregnancyDashboard? get pregnancyDashboard => _pregnancyDashboard;
  PostpartumDashboard? get postpartumDashboard => _postpartumDashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPregnancyDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pregnancyDashboard = await _getPregnancyDashboardUseCase.call();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPostpartumDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _postpartumDashboard = await _getPostpartumDashboardUseCase.call();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
