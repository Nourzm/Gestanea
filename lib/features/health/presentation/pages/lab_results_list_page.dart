import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/models/lab_result_model.dart';
import '../../../../core/services/image_storage_service.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import '../../logic/bloc/lab_results_state.dart';

class LabResultsListPage extends StatelessWidget {
  const LabResultsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.myLabResults),
        backgroundColor: AppColors.main500,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _showExportDialog(context);
            },
            tooltip: t.exportAsZip,
          ),
        ],
      ),
      body: BlocConsumer<LabResultsBloc, LabResultsState>(
        listener: (context, state) {
          if (state is LabResultsExporting) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(t.exporting)));
          }
        },
        builder: (context, state) {
          if (state is LabResultsLoading || state is LabResultsExporting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LabResultsError) {
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

          if (state is LabResultsLoaded) {
            if (state.labResults.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.science_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.noLabResultsYet,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(t.uploadFirstLabResult),
                  ],
                ),
              );
            }

            // Group results by date
            final groupedResults = _groupByDate(state.labResults);

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedResults.length,
              itemBuilder: (context, index) {
                final date = groupedResults.keys.elementAt(index);
                final results = groupedResults[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        DateFormat('MMMM dd, yyyy').format(date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main500,
                        ),
                      ),
                    ),
                    // Results for this date
                    ...results.map(
                      (result) => _buildLabResultCard(context, result),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            );
          }

          return Center(child: Text(t.noData));
        },
      ),
    );
  }

  Map<DateTime, List<LabResultModel>> _groupByDate(
    List<LabResultModel> results,
  ) {
    final Map<DateTime, List<LabResultModel>> grouped = {};

    for (final result in results) {
      final dateOnly = DateTime(
        result.labDate.year,
        result.labDate.month,
        result.labDate.day,
      );

      if (!grouped.containsKey(dateOnly)) {
        grouped[dateOnly] = [];
      }
      grouped[dateOnly]!.add(result);
    }

    return grouped;
  }

  Widget _buildLabResultCard(BuildContext context, LabResultModel result) {
    final t = AppLocalizations.of(context)!;
    final imageStorage = ImageStorageService();
    final imageFile = imageStorage.getImage(result.reportImageUrl);

    Color statusColor = const Color(0xFFB8E6B8);
    String status = t.normalLabel;

    // Simple interpretation based on ranges
    if (result.normalRangeMin != null &&
        result.normalRangeMax != null &&
        result.value != null) {
      if (result.value! < result.normalRangeMin!) {
        statusColor = const Color(0xFFFFE0B2);
        status = t.low;
      } else if (result.value! > result.normalRangeMax!) {
        statusColor = const Color(0xFFFFB8B8);
        status = t.high;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (imageFile != null) {
            _showImageDialog(context, imageFile);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Thumbnail if image exists
              if (imageFile != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    imageFile,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Result details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          result.testName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      result.value != null
                          ? '${result.value} ${result.unit ?? ''}'
                          : t.notAvailable,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.main500,
                      ),
                    ),
                    if (result.normalRangeMin != null &&
                        result.normalRangeMax != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        t.normalRangeValue(
                          '${result.normalRangeMin}',
                          '${result.normalRangeMax}',
                          result.unit ?? '',
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    if (result.extractedByOcr) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            t.autoExtracted,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.amber.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(context, result);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(AppLocalizations.of(context)!.labResultImage),
              automaticallyImplyLeading: true,
              backgroundColor: AppColors.main500,
              foregroundColor: Colors.white,
            ),
            InteractiveViewer(child: Image.file(imageFile)),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, LabResultModel result) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.deleteResult),
        content: Text(t.deleteResultConfirm(result.testName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<LabResultsBloc>().add(
                DeleteLabResult(result.id, result.reportImageUrl),
              );
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(t.delete),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.exportLabResults),
        content: Text(t.exportZipConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<LabResultsBloc>().add(ExportLabResultsAsZip());
              Navigator.pop(dialogContext);
            },
            child: Text(t.export),
          ),
        ],
      ),
    );
  }
}
