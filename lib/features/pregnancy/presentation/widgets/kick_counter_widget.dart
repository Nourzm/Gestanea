// lib/features/pregnancy/presentation/widgets/kick_counter_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancy/data/repositories/pregnancy_repository.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class KickCounterWidget extends StatefulWidget {
  /// Called after a session is successfully saved, so parents can refresh
  /// any kick history / daily total they display.
  final VoidCallback? onSessionSaved;

  const KickCounterWidget({super.key, this.onSessionSaved});

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
    final savedCount = kickCount;
    if (_startTime != null && kickCount > 0) {
      final duration = DateTime.now().difference(_startTime!).inMinutes;
      final userId = _getUserId();

      if (userId.isNotEmpty) {
        try {
          await _repository.saveKickSessionByStringId(
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

    if (!mounted) return;

    setState(() {
      isTracking = false;
      kickCount = 0;
      _startTime = null;
    });

    if (savedCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.sessionSaved(savedCount)),
          backgroundColor: AppColors.main600,
        ),
      );
      widget.onSessionSaved?.call();
    }
  }

  void _resetCounter() {
    setState(() => kickCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.shadow1,
      ),
      child: isTracking ? _buildTracking() : _buildIdle(),
    );
  }

  Widget _buildIdle() {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        _kickCircle(label: t.startLabel, big: false, onTap: _startTracking),
        const SizedBox(height: 16),
        Text(
          t.tapToStartKicks,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTracking() {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        _kickCircle(
          label: t.tapToCount,
          big: true,
          countOverride: kickCount,
          onTap: _incrementKick,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _resetCounter,
              icon: const Icon(Icons.refresh),
              label: Text(t.resetLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.main600,
                side: const BorderSide(color: AppColors.main500, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _stopTracking,
              icon: const Icon(Icons.check),
              label: Text(t.finishLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kickCircle({
    required String label,
    required bool big,
    int? countOverride,
    required VoidCallback onTap,
  }) {
    final double size = big ? 170 : 140;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.main500, AppColors.main600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.main500.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (countOverride != null)
                Text(
                  '$countOverride',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              else
                const Icon(Icons.favorite, color: Colors.white, size: 48),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
