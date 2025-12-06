// lib/features/pregnancy/presentation/widgets/kick_counter_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancy/data/repositories/pregnancy_repository.dart';

class KickCounterWidget extends StatefulWidget {
  const KickCounterWidget({super.key});

  @override
  State<KickCounterWidget> createState() => _KickCounterWidgetState();
}

class _KickCounterWidgetState extends State<KickCounterWidget> {
  int kickCount = 0;
  bool isTracking = false;
  DateTime? _startTime;
  final PregnancyRepository _repository = PregnancyRepository();

  int _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return int.tryParse(authState.user.id) ?? 0;
    }
    return 0;
  }

  void _startTracking() {
    setState(() {
      isTracking = true;
      _startTime = DateTime.now();
      kickCount = 0;
    });
  }

  void _incrementKick() {
    if (isTracking) {
      setState(() => kickCount++);
    }
  }

  Future<void> _stopTracking() async {
    if (_startTime != null && kickCount > 0) {
      final duration = DateTime.now().difference(_startTime!).inMinutes;
      final userId = _getUserId();
      
      if (userId > 0) {
        try {
          await _repository.saveKickSession(
            userId,
            kickCount,
            duration > 0 ? duration : 1, // At least 1 minute
            null,
          );
        } catch (e) {
          debugPrint('Error saving kick session: $e');
        }
      }
    }

    setState(() => isTracking = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Session saved: $kickCount kicks'),
          backgroundColor: const Color(0xFF9B7FDB),
        ),
      );
    }
    
    setState(() {
      kickCount = 0;
      _startTime = null;
    });
  }

  void _resetCounter() {
    setState(() => kickCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    if (!isTracking) {
      return GestureDetector(
        onTap: _startTracking,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/kickcounter.png',
                width: 200,
                height: 200,),
                const SizedBox(height: 8),
                const Text(
                  'Tap to start tracking kicks',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset('assets/images/kickcounter.png',
          width: 200,
          height: 200
          ),
          GestureDetector(
            onTap: _incrementKick,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8A5C8), Color(0xFFFFB6D9)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8A5C8).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$kickCount',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Tap to count',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _resetCounter,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF9B7FDB),
                  side: const BorderSide(color: Color(0xFF9B7FDB), width: 2),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _stopTracking,
                icon: const Icon(Icons.check),
                label: const Text('Finish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8A5C8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}