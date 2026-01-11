// lib/features/pregnancy/presentation/widgets/kick_counter_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancyTracking/data/repositories/pregnancy_repository.dart';
import 'package:gestanea/core/constants/app_colors.dart';

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

  String _getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
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

      if (userId.isNotEmpty) {
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
          backgroundColor: AppColors.main600,
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
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.main600.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.main300.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/kickcounter.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Track Your Baby\'s Movements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.main700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Counting kicks is a great way to bond with your baby.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textDark.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: AppColors.main600.withOpacity(0.4),
              ),
              child: const Text(
                'Start Tracking',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.main600.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVE TRACKING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Kick Counter Circle
          GestureDetector(
            onTap: _incrementKick,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: kickCount / 10, // Assuming 10 kicks target
                    strokeWidth: 8,
                    backgroundColor: AppColors.bg_1,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.main600),
                  ),
                ),
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.main600.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$kickCount',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main700,
                          height: 1,
                        ),
                      ),
                      Text(
                        'KICKS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'TAP TO COUNT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reset Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDark.withOpacity(0.6),
                    side: BorderSide(color: AppColors.bg_1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Finish Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _stopTracking,
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Finish'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
