import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/services/ocr_service.dart';
import 'package:gestanea/core/services/image_storage_service.dart';
import 'package:gestanea/core/database/models/lab_result_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import '../pages/manual_lab_entry_page.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class OcrExtractionPage extends StatefulWidget {
  final File imageFile;

  const OcrExtractionPage({super.key, required this.imageFile});

  @override
  State<OcrExtractionPage> createState() => _OcrExtractionPageState();
}

class _OcrExtractionPageState extends State<OcrExtractionPage> {
  final OcrService _ocrService = OcrService();
  final ImageStorageService _imageStorage = ImageStorageService();

  bool _isExtracting = true;
  String _extractedText = '';
  Map<String, dynamic> _parsedData = {};
  String? _savedImagePath;

  @override
  void initState() {
    super.initState();
    _performOCR();
  }

  Future<void> _performOCR() async {
    try {
      // Save image first
      _savedImagePath = await _imageStorage.saveImage(widget.imageFile);

      // Extract text
      final text = await _ocrService.extractText(widget.imageFile);

      // Parse lab results
      final parsed = _ocrService.parseLabResults(text);

      setState(() {
        _extractedText = text;
        _parsedData = parsed;
        _isExtracting = false;
      });
    } catch (e) {
      setState(() {
        _isExtracting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OCR failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveResults() {
    // Allow saving even if no data was auto-extracted
    if (_savedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image saved.  Please try again.')),
      );
      return;
    }

    if (_parsedData.isEmpty) {
      // No OCR data - show dialog to enter manually or just save image
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('No Data Extracted'),
          content: const Text(
            'OCR could not extract lab results. Would you like to:\n\n1. Save just the image for reference\n2. Enter data manually',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Save image-only record
                final labResult = LabResultModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: 'current_user',
                  testName: 'Lab Report',
                  labDate: DateTime.now(),
                  reportImageUrl: _savedImagePath,
                  extractedByOcr: false,
                  createdAt: DateTime.now(),
                );

                context.read<LabResultsBloc>().add(AddLabResult(labResult));

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image saved!  You can add details later.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Save Image Only'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context); // Close OCR page
                // Navigate to manual entry
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManualLabEntryPage(),
                  ),
                );
              },
              child: const Text('Enter Manually'),
            ),
          ],
        ),
      );
      return;
    }

    // Save extracted results
    for (final entry in _parsedData.entries) {
      final data = entry.value as Map<String, dynamic>;
      final labResult = LabResultModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_${entry.key}',
        userId: 'current_user',
        testName: entry.key.toUpperCase(),
        value: data['value'],
        unit: data['unit'],
        labDate: DateTime.now(),
        reportImageUrl: _savedImagePath,
        extractedByOcr: true,
        createdAt: DateTime.now(),
      );

      context.read<LabResultsBloc>().add(AddLabResult(labResult));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lab results saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extract Lab Results'),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (!_isExtracting)
            IconButton(icon: const Icon(Icons.save), onPressed: _saveResults),
        ],
      ),
      body: _isExtracting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Extracting text from image...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      widget.imageFile,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Extracted Results
                  Text(
                    'Extracted Results',
                    style: AppTextStyles.headline2.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),

                  if (_parsedData.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Text(
                        'No lab results detected.  You can add them manually.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  else
                    ..._parsedData.entries.map((entry) {
                      final data = entry.value as Map<String, dynamic>;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: themeData.lightColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${data['value']} ${data['unit'] ?? ''}',
                              style: TextStyle(
                                fontSize: 16,
                                color: themeData.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 20),

                  // Raw extracted text
                  ExpansionTile(
                    title: const Text('View Raw Text'),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _extractedText.isEmpty
                              ? 'No text extracted'
                              : _extractedText,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeData.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Results',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
