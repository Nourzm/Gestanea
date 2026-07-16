import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
/// Service to check and monitor network connectivity
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectivityController;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isOnline = false;

  /// Get current online status
  bool get isOnline => _isOnline;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast();
    return _connectivityController!.stream;
  }

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    _isOnline = await checkConnectivity();

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      _updateConnectionStatus(result);
    });
  }

  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      return _hasValidConnection(result);
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    final bool wasOnline = _isOnline;
    _isOnline = _hasValidConnection(result);

    // Notify listeners if status changed
    if (wasOnline != _isOnline) {
      print('Connectivity changed: ${_isOnline ? "Online" : "Offline"}');
      _connectivityController?.add(_isOnline);
    }
  }

  /// Check if the connectivity result indicates a valid connection
  bool _hasValidConnection(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController?.close();
  }
}
