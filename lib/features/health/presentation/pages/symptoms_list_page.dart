import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/models/symptom_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/bloc/symptoms_bloc.dart';
import '../../logic/bloc/symptoms_state.dart';

class SymptomsListPage extends StatelessWidget {
  const SymptomsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.mySymptoms),
        backgroundColor: AppColors.main500,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<SymptomsBloc, SymptomsState>(
        builder: (context, state) {
          if (state is SymptomsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SymptomsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('${t.error}: ${state.message}'),
                ],
              ),
            );
          }

          if (state is SymptomsLoaded) {
            if (state.symptoms.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      t.noSymptomsYet,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(t.tapLogSymptom),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.symptoms.length,
              itemBuilder: (context, index) {
                final symptom = state.symptoms[index];
                return _buildSymptomCard(t, symptom);
              },
            );
          }

          return Center(child: Text(t.noData));
        },
      ),
    );
  }

  Widget _buildSymptomCard(AppLocalizations t, SymptomModel symptom) {
    Color severityColor;
    Color textColor;

    switch (symptom.severity?.toLowerCase() ?? '') {
      case 'mild':
        severityColor = const Color(0xFFB8E6B8);
        textColor = const Color(0xFF2D5F2D);
        break;
      case 'moderate':
        severityColor = const Color(0xFFFFE4B5);
        textColor = const Color(0xFF8B6914);
        break;
      case 'severe':
        severityColor = const Color(0xFFFFB8B8);
        textColor = const Color(0xFF8B2020);
        break;
      default:
        severityColor = Colors.grey.shade300;
        textColor = Colors.grey.shade700;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    symptom.symptomName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    symptom.severity ?? t.notAvailable,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(symptom.recordedAt),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            if (symptom.notes != null && symptom.notes!.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                symptom.notes!,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
