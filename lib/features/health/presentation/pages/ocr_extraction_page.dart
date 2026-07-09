import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/services/ocr_service.dart';
import 'package:gestanea/core/services/image_storage_service.dart';
import 'package:gestanea/core/database/models/lab_result_model.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/features/pregnancy/data/datasources/pregnancy_local_data_source.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import '../../data/services/lab_ai_service.dart';
import '../../data/services/lab_ai_consent.dart';
import '../widgets/lab_ai_result_sheet.dart';
import '../pages/manual_lab_entry_page.dart';

class OcrExtractionPage extends StatefulWidget {
  final File imageFile;

  const OcrExtractionPage({super.key, required this.imageFile});

  @override
  State<OcrExtractionPage> createState() => _OcrExtractionPageState();
}

class _OcrExtractionPageState extends State<OcrExtractionPage> {
  final OcrService _ocrService = OcrService();
  final ImageStorageService _imageStorage = ImageStorageService();

  final LabAiService _aiService = LabAiService();

  bool _isExtracting = true;
  String _extractedText = '';
  Map<String, dynamic> _parsedData = {};
  String? _savedImagePath;
  bool _aiAnalyzing = false;
  String? _aiSummary; // cached into the saved record's interpretation

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
            content: Text(AppLocalizations.of(context)!.ocrFailed('$e')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// One-time educational-not-diagnostic consent before AI is used.
  Future<bool> _confirmConsent() async {
    if (await LabAiConsent.hasAccepted()) return true;
    if (!mounted) return false;
    final t = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFAF0FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.aiDisclaimerTitle),
        content: SingleChildScrollView(child: Text(t.aiDisclaimerBody)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.main500,
              foregroundColor: Colors.white,
            ),
            child: Text(t.iUnderstandContinue),
          ),
        ],
      ),
    );
    if (ok == true) {
      await LabAiConsent.accept();
      return true;
    }
    return false;
  }

  /// Pulls the active pregnancy's week + trimester to give the model context.
  Future<({int? week, String? trimester})> _pregnancyContext() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return (week: null, trimester: null);
    final info = await PregnancyLocalDataSourceImpl()
        .calculatePregnancyWeekByStringId(authState.user.id);
    final week = info['currentWeek'] as int?;
    final trimester = info['trimester'] as String?;
    return (
      week: (week ?? 0) > 0 ? week : null,
      trimester: trimester == 'N/A' ? null : trimester,
    );
  }

  Future<void> _analyzeWithAi() async {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    if (!_aiService.isAvailable) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.aiNeedsConnection)));
      return;
    }
    if (!await _confirmConsent()) return;
    if (!mounted) return;

    setState(() => _aiAnalyzing = true);
    try {
      final ctx = await _pregnancyContext();
      final result = await _aiService.analyze(
        image: widget.imageFile,
        ocrText: _extractedText,
        week: ctx.week,
        trimester: ctx.trimester,
        locale: locale,
      );
      if (!mounted) return;
      setState(() => _aiSummary = result.overallSummary);
      await showLabAiResultSheet(context, result);
    } on LabAiException catch (e) {
      if (!mounted) return;
      final msg = e.code == 'rate_limited'
          ? t.aiRateLimited
          : e.code == 'offline'
          ? t.aiNeedsConnection
          : t.aiAnalysisFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _aiAnalyzing = false);
    }
  }

  void _saveResults() {
    final t = AppLocalizations.of(context)!;
    // Allow saving even if no data was auto-extracted
    if (_savedImagePath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.noImageSaved)));
      return;
    }

    if (_parsedData.isEmpty) {
      // No OCR data - show dialog to enter manually or just save image
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(t.noDataExtracted),
          content: Text(t.ocrNoResultsPrompt),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Save image-only record
                final labResult = LabResultModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: '', // real owner is stamped by the bloc on insert
                  testName: t.labReport,
                  labDate: DateTime.now(),
                  reportImageUrl: _savedImagePath,
                  extractedByOcr: false,
                  interpretation: _aiSummary,
                  createdAt: DateTime.now(),
                );

                context.read<LabResultsBloc>().add(AddLabResult(labResult));

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t.imageSavedAddLater),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(t.saveImageOnly),
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
              child: Text(t.enterManually),
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
        userId: '', // real owner is stamped by the bloc on insert
        testName: entry.key.toUpperCase(),
        value: data['value'],
        unit: data['unit'],
        labDate: DateTime.now(),
        reportImageUrl: _savedImagePath,
        extractedByOcr: true,
        interpretation: _aiSummary,
        createdAt: DateTime.now(),
      );

      context.read<LabResultsBloc>().add(AddLabResult(labResult));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.labResultsSaved), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.extractLabResults),
        backgroundColor: AppColors.main500,
        foregroundColor: Colors.white,
        actions: [
          if (!_isExtracting) ...[
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: t.analyzeWithAi,
              onPressed: _aiAnalyzing ? null : _analyzeWithAi,
            ),
            IconButton(icon: const Icon(Icons.save), onPressed: _saveResults),
          ],
        ],
      ),
      body: _isExtracting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(t.extractingText),
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
                    t.extractedResults,
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
                      child: Text(
                        t.noLabResultsDetected,
                        style: const TextStyle(color: Colors.orange),
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
                          border: Border.all(color: AppColors.main300),
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
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.main500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 20),

                  // Raw extracted text
                  ExpansionTile(
                    title: Text(t.viewRawText),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _extractedText.isEmpty
                              ? t.noTextExtracted
                              : _extractedText,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // AI analysis button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _aiAnalyzing ? null : _analyzeWithAi,
                      icon: _aiAnalyzing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.auto_awesome),
                      label: Text(
                        _aiAnalyzing ? t.aiAnalyzing : t.analyzeWithAi,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.main600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.main500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.saveResults,
                        style: const TextStyle(
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
