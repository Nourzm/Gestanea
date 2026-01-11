import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/services/ocr_service.dart';
import 'package:gestanea/core/services/image_storage_service.dart';
import 'package:gestanea/core/database/models/lab_result_model.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import '../pages/manual_lab_entry_page.dart';
import '../pages/review_ocr_results_page.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:uuid/uuid.dart';

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
      // Get userId
      final sessionManager = SessionManager();
      var userId = await sessionManager.getCurrentUserId();
      if (userId == null || userId.isEmpty) {
        userId = 'anonymous';
      }
      
      // Save image first
      _savedImagePath = await _imageStorage.saveImage(widget.imageFile, userId);

      // Use row-based parsing with bounding boxes
      final parsed = await _ocrService.parseLabResultsWithBoxes(widget.imageFile);
      print('Parsed Results: $parsed');

      setState(() {
        _extractedText = parsed.isEmpty 
            ? 'No results detected. Please enter manually.'
            : 'Found ${parsed.length} test(s). Review and edit as needed.';
        _parsedData = parsed;
        _isExtracting = false;
      });
    } catch (e) {
      print('OCR Error: $e');
      setState(() {
        _extractedText = 'OCR processing failed. Please enter results manually.';
        _parsedData = {};
        _isExtracting = false;
      });
    }
  }

  Future<void> _saveResults() async {
    // Allow saving even if no data was auto-extracted
    if (_savedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noImageSaved)),
      );
      return;
    }

    if (_parsedData.isEmpty) {
      // No OCR data - show dialog to enter manually or just save image
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.noDataExtracted),
          content: const Text(
            'OCR could not extract lab results. Would you like to:\n\n1. Save just the image for reference\n2. Enter data manually',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                // Save image-only record
                final sessionManager = SessionManager();
                var userId = await sessionManager.getCurrentUserId();
                if (userId == null || userId.isEmpty) {
                  userId = 'test_user_id';
                  await sessionManager.saveCurrentUserId(userId);
                }
                
                final labResult = LabResultModel(
                  id: const Uuid().v4(),
                  userId: userId,
                  testName: 'Lab Report',
                  labDate: DateTime.now(),
                  reportImageUrl: _savedImagePath,
                  extractedByOcr: false,
                  createdAt: DateTime.now(),
                );

                context.read<LabResultsBloc>().add(AddLabResult(labResult));

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.imageSaved),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.saveImageOnly),
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
              child: Text(AppLocalizations.of(context)!.enterManually),
            ),
          ],
        ),
      );
      return;
    }

    // Navigate to review screen to edit before saving
    final extractedResults = _parsedData.values
        .map((data) => Map<String, dynamic>.from(data as Map<String, dynamic>))
        .toList();

    // Always allow review, even if no results extracted
    // If no results, start with empty list and user can add manually
    
    // Get the bloc from current context before navigation
    final labResultsBloc = context.read<LabResultsBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newContext) => BlocProvider.value(
          value: labResultsBloc,
          child: ReviewOcrResultsPage(
            extractedResults: extractedResults,
            imagePath: _savedImagePath,
          ),
        ),
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
        title: Text(AppLocalizations.of(context)!.extractLabResults),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isExtracting)
            IconButton(icon: const Icon(Icons.save), onPressed: _saveResults),
        ],
      ),
      body: _isExtracting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.extractingTextFromImage),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    data['testName']?.toString().toUpperCase() ?? entry.key.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${data['value'] ?? '?'} ${data['unit'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: themeData.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            if (data['normalRangeMin'] != null && data['normalRangeMax'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Normal Range: ${data['normalRangeMin']} - ${data['normalRangeMax']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                            if (data['interpretation'] != null) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: data['interpretation'] == 'Normal' 
                                      ? Colors.green.shade50 
                                      : data['interpretation'] == 'High'
                                          ? Colors.red.shade50
                                          : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  data['interpretation'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: data['interpretation'] == 'Normal' 
                                        ? Colors.green.shade700 
                                        : data['interpretation'] == 'High'
                                            ? Colors.red.shade700
                                            : Colors.orange.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 20),

                  // Raw extracted text
                  ExpansionTile(
                    title: Text(AppLocalizations.of(context)!.viewRawText),
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

                  // Review & Edit button (always show)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveResults,
                      icon: Icon(_parsedData.isEmpty ? Icons.add : Icons.edit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeData.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      label: Text(
                        _parsedData.isEmpty ? 'Enter Results Manually' : 'Review & Edit Results',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  if (_parsedData.isEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'OCR couldn\'t extract test results. You can enter them manually.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
