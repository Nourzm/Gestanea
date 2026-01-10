import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/models/lab_result_model.dart';
import '../../../../core/services/image_storage_service.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import '../../logic/bloc/lab_results_state.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'edit_lab_result_page.dart';

class LabResultsListPage extends StatelessWidget {
  const LabResultsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lab Results'),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _showExportDialog(context);
            },
            tooltip: 'Export as ZIP',
          ),
        ],
      ),
      body: BlocConsumer<LabResultsBloc, LabResultsState>(
        listener: (context, state) {
          if (state is LabResultsExporting) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Exporting.. .')));
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
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          }

          if (state is LabResultsLoaded) {
            if (state.labResults.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.science_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No lab results yet! ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Upload your first lab result to get started. '),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeData.primaryColor,
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

          return const Center(child: Text('No data'));
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
    final imageStorage = ImageStorageService();
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final imagePath = result.reportImageUrl;
    final isRemoteUrl = imagePath != null && (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

    Color statusColor = const Color(0xFFB8E6B8);
    String status = 'Normal';

    // Simple interpretation based on ranges
    if (result.normalRangeMin != null &&
        result.normalRangeMax != null &&
        result.value != null) {
      if (result.value! < result.normalRangeMin!) {
        statusColor = const Color(0xFFFFE0B2);
        status = 'Low';
      } else if (result.value! > result.normalRangeMax!) {
        statusColor = const Color(0xFFFFB8B8);
        status = 'High';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          // Navigate to edit page with the existing bloc
          final bloc = context.read<LabResultsBloc>();
          final updated = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: bloc,
                child: EditLabResultPage(result: result),
              ),
            ),
          );
          
          // Refresh if updated
          if (updated == true) {
            if (context.mounted) {
              context.read<LabResultsBloc>().add(LoadLabResults());
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Thumbnail if image exists
              if (imagePath != null && imagePath.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: isRemoteUrl
                      ? Image.network(
                          imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            );
                          },
                        )
                      : FutureBuilder<File?>(
                          future: imageStorage.getImageAsync(imagePath),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Image.file(
                                snapshot.data!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            }
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image, color: Colors.grey),
                            );
                          },
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
                        Expanded(
                          child: Text(
                            result.testName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                          : 'N/A',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeData.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (result.normalRangeMin != null &&
                        result.normalRangeMax != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Normal: ${result.normalRangeMin}-${result.normalRangeMax} ${result.unit ?? ''}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
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
                            'Auto-extracted',
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
              title: const Text('Lab Result Image'),
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
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Result'),
        content: Text('Are you sure you want to delete ${result.testName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LabResultsBloc>().add(
                DeleteLabResult(result.id, result.reportImageUrl),
              );
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Export Lab Results'),
        content: const Text('Export all lab result images as a ZIP file? '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LabResultsBloc>().add(ExportLabResultsAsZip());
              Navigator.pop(dialogContext);
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}
