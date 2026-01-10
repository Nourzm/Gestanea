import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/lab_result_model.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:gestanea/core/services/image_storage_service.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import 'manual_lab_entry_page.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:uuid/uuid.dart';

class PdfExtractionPage extends StatelessWidget {
  final String pdfPath;

  const PdfExtractionPage({super.key, required this.pdfPath});

  Future<void> _saveJustPdf(BuildContext context) async {
    try {
      // Get user ID from session
      final sessionManager = SessionManager();
      var userId = await sessionManager.getCurrentUserId();
      if (userId == null || userId.isEmpty) {
        userId = 'test_user_id';
        await sessionManager.saveCurrentUserId(userId);
      }
      
      // Upload PDF to Supabase storage
      final imageStorageService = ImageStorageService();
      final pdfFile = File(pdfPath);
      final uploadedUrl = await imageStorageService.savePdf(pdfFile, userId);
      
      final labResult = LabResultModel(
        id: const Uuid().v4(),
        userId: userId,
        testName: 'PDF Lab Report',
        labDate: DateTime.now(),
        reportImageUrl: uploadedUrl,
        extractedByOcr: false,
        createdAt: DateTime.now(),
      );

      context.read<LabResultsBloc>().add(AddLabResult(labResult));

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF saved and uploaded!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Lab Report'),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'PDF Saved',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'File: ${pdfPath.split('/').last}',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () => _saveJustPdf(context),
                icon: const Icon(Icons.save),
                label: const Text('Save PDF Reference'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeData.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManualLabEntryPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Enter Data Manually'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeData.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
